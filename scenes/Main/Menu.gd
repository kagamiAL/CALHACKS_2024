extends Control

@onready var scene_switch = get_node("/root/SceneSwitch")
@onready var scene_transition = preload("res://scenes/Main/SceneTransition.tscn")
@onready var leaderboard_scene = preload("res://scenes/UI/LeaderBoard.tscn")

var leaderboard_object;

func _ready():
	leaderboard_object = leaderboard_scene.instantiate()
	leaderboard_object.visible = false
	add_child(leaderboard_object)

func _on_play_button_down():
	var transition = scene_transition.instantiate()
	add_child(transition)
	await transition.play_transition()
	transition.queue_free()
	scene_switch.goto_scene("res://scenes/Main/Game.tscn")

func _on_quit_button_down():
	get_tree().quit()

func _on_leaderboard_button_down():
	leaderboard_object._update_leaderboard()
	leaderboard_object.visible = true
