extends RigidBody2D

@export var SPEED = 20
const SLOWDOWN = 10
const JUMP_VELOCITY = -600.0
const SKEW_SPEED = 0.1

@export var trampoline_bounce_amt = 0

@onready var initial_time = Time.get_ticks_msec()

signal died

signal won

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	
func _process(delta):
	$%Time.text = "%.2f" % ((Time.get_ticks_msec() - initial_time) / 1000.)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		linear_velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("jump")
		linear_velocity.y = JUMP_VELOCITY
		linear_velocity.x *= 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	play_animations(direction)
	if direction:
		linear_velocity.x += direction * SPEED# * (1 if is_on_floor() else 0.5)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SLOWDOWN)
	
	$RayCast2D.position = global_position

func play_animations(dir_x):
	pass
	if is_on_floor() and abs(dir_x) > 0.1:
		$Sprite.shaking = true
	else:
		$Sprite.shaking = false

func handle_tile_collision(tilemap_layer):
	match tilemap_layer:
		0:
			return
			
		1: # Trampoline
			linear_velocity.y = -trampoline_bounce_amt
		
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
	# Hide sprite
	$Sprite.hide()
	$%Time.hide()
	# All our food keeps BLOWING UP
	$GPUParticles2D.emitting = true
	# finally
	emit_signal("died")

func reset():
	set_process(true)
	set_physics_process(true)
	set_deferred("freeze", false)
	# Show sprite
	$Sprite.show()
	$Time.show()
	$GPUParticles2D.emitting = false
	# Restart timer
	initial_time = Time.get_ticks_msec()

func is_on_floor():
	return $RayCast2D.is_colliding()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	var layer = body.get_layer_for_body_rid(body_rid)
	handle_tile_collision(layer)
