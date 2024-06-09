extends Control

@onready var switch_scene = get_node("/root/SceneSwitch")


func set_time(time : float):
	$%Time.text = "Time: " + str(time)
	get_node("/root/LeaderboardData").append_leaderboard(time)


func _on_visibility_changed():
	$CanvasLayer.visible = visible


func _on_main_menu_pressed():
	switch_scene.goto_scene("res://scenes/Main/Main.tscn")
