extends Control

@onready var scene_switch = get_node("/root/SceneSwitch")
@onready var scene_transition = preload("res://scenes/Main/SceneTransition.tscn")

func _on_play_button_down():
	var transition = scene_transition.instantiate()
	add_child(transition)
	await transition.play_transition()
	transition.queue_free()
	scene_switch.goto_scene("res://scenes/Main/Game.tscn")

func _on_quit_button_down():
	get_tree().quit()

