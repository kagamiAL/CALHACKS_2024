extends Control

@onready var level: Label = $%Level


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func change_indicated_level(new_level: int):
	level.text = "Level " + str(new_level)

func _on_restart_pressed():
	get_node("/root/SceneSwitch").goto_scene("res://scenes/Main/Game.tscn")
