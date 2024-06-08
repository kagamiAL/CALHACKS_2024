extends Node2D

@onready var game_over_scene = load("res://scenes/UI/GameOver.tscn") as PackedScene
@onready var game_win_scene = load("res://scenes/UI/GameWin.tscn") as PackedScene
@onready var level_indicator_scene = load("res://scenes/UI/LevelIndicator.tscn") as PackedScene

var maps: Dictionary = {};
var map_node: Node2D;
var player;
var level_indicator;

var current_level: int = 0;

func set_up_maps_from_dir(path: String):
	var regex = RegEx.new()
	regex.compile("\\d+")
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			print_debug(file_name) # human visual on file name found, remove for production
			if file_name.ends_with(".remap"):
				file_name = file_name.replace(".remap", "")
			if not dir.current_is_dir():
				var result = regex.search(file_name)
				if result:
					maps[int(result.get_string())] = load(path + "/" + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func load_current_level():
	if map_node:
		map_node.queue_free()
		await map_node.tree_exited
	$Player.reset()
	await get_tree().physics_frame
	map_node = maps[current_level].instantiate()
	map_node.z_index = -1
	add_child(map_node)

#Returns true if player won game
func next_level() -> bool:
	if (current_level < maps.size() - 1):
		current_level += 1
		return false
	return true

func get_current_level() -> int:
	return current_level

func increment_level():
	current_level += 1

func _on_player_won():
	$AnimationPlayer.play("goal_reached")
	$WinSound.play()
	if next_level():
		var game_win = game_win_scene.instantiate()
		game_win.player_time = $Player.get_node("Camera2D/Time").text
		add_child(game_win)
		$Player.queue_free()
		map_node.queue_free()
	else:
		level_indicator.change_indicated_level(current_level)
		load_current_level()

func _on_player_died():
	load_current_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	Engine.physics_ticks_per_second = DisplayServer.screen_get_refresh_rate() # Hack to make physics smooth
	print("Physics engine set to %d FPS" % Engine.physics_ticks_per_second)
	set_up_maps_from_dir("res://scenes/Maps")
	load_current_level()
	level_indicator = level_indicator_scene.instantiate()
	add_child(level_indicator)
	$SoundTrack.play()
