extends State

onready var climb_state = get_parent()
var anim_player : AnimationPlayer = null

func unhandled_input(event: InputEvent) -> void:
	return
	
func physics_process(delta: float) -> void:
	return
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	climb_state.enter(msg)
	Events.emit_signal("set_character_state","HANGING")
	Events.emit_signal("activate_spritesheet_animation","climbledge_"+owner.get_ani_postfix(),"climb_ledge_"+owner.get_ani_postfix())
	Events.emit_signal("set_animation_frame","climb_ledge_"+owner.get_ani_postfix(),0)
	owner.set_playerstate(PlayerVariables.CharacterState.CLIMB)
	owner.set_climbstate(PlayerVariables.ClimbState.CLIMBLEDGE)
	anim_player = owner.get_animation_player()
	anim_player.connect("animation_finished", self, "on_animation_finished")
	return
	
# exit the state
func exit() -> void:
	return
