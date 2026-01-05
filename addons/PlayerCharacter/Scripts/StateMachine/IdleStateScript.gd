extends State

class_name IdleState

var state_name : String = "Idle"

var cr : CharacterBody3D

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cr = char_ref
	
	verifications()
	
func verifications():
	#manage the appliements that need to be set at the start of the state
	cr.floor_snap_length = 1.0
	if cr.jump_cooldown > 0.0: cr.jump_cooldown = -1.0
	if cr.nb_jumps_in_air_allowed < cr.nb_jumps_in_air_allowed_ref: cr.nb_jumps_in_air_allowed = cr.nb_jumps_in_air_allowed_ref
	if cr.coyote_jump_cooldown < cr.coyote_jump_cooldown_ref: cr.coyote_jump_cooldown = cr.coyote_jump_cooldown_ref
	
func physics_update(delta : float):
	check_if_floor()
	
	applies(delta)
	
	cr.gravity_apply(delta)
	
	input_management()
	
	move(delta)
	
func check_if_floor():
	#manage the appliements and state transitions that needs to be sets/checked/performed
	#every time the play char pass through one of the following : floor-inair-onwall
	if !cr.is_on_floor() and !cr.is_on_wall():
		transitioned.emit(self, "_inair_state")
	if cr.is_on_floor():
		if cr.jump_buff_on:
			cr.buffered_jump = true
			cr.jump_buff_on = false
			transitioned.emit(self, "_jump_state")
			
func applies(delta : float):
	#manage the appliements of things that needs to be set/checked/performed every frame
	if cr.hit_ground_cooldown > 0.0: cr.hit_ground_cooldown -= delta
	
	cr.hitbox.shape.height = lerp(cr.hitbox.shape.height, cr.base_hitbox_height, cr.height_change_speed * delta)
	cr.model.scale.y = lerp(cr.model.scale.y, cr.base_model_height, cr.height_change_speed * delta)
	
func input_management():
	#manage the state transitions depending on the actions inputs
	if Input.is_action_just_pressed(cr.jumpAction):
		transitioned.emit(self, "_jump_state")
		
	if Input.is_action_just_pressed(cr.crouchAction):
		transitioned.emit(self, "_crouch_state")
		
	if Input.is_action_just_pressed(cr.runAction):
		if cr.walk_or_run == "_walk_state": cr.walk_or_run = "_run_state"
		elif cr.walk_or_run == "_run_state": cr.walk_or_run = "_walk_state"
		
func move(delta : float):
	#manage the character movement
	
	#direction input
	cr.input_direction = Input.get_vector(cr.moveLeftAction, cr.move_right_action, cr.move_forward_action, cr.move_backward_action)
	#get the move direction depending on the input
	cr.move_direction = (cr.camHolder.global_basis * Vector3(cr.input_direction.x, 0.0, cr.input_direction.y)).normalized()
	
	if cr.move_direction and cr.is_on_floor():
		#transition to corresponding state
		transitioned.emit(self, cr.walk_or_run)
	else:
		#apply smooth stop 
		cr.velocity.x = lerp(cr.velocity.x, 0.0, cr.move_deccel * delta)
		cr.velocity.z = lerp(cr.velocity.z, 0.0, cr.move_deccel * delta)
		
		#cancel desired move speed accumulation if the timer has elapsed (is up)
		if cr.hit_ground_cooldown <= 0: cr.desired_move_speed = cr.velocity.length()
		
	#set to ensure the character don't exceed the max speed authorized
	if cr.desired_move_speed >= cr.max_speed: cr.desired_move_speed = cr.max_speed
