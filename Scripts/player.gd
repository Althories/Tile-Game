extends CharacterBody2D

const GROUND_ACCEL = 50
const AIR_ACCEL = 15
const SPEED_CAP = 350			#maximum attainable movement speed outside of dive
const DIVE_SPEED_X = 800
const DIVE_SPEED_Y = 400
const JUMP_SPEED = -500			#jump speed impulse

var diving = false
var interacting = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogue/main.dialogue"), "start")
		interacting = true
		
func _physics_process(delta: float) -> void:
	if not is_on_floor():	# Add the gravity.
		velocity += get_gravity() * delta
		
	if is_on_floor():
		diving = false		#resets dive when touching the floor

	#Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor() and not interacting:
		velocity.y = JUMP_SPEED
	
	#Handle dive.
	if Input.is_action_just_pressed("move_dive") and not is_on_floor() and not interacting:
		diving = true				#sets state to diving. this bypasses velocity cap
		velocity.y = DIVE_SPEED_Y	#Apply downwards impulse
		if velocity.x > 0:		#if x velocity is positive, make x velocity SPEED CAP
			velocity.x = DIVE_SPEED_X
		elif velocity.x < 0:	#if x velocity is negative, make x velocity -SPEED CAP
			velocity.x = -DIVE_SPEED_X
		
	#Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction and not diving and not interacting:	#IF DIRECTION PRESSED and not currently in dive. Doing this means dive speed will not be capped by this code
		if Input.is_action_pressed("move_left"):
			if velocity.x - 50 < -SPEED_CAP:	#If projected velocity is greater than the cap, change to cap
				velocity.x = -SPEED_CAP
			if velocity.x != -SPEED_CAP:	#If velocity is not at max negative velocity
				if is_on_floor():
					velocity.x -= GROUND_ACCEL			#subtract 50 velocity when on floor
				else:
					velocity.x -= AIR_ACCEL			#subtract velocity when in air
					
		if Input.is_action_pressed("move_right"):
			if velocity.x + 50 > SPEED_CAP:		 #If projected velocity is greater than the cap, change to cap
				velocity.x = SPEED_CAP
			if velocity.x != SPEED_CAP:		#If velocity is not at max positive velocity
				if is_on_floor():
					velocity.x += GROUND_ACCEL			#add 50 velocity when on floor
				else:
					velocity.x += AIR_ACCEL			#add velocity when in air
	else:	#IF NO DIRECTION PRESSED
		if is_on_floor():		#rate while on floor
			velocity.x = move_toward(velocity.x, 0, 30)		#move velocity to 0 by deceleration rate
		else:					#rate in the air
			velocity.x = move_toward(velocity.x, 0, 5)		

	move_and_slide()
