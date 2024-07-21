extends Control

var pan_start : Vector2;

@export var camera : Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if visible:
		if event is InputEventMouseMotion:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var mouse_position = get_local_mouse_position()
				if pan_start.x != 0 and pan_start.y != 0:
					camera.position -= (mouse_position - pan_start) * 1/camera.zoom
				pan_start = mouse_position
		if event is InputEventMouseButton and (pan_start.x != 0 or pan_start.y != 0):
				pan_start.x = 0
				pan_start.y = 0
		if event is InputEventMouseButton and event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					camera.zoom *= 1.25
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					camera.zoom *= 0.75
