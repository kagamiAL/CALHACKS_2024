extends Control

@export var marker : Sprite2D

@export var tilemap : TileMap

@export var tile_option_button : OptionButton

@export var marker_offset : Vector2

var marker_position : Vector2i = Vector2i(0, 0)

func _on_gui_input(event):
	if event is InputEventMouseMotion:
			var mouse_pos = marker.get_global_mouse_position()
			marker_position = Vector2i(
				floor(mouse_pos.x / 64),
				floor(mouse_pos.y / 64)
			)
			marker.position = Vector2(marker_position * 64) + marker_offset
	# Add
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Get an alternate tile (yes Godot has hard-coded tiles
		# for each rotation) based on the rotation of the marker
		var alt = 0 # Alternative tile
		if marker.rotation_degrees == 270:
			alt = TileSetAtlasSource.TRANSFORM_FLIP_H
		elif marker.rotation_degrees == 180:
			alt = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V
		elif marker.rotation_degrees == 90:
			alt = TileSetAtlasSource.TRANSFORM_FLIP_V
		# Sets the tile
		match tile_option_button.get_selected_id():
			# Block
			0:
				tilemap.set_cell(0, marker_position, 1, Vector2i(0, 0))
			# Slope
			1:
				tilemap.set_cell(0, marker_position, 1, Vector2i(1, 1), alt)
			# Goal
			2:
				tilemap.set_cell(3, marker_position, 1, Vector2i(2, 0))
			# Trampoline
			3:
				tilemap.set_cell(1, marker_position, 1, Vector2i(0, 1), alt)
			# Speed
			4:
				tilemap.set_cell(0, marker_position, 1, Vector2i(3, 1), alt)
			# Spike :3
			5:
				tilemap.set_cell(2, marker_position, 1, Vector2i(1, 0), alt)
	# Erase
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		for layer in range(tilemap.get_layers_count()):
			tilemap.set_cell(layer, marker_position, 0)
