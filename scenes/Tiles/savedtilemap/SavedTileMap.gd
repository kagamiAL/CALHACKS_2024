extends TileMap

# names are lowercase
# values are stored as layer, id, atlas_coords
const ENTITY_CONVERSION_KEY = {
	"block": [0, 1, Vector2i(0, 0)],
	"slope": [0, 1, Vector2i(1, 1)],
	"goal": [3, 1, Vector2i(2, 0)],
	"trampoline": [1, 1, Vector2i(0, 1)],
	"speed": [0, 1, Vector2i(3, 1)],
	"spike": [2, 1, Vector2i(1, 0)]
}

# Rotation <-> alternative tile conversion
const ROTATION_KEY = {
	270: TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_TRANSPOSE,
	180: TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H,
	90: TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_TRANSPOSE,
	0: 0
}

# Exports to a JSON (not string)
func export_json():
	var exported = []
	for layer in range(get_layers_count()):
		for tile_pos in get_used_cells(layer):
			exported.append({
				"type": ENTITY_CONVERSION_KEY.find_key([
					layer,
					get_cell_source_id(layer, tile_pos),
					get_cell_atlas_coords(layer, tile_pos)
				]),
				"position": [tile_pos.x, tile_pos.y],
				"rotation": ROTATION_KEY.find_key(get_cell_alternative_tile(layer, tile_pos))
			})
	return exported

# Loads from a JSON (parsed)
func load_json(input):
	for tile in input:
		var entity = ENTITY_CONVERSION_KEY[tile["type"]]
		set_cell(
			entity[0],
			Vector2(tile["position"][0], tile["position"][1]),
			entity[1],
			entity[2],
			ROTATION_KEY[int(tile["rotation"])]
		)

func erase_at(erase_position: Vector2i):
	for layer in range(get_layers_count()):
		set_cell(layer, erase_position, 0)
