extends Control

@onready var switch_scene = get_node("/root/SceneSwitch")

@onready var time_label: Label = $CanvasLayer/VBoxContainer/Time as Label
@onready var main_menu_button: Button = $CanvasLayer/VBoxContainer/Button as Button

var player_time: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	time_label.text = "Time: " + str(player_time)
	main_menu_button.button_down.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed():
	switch_scene.goto_scene("res://scenes/Main/Main.tscn")
