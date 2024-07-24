extends Area2D

@export var speed : float

func _on_body_entered(body):
	if body.is_in_group("player"):
		var rotated = Vector2(speed, 0).rotated(global_rotation)
		if int(rotation_degrees) % 180 == 0:
			body.linear_velocity.x = rotated.x
		elif int(rotation_degrees) % 90 == 0:
			body.linear_velocity.y = rotated.y
