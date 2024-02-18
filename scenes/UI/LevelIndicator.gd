extends Control

@onready var level: Label = $%Level


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func change_indicated_level(new_level: int):
	level.text = "Level " + str(new_level)
