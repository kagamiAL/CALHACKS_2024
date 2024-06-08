extends Area2D

@export var speed : float

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.linear_velocity += Vector2(speed, 0).rotated(global_rotation)
