extends Node3D

#class name
class_name CameraObject 

@export_group("Camera variables")
@export_range(0.0, 5.0, 0.01) var XAxisSens : float
@export_range(0.0, 5.0, 0.01) var YAxisSens : float
@export var maxUpAngleView : float
@export var maxDownAngleView : float

@export_group("FOV variables")
@export var startFOV : float
@export var runFOV : float
@export var fovTransitionSpeed : float

@export_group("Movement changes variables")
@export var baseCamAngle : float
@export var crouchCamAngle : float
@export var baseCameraLerpSpeed : float
@export var crouchCameraLerpSpeed : float
@export var crouchCameraDepth : float 

@export_group("Camera bob variables")
@export var enableBob : bool = true
var headBobValue : float
@export var bobFrequency : float
@export var bobAmplitude : float

@export_group("Camera tilt variables")
@export var enableTilt : bool = true
@export var tiltRotationValue : float 
@export var tiltRotationSpeed : float
@export var inAirTiltValDivider : float

@export_group("Input variables")
var mouseInput : Vector2 
@export var mouseInputSpeed : float 
var playCharInputDir : Vector2

#Mouse variables
var mouseFree : bool = false

@export_group("Keybind variables")
@export var mouseModeAction : String = ""

#References variables
@onready var camera : Camera3D = %Camera
@onready var playChar : PlayerCharacter = $".."
@onready var weaponManager : Node3D = %WeaponManager

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #set mouse as captured

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
	
func applies(delta : float):
	#manage the differents camera modifications relative to a specific state, except for the FOV
	if playChar.stateMachine.currStateName == "Crouch":
		position.y = lerp(position.y, 0.715 + crouchCameraDepth, crouchCameraLerpSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(crouchCamAngle) * playChar.inputDirection.x if playChar.inputDirection.x != 0.0 else deg_to_rad(crouchCamAngle), crouchCameraLerpSpeed * delta)
	elif playChar.stateMachine.currStateName == "Run": 
		camera.fov = lerp(camera.fov, runFOV, fovTransitionSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
	elif playChar.stateMachine.currStateName == "Jump": 
		# Maintain the current FOV when jumping
		camera.fov = lerp(camera.fov, camera.fov, fovTransitionSpeed * delta)
	elif playChar.stateMachine.currStateName == "Inair":
		# Maintain the current FOV when in air
		camera.fov = lerp(camera.fov, camera.fov, fovTransitionSpeed * delta)
	else:
		position.y = lerp(position.y, 0.715, baseCameraLerpSpeed * delta)
		rotation.z = lerp(rotation.z, deg_to_rad(baseCamAngle), baseCameraLerpSpeed * delta)
		camera.fov = lerp(camera.fov, startFOV, fovTransitionSpeed * delta)
			
func cameraBob(delta):
	if enableBob:
		headBobValue += delta * playChar.velocity.length() * float(playChar.is_on_floor())
		camera.transform.origin = headbob(headBobValue, bobFrequency, bobAmplitude)
		
func headbob(time, bobFreq, bobAmpli): 
	#some trigonometry stuff here, basically it uses the cosinus and sinus functions (sinusoidal function) to get a nice and smooth bob effect
	var pos = Vector3.ZERO
	pos.y = sin(time * bobFreq) * bobAmpli
	pos.x = cos(time * bobFreq / 2) * bobAmpli
	return pos
	
func cameraTilt(delta): 
	if enableTilt:
		#this function manage the camera tilting when the character is moving on the x axis (left and right)
		if playChar.moveDirection != Vector3.ZERO and playChar.inputDirection != Vector2.ZERO:
			playCharInputDir = playChar.inputDirection #get input direction to know where the character is heading to
			#apply smooth tilt movement
			if !playChar.is_on_floor(): rotation.z = lerp(rotation.z, -playCharInputDir.x * tiltRotationValue/inAirTiltValDivider, tiltRotationSpeed * delta)
			else: rotation.z = lerp(rotation.z, -playCharInputDir.x * tiltRotationValue, tiltRotationSpeed * delta)

func mouseMode():
	#manage the mouse mode (visible = can use mouse on the screen, captured = mouse not visible and locked in at the center of the screen)
	if Input.is_action_just_pressed(mouseModeAction): mouseFree = !mouseFree
	if !mouseFree: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
