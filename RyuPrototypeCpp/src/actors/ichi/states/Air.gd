extends State

onready var move_state = get_parent()
export var acceleration_x: =5000.0
var air_msg = {}


func unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	return
	
func physics_process(delta: float) -> void:
	move_state.physics_process(delta)
	#print(move_state.velocity.y)
	if (owner) : owner.check_viewport()
	if owner.is_on_floor():
		if move_state.get_move_direction().x == 0.0:
			if not "ladder" in air_msg:
				_state_machine.transition_to("Move/Air_end", air_msg)
			else:
				_state_machine.transition_to("Move/Idle", air_msg)
		else:
			_state_machine.transition_to("Move/Run", air_msg)	
		
		#print("move/air: on floor: ",target_state)
		
	return
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	"""
	var dest_down : RayCast2D = owner.get_ladder_detector()
	var down_arrow_original : Vector2 = dest_down.get_cast_to()
	var down_arrow_new : Vector2 = Vector2(down_arrow_original.x,down_arrow_original.y * 10)
	dest_down.set_cast_to(down_arrow_new)
	if(dest_down.is_colliding()):
	"""
	Events.emit_signal("set_character_state","AIR")
	air_msg = msg
	
	if not "ladder" in msg :
		Events.emit_signal("activate_spritesheet_animation","fall_low","fall_loop")
	owner.set_playerstate(PlayerVariables.CharacterState.FALLING)
	#owner.travel_to_state("falling")
	#owner.set_blendspace_in_tree("run", move_state.get_move_direction())
	move_state.enter(msg)
	move_state.acceleration.x = acceleration_x
	
	#future stuff
	if "velocity" in msg:
		move_state.velocity = msg.velocity
		move_state.max_speed.x = max(abs(msg.velocity.x),move_state.max_speed_default.x)
	# ability to jump...
	if "impulse" in msg:
		move_state.velocity += calculate_jump_velocity(msg.impulse)
	return
	
# exit the state
func exit() -> void:
	move_state.exit()
	#print("exit air state")
	move_state.acceleration = move_state.acceleration_default
	return

func calculate_jump_velocity(impulse : float = 0.0) ->  Vector2:
		return move_state.calculate_velocity(
			move_state.velocity,
			move_state.max_speed,
			Vector2(0.0,impulse),
			1.0,
			Vector2.UP
		)
