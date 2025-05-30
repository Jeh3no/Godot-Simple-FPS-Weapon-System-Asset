extends Node3D

var shoRanTargets : Array[CharacterBody3D] = []

func _ready():
	for child in get_children():
		shoRanTargets.append(child)
		
func _process(_delta : float):
	inputManagement()
	
func inputManagement():
	if Input.is_action_just_pressed("restartShootingRange"):
		restartShootRange()
		
func restartShootRange():
	for target in range(0, shoRanTargets.size()):
		if shoRanTargets[target].isDisabled:
			shoRanTargets[target].animManager.play_backwards("fall")
			#await shoRanTargets[target].animManager.animation_finished()
			shoRanTargets[target].health = 100
			shoRanTargets[target].isDisabled = false
		
	
	

		

		
	
