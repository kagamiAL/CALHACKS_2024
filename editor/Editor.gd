extends Node2D

func _on_mode_item_selected(index):
	# Reset all
	$%PanControl.hide()
	# Match
	match index:
		0:
			$%PanControl.show()
