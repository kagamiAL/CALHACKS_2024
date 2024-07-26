extends Button

@export var circuit : Dictionary

@onready var scene_transition = load("res://scenes/Main/SceneTransition.tscn")

func _ready():
	icon = $SubViewport.get_texture()

func set_thumbnail():
	$SubViewport/SavedTileMap.load_json(circuit["maps"][0]["data"])
	icon = $SubViewport.get_texture()


func _on_pressed():
	# TODO: scene transition
	var transition = scene_transition.instantiate()
	get_tree().get_root().add_child(transition)
	await transition.play_transition()
	transition.queue_free()
	if circuit:
		get_node("/root/SceneSwitch").play_circuit(circuit)
	else:
		get_node("/root/SceneSwitch").goto_scene("res://scenes/Main/Game.tscn")

func _on_tree_entered():
	if circuit:
		set_thumbnail()
