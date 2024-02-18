extends CharacterBody2D

const SPEED = 20
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
	$Time.text = "%.2f" % ((Time.get_ticks_msec() - initial_time) / 1000.)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		$AnimationPlayer.play("jump")
		velocity.y = JUMP_VELOCITY
		velocity.x *= 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	play_animations(direction)
	if direction:
		velocity.x += direction * SPEED * (1 if is_on_floor() else 0.5)
	else:
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN)

	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider() is TileMap:
			var layer = collision.get_collider().get_layer_for_body_rid(collision.get_collider_rid())
			handle_tile_collision(layer)


func play_animations(dir_x):
	$Sprite.skew = move_toward($Sprite.skew, dir_x * 0.5 if is_on_floor() else 0, SKEW_SPEED)
	if is_on_floor() and abs(dir_x) > 0.1:
		$Sprite.shaking = true
	else:
		$Sprite.shaking = false

func handle_tile_collision(tilemap_layer):
	match tilemap_layer:
		0:
			return
			
		1: # Trampoline
			velocity.y = -trampoline_bounce_amt
		
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
	# Hide sprite
	$Sprite.hide()
	# All our food keeps BLOWING UP
	$GPUParticles2D.emitting = true
	# finally
	emit_signal("died")
