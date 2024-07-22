extends TileMap

# TODO: new format: type, position, rotation (degrees so we can store as an integer)

# Exports to a JSON (not string)
func export_json():
	var exported = []
	for layer in range(get_layers_count()):
		for tile_pos in get_used_cells(layer):
			var atlas_coords = get_cell_atlas_coords(layer, tile_pos)
			exported.append({
				"layer": layer,
				"position": [tile_pos.x, tile_pos.y],
				"id": get_cell_source_id(layer, tile_pos),
				"atlas_coords": [atlas_coords.x, atlas_coords.y],
				"alternative_tile": get_cell_alternative_tile(layer, tile_pos)
			})
	return exported

# Loads from a JSON (parsed)
func load_json(input):
	for tile in input:
		set_cell(
			tile["layer"],
			Vector2(tile["position"][0], tile["position"][1]),
			tile["id"],
			Vector2i(tile["atlas_coords"][0], tile["atlas_coords"][1]),
			tile["alternative_tile"]
		)
