extends Control

var leaderboard_object;

func _ready():
	$%Play.grab_focus()

func _on_play_pressed():
	$%Levels.show()

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
	$%Editor.show()


func _on_editor_visibility_changed():
	if $%Editor.visible:
		$MapTheme.play()
		$SoundAnimationPlayer.play("crossfade")
	else:
		$SoundAnimationPlayer.play_backwards("crossfade")
