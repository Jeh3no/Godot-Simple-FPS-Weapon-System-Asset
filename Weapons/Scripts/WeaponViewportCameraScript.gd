extends Camera3D

@onready var mainCam : Camera3D = %Camera

func _process(_delta: float):
	if mainCam != null: global_transform = mainCam.global_transform
