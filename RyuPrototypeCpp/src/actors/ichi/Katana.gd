extends State

onready var combat_state = get_parent()
onready var move_state = get_node("../../Move")

export var max_speed_default: =Vector2(500.0,1500.0)
# very high acc_x value will result that the char will instant go up to 500px/sec, acc_y = gravity
export var acceleration_default: =Vector2(100000.0,3000.0)

var anim_player : AnimationPlayer = null
var velocity: = Vector2.ZERO
var acceleration: = acceleration_default
var max_speed: = max_speed_default
var combat_move = PlayerVariables.CombatMove.STAND

func unhandled_input(event: InputEvent) -> void:
	return
	
func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if Input.get_action_strength("move_down"):
			_state_machine.transition_to("Move/Idle")
			return
			
		velocity = move_state.calculate_velocity(
		velocity,
		max_speed,
		acceleration,
		delta,
		move_state.get_move_direction()
		)
		print("velo ", velocity)
		#this is responsible for moving the character
		velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
		
		Events.emit_signal("set_character_look_direction",move_state.get_move_direction())
		# == the player releases the run button / sto
		if move_state.get_move_direction().x == 0.0:
			combat_move = PlayerVariables.CombatMove.STAND
			Events.emit_signal("activate_spritesheet_animation","combat_katana_"+owner.get_ani_postfix(),"climb_katana_low_idle_"+owner.get_ani_postfix())

		if move_state.get_move_direction().x < 0.0:
			#Events.emit_signal("set_character_state","RUN")
			if combat_move == PlayerVariables.CombatMove.STAND:
				combat_move = PlayerVariables.CombatMove.WALK
				Events.emit_signal("activate_spritesheet_animation","combat_katana_l","combat_katana_low_walk_l")#+owner.get_ani_postfix())
			#owner.set_playerstate(PlayerVariables.CharacterState.RUN)
			#move forward / backward acc. to position of enemy
			pass

		if move_state.get_move_direction().x > 0.0:
			if combat_move == PlayerVariables.CombatMove.STAND:
				combat_move = PlayerVariables.CombatMove.WALK
				Events.emit_signal("activate_spritesheet_animation","combat_katana_r","combat_katana_low_walk_r")
			#move forward / backward acc. to position of enemy		
		return
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	combat_state.enter(msg)
	Events.emit_signal("set_character_state","COMBAT")
	Events.emit_signal("activate_spritesheet_animation","combat_katana_"+owner.get_ani_postfix(),"climb_katana_low_idle_"+owner.get_ani_postfix())
	Events.emit_signal("set_animation_frame","climb_katana_low_idle_"+owner.get_ani_postfix(),0)
	owner.set_playerstate(PlayerVariables.CharacterState.COMBAT)
	owner.set_combatstate(PlayerVariables.CombatState.SWORD)
	owner.set_activeweapon(PlayerVariables.Weapons.KATANA)
	anim_player = owner.get_animation_player()
	anim_player.connect("animation_finished", self, "on_animation_finished")
	return
	
# exit the state
func exit() -> void:
	owner.set_combatstate(PlayerVariables.CombatState.FIST)
	owner.set_activeweapon(PlayerVariables.Weapons.NONE)
	return
