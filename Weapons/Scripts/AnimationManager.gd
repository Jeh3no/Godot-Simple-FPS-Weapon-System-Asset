extends Node3D

var cW
var cWM : Node3D

@onready var cameraHolder : Node3D = %CameraHolder
@onready var playChar : CharacterBody3D = $"../../../../.."
@onready var animPlayer : AnimationPlayer = %AnimationPlayer
@onready var weapM : Node3D = %WeaponManager

func getCurrentWeapon(currWeap, currWeapModel):
	cW = currWeap
	cWM = currWeapModel
	
func _process(delta: float):
	if cW != null and cWM != null:
		weaponTilt(playChar.inputDirection, delta)
		weaponSway(cameraHolder.mouseInput, delta)
		weaponBob(playChar.velocity.length(),delta)
		
func weaponTilt(playCharInput, delta):
	cWM.rotation.z = lerp(cWM.rotation.z, playCharInput.x * cW.tiltRotAmount, cW.tiltRotSpeed * delta)
	
func weaponSway(mouseInput, delta):
	mouseInput = lerp(mouseInput, Vector2.ZERO, 10 * delta)
	cWM.rotation.x = lerp(cWM.rotation.x, mouseInput.y * cW.swayRotAmount * (-1 if cW.invertWeaponSway else 1), cW.swayRotSpeed * delta)
	cWM.rotation.y = lerp(cWM.rotation.y, mouseInput.x * cW.swayRotAmount * (-1 if cW.invertWeaponSway else 1), cW.swayRotSpeed * delta)
	
func weaponBob(vel : float, delta):
	var bobFreq : float = cW.bobFreq
	
	#change bob frequency for weapon idle
	if vel < 4.0:
		bobFreq /= 1.4
		
	cWM.position.y = lerp(cWM.position.y, cW.bobPos[0].y + sin(Time.get_ticks_msec() * bobFreq) * cW.bobAmount * vel / 10, cW.bobSpeed * delta)
	cWM.position.x = lerp(cWM.position.x, cW.bobPos[0].x + sin(Time.get_ticks_msec() * bobFreq * 0.5) * cW.bobAmount * vel / 10, cW.bobSpeed * delta)
	
func playModelAnimation(animName : String, animSpeed : float, hasToRestartAnim : bool):
	if cW != null and animPlayer != null:
		if hasToRestartAnim: 
			animPlayer.seek(0, true)
		animPlayer.play("%s" % animName, -1, animSpeed)
		
func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "shootAnim%s" % cW.weaponName and cW.forceShootEndAnim:
		weapM.weaponSoundManagement(cW.shootEndSound, cW.shootEndSoundSpeed)
		playModelAnimation("shootEndAnim", cW.shootEndAnimSpeed, false)
		
