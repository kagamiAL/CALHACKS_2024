extends StaticBody2D

# not to be confused with the static, tile spike
# or the person who wrote this code
@export var spike_scene : PackedScene

@export var speed : float

func _on_timer_timeout():
	var spike = spike_scene.instantiate()
	spike.set_global_transform($SpawnPoint.global_transform)
	spike.linear_velocity = Vector2(0, -speed).rotated($SpawnPoint.global_rotation)
	add_child(spike)
