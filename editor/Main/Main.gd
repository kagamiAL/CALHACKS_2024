extends Control

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
	print(true)
	# TODO: Tell the map editor in the SubViewport that there's a new map
	# TODO: keep track of map data


func _on_file_id_pressed(id):
	match id:
		0:
			hide()
