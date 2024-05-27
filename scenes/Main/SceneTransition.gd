extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func play_transition():
	$%AnimationPlayer.play("Fade")
	await $%AnimationPlayer.animation_finished
