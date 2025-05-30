extends Camera3D

@onready var cam : Camera3D = %Camera

func _process(_delta : float):
	global_transform = cam.global_transform
