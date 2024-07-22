extends Control

var maps = {}

func _ready():
	# Creates root map node
	$%MapTree.create_item()

func _on_new_map_pressed():
	var item = $%MapTree.create_item()
	item.set_text(0, "New Map")
	item.set_editable(0, true)


func _on_move_up_pressed():
	var selected = $%MapTree.get_selected()
	if selected:
		selected.move_before(selected.get_prev())

func _on_move_down_pressed():
	var selected = $%MapTree.get_selected()
	if selected:
		selected.move_after(selected.get_next())


func _on_delete_map_pressed():
	var selected = $%MapTree.get_selected()
	if selected:
		$%MapTree.get_root().remove_child(selected)

func _on_map_tree_item_selected():
	$%SubViewportContainer.show()
	# Resets editor and tries to load new map
	$%Editor.reset()
	var selected = $%MapTree.get_selected()
	if selected and selected in maps:
		$%Editor.load_json(maps[selected])


func _on_file_id_pressed(id):
	match id:
		0:
			hide()
		1:
			maps = {}
			$%MapTree.clear()
			$%MapTree.create_item()
			$%SubViewportContainer.hide()
		2:
			$LoadDialog.show()
		3:
			if FileAccess.file_exists($SaveDialog.get_current_file()):
				_on_save_dialog_file_selected($SaveDialog.get_current_file())
			if FileAccess.file_exists($LoadDialog.get_current_file()):
				_on_save_dialog_file_selected($LoadDialog.get_current_file())
			else:
				$SaveDialog.show()
		4:
			$SaveDialog.show()

# If the editor modified its TileMap, save the map.
func _on_editor_modified():
	var selected = $%MapTree.get_selected()
	if selected:
		maps[selected] = $%Editor.export_json()

func _on_save_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(export_json()))
	file.close()
	
func _on_load_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.READ)
	load_json(JSON.parse_string(file.get_as_text()))
	file.close()

# Export to JSON (raw)
func export_json():
	var maps_cleaned = [];
	var map = $%MapTree.get_root().get_first_child()
	while map != null:
		maps_cleaned.append({
			"name": map.get_text(0),
			"data": self.maps[map] if map in self.maps else {}
		})
		map = map.get_next()
	return {
		"maps": maps_cleaned
	}

# Load from JSON (parsed)
func load_json(input):
	maps = {}
	# Clears MapTree
	if $%MapTree.get_root() != null:
		var map = $%MapTree.get_root().get_first_child()
		var map_tree_maps = []
		while map != null:
			map_tree_maps.append(map)
			map = map.get_next()
		for map_1 in map_tree_maps:
			map_1.free()
	# Loads maps
	for map in input["maps"]:
		var item = $%MapTree.create_item()
		item.set_text(0, map["name"])
		item.set_editable(0, true)
		self.maps[item] = map["data"]
	# Hides subviewport
	$%SubViewportContainer.hide()
