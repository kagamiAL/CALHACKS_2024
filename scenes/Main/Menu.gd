extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Play as Button
@onready var quit_button = $MarginContainer/HBoxContainer/VBoxContainer/Quit as Button
@onready var gameNode = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready():
	quit_button.button_down.connect(on_quit_pressed)
	start_button.button_down.connect(on_play_pressed)

func on_quit_pressed():
	get_tree().quit()

func on_play_pressed():
	gameNode.load_current_level()