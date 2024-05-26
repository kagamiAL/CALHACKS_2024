extends RigidBody2D

@export var SPEED = 20
const SLOWDOWN = 10
const JUMP_VELOCITY = -600.0
const SKEW_SPEED = 0.1

@export var trampoline_bounce_amt = 0

@onready var initial_time = Time.get_ticks_msec()

@export_range(0, 1) var jump_slow_factor : float = 1

var _collisions = []

signal died

signal won

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Used to set position of a rigidbody since it is updated on every physics process
var reset_state = false
var moveVector: Vector2

#Used to handle contact audio request
var contact_audio_request: bool = false

#Used to shoot raycast to prevent clipping in walls
var last_position: Vector2;

func _process(delta):
	$%Time.text = "%.2f" % ((Time.get_ticks_msec() - initial_time) / 1000.)

func _physics_process(delta):
	#Prevent wall clipping
	detect_wall_clipping()

	# Add the gravity.
	if not is_on_floor():
		contact_audio_request = true
		linear_velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("jump")
		$JumpAudio.play()
		linear_velocity.y = JUMP_VELOCITY
		linear_velocity.x *= jump_slow_factor

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		linear_velocity.x += direction * SPEED# * (1 if is_on_floor() else 0.5)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SLOWDOWN)

	$RayCast2D.position = global_position
	for object in get_colliding_bodies():
		if object is TileMap:
			for collision in _collisions:
				var layer = object.get_layer_for_body_rid(collision)
				handle_tile_collision(layer)

	# Who up rolling they boulder (rolling SFX)
	# TODO hard coded stop hard coding magic numbers idiot
	$RollingTheyBoulder.volume_db = linear_velocity.x/100
	if is_on_floor() and linear_velocity.x != 0:
		if not $RollingTheyBoulder.playing: $RollingTheyBoulder.play()
	else:
		$RollingTheyBoulder.stop()

func handle_tile_collision(tilemap_layer):
	match tilemap_layer:
		0:
			if contact_audio_request:
				contact_audio_request = false
				$ContactAudio.play()
			return

		1: # Trampoline
			linear_velocity.y = -trampoline_bounce_amt
			$JumpAudio.play()

		2: # Spike
			kill()

		3:
			emit_signal("won")

func kill():
	# Killing is fun!
	# - Thi Dinh
	# Can't _process/move
	set_process(false)
	set_physics_process(false)
	set_deferred("freeze", true)
	linear_velocity = Vector2()
	# Hide sprite
	$Sprite.hide()
	$%Time.hide()
	# Play death sound
	$RollingTheyBoulder.stop()
	$DeathAudio.play()
	# All our food keeps BLOWING UP
	$GPUParticles2D.emitting = true
	# finally
	emit_signal("died")

func reset():
	set_process(true)
	set_physics_process(true)
	set_deferred("freeze", false)
	linear_velocity = Vector2()
	# Show sprite
	$Sprite.show()
	$%Time.show()
	$GPUParticles2D.emitting = false
	# Restart velocity + position
	move_body(Vector2.ZERO)

func is_on_floor():
	return $RayCast2D.is_colliding()

func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, moveVector)
		reset_state = false

func move_body(targetPos: Vector2):
	moveVector = targetPos;
	reset_state = true;

func detect_wall_clipping():
	if last_position:
		#Since RayCast2D Node is a weirdo we will directly calculate a raycast
		var space_state = get_world_2d().direct_space_state
		#Shoot a ray from last position to current
		var query = PhysicsRayQueryParameters2D.create(last_position, self.global_position)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			print("Player collided with ", result.collider.name)
			move_body(last_position)
			return
	last_position = self.global_position

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_collisions.append(body_rid)

func _on_area_2d_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	_collisions.remove_at(_collisions.find(body_rid))
