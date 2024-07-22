extends Control

@onready var level: Label = $%Level

signal restart_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_label(level_name: String, new_level: int, levels: int):
	level.text = "%s, %d/%d" % [level_name, new_level, levels]

func _on_restart_pressed():
	emit_signal("restart_pressed")
