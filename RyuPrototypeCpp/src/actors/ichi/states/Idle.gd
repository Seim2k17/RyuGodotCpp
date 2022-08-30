extends State

onready var move_state = get_parent()
var from_state_msg = {}

func unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	return
	
func set_combat_mode(weapon) -> void:
	#beautiful content here, move this function somewhere else
	#switch weapon
		#case KATANA
	_state_machine.transition_to("Combat/Katana")
	pass
	
func set_climbing_mode() -> void:
	var collide_high = owner.is_ledge_colliding(PlayerVariables.LedgePosition.HIGH)
	var collide_up = owner.is_ledge_colliding(PlayerVariables.LedgePosition.UP)
	var collide_mid = owner.is_ledge_colliding(PlayerVariables.LedgePosition.MID)
	var collide_down = owner.is_ledge_colliding(PlayerVariables.LedgePosition.DOWN)
		
	if collide_high == false and collide_up == false and collide_mid == false and collide_down == true:
		print("Climb_low")
	if collide_high == false and collide_up == false and collide_mid == true and collide_down == true:
		#print("Climb_mid")
		_state_machine.transition_to("Climb/Ledge")
	if collide_high == false and collide_up == true and collide_mid == true and collide_down == true:
		print("Climb high")
	if collide_high == true and collide_up == true and collide_mid == true and collide_down == true:
		print("Too high")
		
	if collide_high == false and collide_up == false and collide_mid == false and collide_down == false:
		print("JUMP_UP")
		_state_machine.transition_to("Move/JumpUp")
		#for climbing -> e.g. https://www.youtube.com/watch?v=atuucRulQ4I (Raycast)
	
func physics_process(delta: float) -> void:
	if owner.get_climbstate() == PlayerVariables.ClimbState.ENTERLADDER:
		var overlaps : Dictionary = owner.get_overlap_state()
		if (Input.is_action_pressed("move_up_jump") and overlaps["up"] == true) or (Input.is_action_pressed("move_down") and overlaps["down"] == true):
			Events.emit_signal("set_interaction_ui",false,"") 
			_state_machine.transition_to("Climb/Ladder")
			return
		
	if owner.is_on_floor():
		if Input.is_action_pressed("move_up_jump"):
			set_climbing_mode()
			return
		if Input.is_action_pressed("weapon_low"):
			set_combat_mode(owner.ACTIVE_WEAPON)
			return

		if move_state.get_move_direction().x != 0.0:
			#set_process(false)
			_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air",from_state_msg)
	return

func enter(msg: Dictionary = {}) -> void:
	Events.emit_signal("set_character_state","IDLE")
	Events.emit_signal("activate_spritesheet_animation","run","idle_"+owner.get_ani_postfix())
	from_state_msg = msg
	var direction: Vector2 = Vector2.ZERO
	if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
		direction.x = 1
	if owner.look_direction == PlayerVariables.LookDirection.LEFT:
		direction.x = -1
	owner.set_playerstate(PlayerVariables.CharacterState.IDLE)
	
	#move_state.enter(msg)
	move_state.max_speed = move_state.max_speed_default
	move_state.velocity = Vector2.ZERO
	return
	
# exit the state
func exit() -> void:
	move_state.exit()
	return
