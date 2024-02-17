extends CharacterBody2D

const SPEED = 20
const SLOWDOWN = 10
const JUMP_VELOCITY = -600.0
const SKEW_SPEED = 0.1

@onready var initial_time = Time.get_ticks_msec()

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
		$AnimatedSprite2D.play("jump")
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

func play_animations(dir_x):
	$AnimatedSprite2D.skew = move_toward($AnimatedSprite2D.skew, dir_x * 0.5 if is_on_floor() else 0, SKEW_SPEED)
	if is_on_floor() and not is_playing_animation("jump"):
		if dir_x > 0.1:
			$AnimatedSprite2D.play("move_forward")
		elif dir_x < -0.1:
			$AnimatedSprite2D.play("move_backward")
	elif is_playing_animation("move_forward") or is_playing_animation("move_backward"):
		$AnimatedSprite2D.play("default")

func is_playing_animation(animation):
	return $AnimatedSprite2D.is_playing() and $AnimatedSprite2D.animation == animation
