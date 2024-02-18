extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Play as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var scene_switch = get_node("/root/SceneSwitch")
@onready var scene_transition = preload("res://scenes/Main/SceneTransition.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	quit_button.button_down.connect(on_quit_pressed)
	start_button.button_down.connect(on_play_pressed)

func on_quit_pressed():
	get_tree().quit()

func on_play_pressed():
	var transition = scene_transition.instantiate()
	add_child(transition)
	await transition.play_transition()
	transition.queue_free()
	scene_switch.goto_scene("res://scenes/Main/Game.tscn")
