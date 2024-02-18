extends Node2D

@export_range(0, 30, 0.01, "suffix:px") var radius : float

@export var color : Color

func _draw():
	draw_circle(Vector2(), radius, color)
