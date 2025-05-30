extends Node3D

#class name
class_name CameraObject 

@export_group("camera variables")
@export_range(0.0, 5.0, 0.01) var XAxisSens : float
@export_range(0.0, 5.0, 0.01) var YAxisSens : float
@export var maxUpAngleView : float
@export var maxDownAngleView : float

@export_group("camera fov variables")
var targetFOV : float 
var lastFOV : float 
@export var baseFOV : float
@export var fovChangeSpeed : float 

@export_group("movement changes variables")
@export var baseCamAngle : float
@export var crouchCamAngle : float
@export var baseCameraLerpSpeed : float
@export var crouchCameraLerpSpeed : float
@export var crouchCameraDepth : float 

@export_group("camera bob variables")
var headBobValue : float
@export var bobFrequency : float
@export var bobAmplitude : float

@export_group("camera tilt variables")
@export var camTiltRotationValue : float 
@export var camTiltRotationSpeed : float

@export_group("input variables")
var mouseInput : Vector2 
@export var mouseInputSpeed : float 
var playCharInputDir : Vector2

#references variables
@onready var camera : Camera3D = %Camera
@onready var playerChar : PlayerCharacter = $".."
@onready var weaponManager : Node3D = %WeaponManager

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #set mouse as captured
	
	lastFOV = baseFOV #get the base FOV at start
	
func _unhandled_input(event):
	#this function manage camera rotation (360 on x axis, blocked at <= -60 and >= 60 on y axis, to not having the character do a complete head turn, which will be kinda weird)
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * (XAxisSens / 10))
		camera.rotate_x(-event.relative.y * (YAxisSens / 10))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(maxUpAngleView), deg_to_rad(maxDownAngleView))
		mouseInput = event.relative #get position of the mouse in a 2D sceen, so save it in a Vector2 
		
func _process(delta):
	applies(delta)
	
	cameraBob(delta)
	
	cameraTilt(delta)
	
	FOVChange(delta) 
	
	lastFOV = targetFOV #get the last FOV used
	
func applies(delta : float):
	#this function manage the differents camera modifications relative to a specific state, except for the FOV
	match playerChar.stateMachine.currStateName:
		"Crouch":
			#lern the camera
			position.y = lerp(position.y, 0.715 + crouchCameraDepth, crouchCameraLerpSpeed * delta)
			rotation.z = lerp(rotation.z, deg_to_rad(crouchCamAngle) * playCharInputDir.x if playCharInputDir.x != 0.0 else deg_to_rad(crouchCamAngle), crouchCameraLerpSpeed * delta)
		"Idle":
			position.y = lerp(position.y, 0.715, baseCameraLerpSpeed * delta)
			rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
		"Walk":
			position.y = lerp(position.y, 0.715, baseCameraLerpSpeed * delta)
			rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
		"Run":
			position.y = lerp(position.y, 0.715, baseCameraLerpSpeed * delta)
			rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
			
func cameraBob(delta):
	#this function manage the bobbing of the camera when the character is moving
	headBobValue += delta * playerChar.velocity.length() * float(playerChar.is_on_floor())
	camera.transform.origin = headbob(headBobValue) #apply the bob effect obtained to the camera
		
func headbob(time): 
	#some trigonometry stuff here, basically it uses the cosinus and sinus functions (sinusoidal function) to get a nice and smooth bob effect
	var pos = Vector3.ZERO
	pos.y = sin(time * bobFrequency) * bobAmplitude
	pos.x = cos(time * bobFrequency / 2) * bobAmplitude
	return pos
	
func cameraTilt(delta): 
	#this function manage the camera tilting when the character is moving on the x axis (left and right)
	if playerChar.moveDirection != Vector3.ZERO and playerChar.inputDirection != Vector2.ZERO:
		playCharInputDir = playerChar.inputDirection #get input direction to know where the character is heading to
		#apply smooth tilt movement
		if !playerChar.is_on_floor(): rotation.z = lerp(rotation.z, -playCharInputDir.x * camTiltRotationValue/1.6, camTiltRotationSpeed * delta)
		else: rotation.z = lerp(rotation.z, -playCharInputDir.x * camTiltRotationValue, camTiltRotationSpeed * delta)
		
func FOVChange(delta):
	targetFOV = baseFOV
	camera.fov = lerp(camera.fov, targetFOV, fovChangeSpeed * delta)
	camera.fov = clamp(camera.fov, 1, 179)
		
		
		
		
		
		
		
		
		
