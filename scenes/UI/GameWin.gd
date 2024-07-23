extends CanvasLayer

func set_time(time : float):
	$%Time.text = "Time: " + str(time)
	get_node("/root/LeaderboardData").append_leaderboard(time)


func _on_main_menu_pressed():
	get_node("/root/SceneSwitch").goto_scene("res://scenes/Main/Main.tscn")
