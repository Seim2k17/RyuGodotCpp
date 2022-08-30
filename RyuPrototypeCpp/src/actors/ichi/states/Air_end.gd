extends State

onready var move_state = get_parent()
var anim_player : AnimationPlayer = null
# to make sure we call our own undhandled_input() 
# & physics_process() from the statemachine and not the engine-automatic-calls
func unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	return
	
func physics_process(delta: float) -> void:
	pass
	
func on_animation_finished(name: String) -> void:
	if name == "fall_end_low":
		_state_machine.transition_to("Move/Idle")

	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	print("AirEnd:msg: ",msg)

	if not "ladder" in msg:
		anim_player = move_state.get_animation_player()
		anim_player.connect("animation_finished",self,"on_animation_finished")
		Events.emit_signal("activate_spritesheet_animation","fall_low","fall_end_low")
	owner.set_playerstate(PlayerVariables.CharacterState.FALLING_END)	
	return
	
# exit the state
func exit() -> void:
	anim_player.disconnect("animation_finished",self,"on_animation_finished")
	return
