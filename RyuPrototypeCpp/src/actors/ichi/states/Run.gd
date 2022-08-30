extends State


onready var move_state = get_parent()

func unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	return

func physics_process(delta: float) -> void:
	move_state.physics_process(delta)
	#print_camprefs()
	owner.check_viewport()
	
	if owner.is_on_floor():
		# only needabale if we can walk slowly or sprint
		# owner.set_blendspace_in_tree("run", move_state.get_move_direction())  
		Events.emit_signal("set_character_look_direction",move_state.get_move_direction())
		# == the player releases the run button / stops
		if Input.get_action_strength("move_up_jump") != 0:
			_state_machine.transition_to("Move/Jump")
			return
		if move_state.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else :
		if (move_state.velocity.y > move_state.falling_velo_threshold):
			_state_machine.transition_to("Move/Air")
	return
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	move_state.enter(msg)
	Events.emit_signal("set_character_state","RUN")
	Events.emit_signal("activate_spritesheet_animation","run","run_"+owner.get_ani_postfix())
	owner.set_playerstate(PlayerVariables.CharacterState.RUN)
	return
	
# exit the state
func exit() -> void:
	move_state.exit()
	return

