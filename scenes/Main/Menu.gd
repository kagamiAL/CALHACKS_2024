extends Control

@onready var scene_switch = get_node("/root/SceneSwitch")
@onready var scene_transition = load("res://scenes/Main/SceneTransition.tscn")

var leaderboard_object;

func _ready():
	$%Play.grab_focus()

func _on_play_pressed():
	var transition = scene_transition.instantiate()
	add_child(transition)
	await transition.play_transition()
	transition.queue_free()
	scene_switch.goto_scene("res://scenes/Main/Game.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_leaderboard_pressed():
	$%LeaderBoard._update_leaderboard()
	$%LeaderBoard.visible = true

func _on_settings_pressed():
	$%Settings.visible = true

func _process(_delta):
	$Camera2D.zoom.x = max(1, get_viewport_rect().size.x / 1216)
	$Camera2D.zoom.y = $Camera2D.zoom.x


func _on_map_editor_pressed():
	$%EditorMainMenu.show()
