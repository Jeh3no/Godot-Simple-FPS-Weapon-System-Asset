extends State

class_name SlideState

var stateName : String = "Slide"

var cR : CharacterBody3D

func enter(charRef : CharacterBody3D):
	cR = charRef
	
	verifications()
	
func verifications():
	if cR.inputDirection != Vector2.ZERO: cR.slideVector = cR.inputDirection 
	else: cR.slideVector = Vector2(0, -1)
	cR.slideTime = cR.slideTimeRef
	
	if cR.jumpCooldown > 0.0: cR.jumpCooldown = -1.0
	if cR.nbJumpsInAirAllowed < cR.nbJumpsInAirAllowedRef: cR.nbJumpsInAirAllowed = cR.nbJumpsInAirAllowedRef
	if cR.coyoteJumpCooldown < cR.coyoteJumpCooldownRef: cR.coyoteJumpCooldown = cR.coyoteJumpCooldownRef
	
func physics_update(delta : float):
	checkIfFloor()
	
	applies(delta)
	
	cR.gravityApply(delta)
	
	inputManagement()
	
	move(delta)
	
func checkIfFloor():
	if !cR.is_on_floor() and !cR.is_on_wall():
		if cR.velocity.y < 0.0:
			transitioned.emit(self, "InairState")
			
func applies(delta : float):
	cR.floorAngle = cR.get_floor_normal() #get the angle of the floor
	cR.slopeAngle = rad_to_deg(acos(cR.floorAngle.dot(Vector3.UP))) #get the angle of the slope 
	
	if cR.slideTime <= 0.0:
		if cR.timeBefCanSlideAgain != cR.timeBefCanSlideAgainRef: cR.timeBefCanSlideAgain = cR.timeBefCanSlideAgainRef
		transitioned.emit(self, "RunState")
		
	if (cR.position.y - cR.lastFramePosition.y) > 0.1: #go upstairs
		if cR.timeBefCanSlideAgain != cR.timeBefCanSlideAgainRef: cR.timeBefCanSlideAgain = cR.timeBefCanSlideAgainRef
		transitioned.emit(self, "RunState")
	
	elif cR.lastFramePosition.y >= cR.position.y:
		if cR.slideTime > 0.0: cR.slideTime -= delta
		
func inputManagement():
	if Input.is_action_just_pressed("run"):
		transitioned.emit(self, "RunState")
		
	if Input.is_action_just_pressed("crouch | slide"):
		transitioned.emit(self, "RunState")
	
	if Input.is_action_just_pressed("jump"):
		if cR.timeBefCanSlideAgain != cR.timeBefCanSlideAgainRef: cR.timeBefCanSlideAgain = cR.timeBefCanSlideAgainRef
		transitioned.emit(self, "JumpState")
		
func move(delta : float):
	if cR.moveDirection == Vector3.ZERO: 
		#get move direction at the startzzz of the slide, and stick to it
		cR.moveDirection = (cR.camHolder.basis * Vector3(cR.slideVector.x, 0.0, cR.slideVector.y)).normalized()
			
	cR.desiredMoveSpeed += 5.0 * delta
	
	if cR.moveDirection and cR.is_on_floor():
		cR.velocity.x = cR.moveDirection.x * cR.desiredMoveSpeed
		cR.velocity.z = cR.moveDirection.z * cR.desiredMoveSpeed
	else:
		transitioned.emit(self, "IdleState")
		
	#set to ensure the character don't exceed the max speed authorized
	if cR.desiredMoveSpeed >= cR.maxSpeed: cR.desiredMoveSpeed = cR.maxSpeed 
