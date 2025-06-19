extends Node3D

var cW
var cWM : Node3D

@onready var cameraHolder : Node3D = %CameraHolder
@onready var playChar : CharacterBody3D = $"../../../../.."
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var weapM : Node3D = %WeaponManager

func getCurrentWeapon(currWeap, currWeapModel):
	#get current weapon model and resources
	cW = currWeap
	cWM = currWeapModel
	
func _process(delta: float):
	if cW != null and cWM != null:
		weaponTilt(playChar.inputDirection, delta)
		weaponSway(cameraHolder.mouseInput, delta)
		weaponBob(playChar.velocity.length(),delta)
		
func weaponTilt(playCharInput, delta):
	#rotate weapon model on the z axis depending on the player character direction orientation (left or right)
	cWM.rotation.z = lerp(cWM.rotation.z, playCharInput.x * cW.tiltRotAmount, cW.tiltRotSpeed * delta)
	
func weaponSway(mouseInput, delta):
	#clamp mouse movement
	mouseInput.x = clamp(mouseInput.x, cW.minSwayVal.x, cW.maxSwayVal.x)
	mouseInput.y = clamp(mouseInput.y, cW.minSwayVal.y, cW.maxSwayVal.y)
	
	#lerp weapon position based on mouse movement, relative to the initial position
	cWM.position.x = lerp(cWM.position.x, cW.position[0].x + (mouseInput.x * cW.swayAmountPos) * delta, cW.swaySpeedPos)
	cWM.position.y = lerp(cWM.position.y, cW.position[0].y - (mouseInput.y * cW.swayAmountPos) * delta, cW.swaySpeedPos)
	
	#lerp weapon rotation based on mouse movement, relative to the initial rotation
	#use of rad_to_deg here, because we rotate the model based on degrees, but the saved weapon rotation is in radians
	cWM.rotation_degrees.y = lerp(cWM.rotation_degrees.y, rad_to_deg(cW.position[1].y) -  (mouseInput.x * cW.swayAmountRot) * delta, cW.swaySpeedRot)
	cWM.rotation_degrees.x = lerp(cWM.rotation_degrees.x, rad_to_deg(cW.position[1].x) + (mouseInput.y * cW.swayAmountRot) * delta, cW.swaySpeedRot)
	
func weaponBob(vel : float, delta):
	var bobFreq : float = cW.bobFreq
	
	#change bob frequency for weapon idle
	if vel < 4.0:
		bobFreq /= cW.onIdleBobFreqDivider
		
	#smoothly move the weapon model in the form of a curve (hence the use of sin)
	cWM.position.y = lerp(cWM.position.y, cW.bobPos[0].y + sin(Time.get_ticks_msec() * bobFreq) * cW.bobAmount * vel / 10, cW.bobSpeed * delta)
	cWM.position.x = lerp(cWM.position.x, cW.bobPos[0].x + sin(Time.get_ticks_msec() * bobFreq * 0.5) * cW.bobAmount * vel / 10, cW.bobSpeed * delta)

func playModelAnimation(animName : String, animSpeed : float, hasToRestartAnim : bool):
	if cW != null and animPlayer != null:
		#restart current anim if needed (for example restart shoot animation while still playing)
		if hasToRestartAnim and animPlayer.current_animation == animName:
			animPlayer.seek(0, true)
		#play animation
		animPlayer.play("%s" % animName, -1, animSpeed)
		
