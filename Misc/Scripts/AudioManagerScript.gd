extends AudioStreamPlayer3D

func _on_finished():
	queue_free()
