extends Node2D

@onready var scene_switch = get_node("/root/SceneSwitch")
@onready var scene_transition = preload("res://scenes/Main/SceneTransition.tscn")

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
	var transition_scene = scene_transition.instantiate()
	get_tree().root.add_child(transition_scene)
	await transition_scene.play_transition()
	scene_switch.goto_scene(maps[current_level])
	transition_scene.queue_free()

func next_level():
	if (current_level < maps.size()):
		current_level += 1
	else:
		current_level = 1

func get_current_level() -> int:
	return current_level

func increment_level():
	current_level += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_up_maps_from_dir("res://scenes/Maps")
