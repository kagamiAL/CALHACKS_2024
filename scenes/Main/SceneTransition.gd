extends ColorRect

@onready var _anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_transition():
	_anim_player.play("Fade")
	await _anim_player.animation_finished
