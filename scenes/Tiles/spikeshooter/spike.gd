extends RigidBody2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.kill()
	queue_free()


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	queue_free()
