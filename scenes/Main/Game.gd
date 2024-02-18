extends Node2D

@onready var player_scene = preload("res://scenes/Player/Player.tscn") as PackedScene

var maps: Dictionary = {};
var map_node: Node2D;
var player;

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
					maps[int(result.get_string())] = load(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func load_current_level():
	if map_node:
		map_node.queue_free()
	map_node = maps[current_level].instantiate()
	map_node.z_index = -1
	add_child(map_node)

func next_level():
	if (current_level < maps.size()):
		current_level += 1
	else:
		current_level = 1

func get_current_level() -> int:
	return current_level

func increment_level():
	current_level += 1

func on_player_won():
	next_level()
	load_current_level()
	player.reset()
	player.set_position(Vector2(0, 0))

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_maps_from_dir("res://scenes/Maps")
	load_current_level()
	player = player_scene.instantiate()
	add_child(player)
	player.won.connect(on_player_won)
