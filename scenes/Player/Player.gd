extends CharacterBody2D

const SPEED = 20
const SLOWDOWN = 10
const JUMP_VELOCITY = -600.0

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
		velocity.y = JUMP_VELOCITY
		velocity.x *= 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x += direction * SPEED * (1 if is_on_floor() else 0.5)
	else:
		velocity.x = move_toward(velocity.x, 0, SLOWDOWN)

	move_and_slide()
