extends Node2D

@export_range(0, 30, 0.01, "suffix:px") var radius : float

@export var color : Color

@export var shaking = false

@export_range(0, 1, 0.01, "suffix:px") var max_shake : float

func _draw():
	draw_circle(Vector2(), radius, color)

func _process(delta):
	if shaking:
		position = Vector2(randf_range(-max_shake, max_shake), randf_range(-max_shake, max_shake))
	else:
		position.y = 0
		position.x = 0
