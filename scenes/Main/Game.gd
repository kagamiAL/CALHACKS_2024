extends Node2D

class Game:

	var maps: Dictionary = {};

	var current_level: int = 1;

	func set_up_maps_from_dir(path: String):
		var regex = RegEx.new()
		regex.compile("\\d+")
		var dir = DirAccess.open(path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if !dir.current_is_dir():
					var result = regex.search(file_name)
					if result:
						maps[int(result.get_string())] = path + "/" + file_name
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")

	func load_current_level():
		return load(maps[current_level])

	func next_level():
		if (current_level < maps.size()):
			current_level += 1
		else:
			current_level = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	var game_manager: Game = Game.new();
	game_manager.set_up_maps_from_dir("res://scenes/Maps")
	get_tree().change_scene_to_packed(game_manager.load_current_level())
