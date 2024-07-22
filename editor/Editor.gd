extends Node2D

signal modified

func _on_mode_item_selected(index):
	# Reset all
	$%PanControl.hide()
	$%AddControl.hide()
	$AddMarker.hide()
	# Match
	match index: # TODO: index -> id
		0:
			$%PanControl.show()
		1:
			$%AddControl.show()
			$AddMarker.show()

# Updates AddMarker
# TODO: find a way to make this not hard-coded
func _on_option_button_item_selected(index):
	match index: # TODO: index -> id
		# Block
		0:
			$AddMarker.region_rect.position = Vector2(0,0)
		# Slope
		1:
			$AddMarker.region_rect.position = Vector2(64,64)
		# Goal
		2:
			$AddMarker.region_rect.position = Vector2(128,0)
		# Trampoline
		3:
			$AddMarker.region_rect.position = Vector2(0,64)
		# Speed
		4:
			$AddMarker.region_rect.position = Vector2(64*3,64)
		# Spike :3
		5:
			$AddMarker.region_rect.position = Vector2(64,0)

# yeah i'm using degrees instead of radians... i'm a sellout......
func _on_right_90_pressed():
	$AddMarker.rotation_degrees -= 90
	# Wrap around 0 >= r >= 270
	if $AddMarker.rotation_degrees == -90:
		$AddMarker.rotation_degrees = 270


func _on_left_90_pressed():
	$AddMarker.rotation_degrees += 90
	if $AddMarker.rotation_degrees == 360:
		$AddMarker.rotation_degrees = 0

# Clears tilemap and resets camera position/zoom
func reset():
	$Camera2D.position = Vector2(0, 0)
	$Camera2D.zoom = Vector2(1, 1)
	$TileMap.clear()

# Exports to a JSON (not string)
func export_json():
	return $TileMap.export_json()

# Loads from a JSON (parsed)
func load_json(input):
	$TileMap.load_json(input)


func _on_add_control_modified():
	emit_signal("modified")
