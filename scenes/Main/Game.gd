extends Node2D

@onready var player_scene = preload("res://scenes/Player/Player.tscn") as PackedScene
@onready var game_over_scene = preload("res://scenes/UI/GameOver.tscn") as PackedScene
@onready var game_win_scene = preload("res://scenes/UI/GameWin.tscn") as PackedScene

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

#Returns true if player won game
func next_level() -> bool:
	if (current_level < maps.size()):
		current_level += 1
		return false
	return true

func get_current_level() -> int:
	return current_level

func increment_level():
	current_level += 1

func on_player_won():
	if next_level():
		var game_win = game_win_scene.instantiate()
		game_win.player_time = player.get_node("Camera2D/Time").text
		add_child(game_win)
		player.queue_free()
		map_node.queue_free()
	else:
		load_current_level()
		player.reset()

func on_player_death():
	var game_over = game_over_scene.instantiate()
	game_over.player_time = player.get_node("Camera2D/Time").text
	add_child(game_over)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_maps_from_dir("res://scenes/Maps")
	load_current_level()
	player = player_scene.instantiate()
	add_child(player)
	player.won.connect(on_player_won)
	player.died.connect(on_player_death)
