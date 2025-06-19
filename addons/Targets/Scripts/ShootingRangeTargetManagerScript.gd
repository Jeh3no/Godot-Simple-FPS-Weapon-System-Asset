extends Node3D

var shootRangeTargets : Array[CharacterBody3D] = []

func _ready():
	for child in get_children():
		if child is CharacterBody3D:
			shootRangeTargets.append(child)
		
func _process(_delta : float):
	inputManagement()
	
func inputManagement():
	if Input.is_action_just_pressed("restartShootingRange"):
		restartShootRange()
		
func restartShootRange():
	#revive all fallen targets
	for target in range(0, shootRangeTargets.size()):
		if shootRangeTargets[target].isDisabled:
			shootRangeTargets[target].animManager.play_backwards("fall")
			shootRangeTargets[target].health = 100
			shootRangeTargets[target].isDisabled = false
		
	
	

		

		
	
