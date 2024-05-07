extends Control

@onready var time_label: Label = $CanvasLayer/VBoxContainer/Time as Label

var player_time: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	time_label.text = "Time: " + str(player_time)
	$CanvasLayer/VBoxContainer/Restart.grab_focus()

func _on_main_menu_pressed():
	get_node("/root/SceneSwitch").goto_scene("res://scenes/Main/Main.tscn")


func _on_restart_pressed():
	get_node("/root/SceneSwitch").goto_scene("res://scenes/Main/Game.tscn")
