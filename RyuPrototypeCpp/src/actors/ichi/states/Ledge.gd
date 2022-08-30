extends State

onready var climb_state = get_parent()
var anim_player : AnimationPlayer = null

func _ready() -> void:
	#player.connect("finished", self, "playNextAnim")
	pass
	
func unhandled_input(event: InputEvent) -> void:
	climb_state.unhandled_input(event)
	pass
	
func physics_process(delta: float) -> void:
	pass	

func enter(msg: Dictionary = {}) -> void:
	climb_state.enter(msg)
	Events.emit_signal("set_character_state","LEDGE")
	Events.emit_signal("activate_spritesheet_animation","climbledge_"+owner.get_ani_postfix(),"climb_ledge_"+owner.get_ani_postfix())
	Events.emit_signal("set_animation_frame","climb_ledge_"+owner.get_ani_postfix(),0)
	owner.set_playerstate(PlayerVariables.CharacterState.CLIMB)
	owner.set_climbstate(PlayerVariables.ClimbState.CLIMBLEDGE)
	anim_player = owner.get_animation_player()
	anim_player.connect("animation_finished", self, "on_animation_finished")

func on_animation_finished(name: String) -> void:
	_state_machine.transition_to("Move/Idle")

func exit() -> void:
	climb_state.exit()

	owner.set_climbstate(PlayerVariables.ClimbState.NONE)	
	if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
		owner.position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["Mid"].x + Vector2.UP * PlayerVariables.ClimbPosition["Mid"].y) 
	if owner.look_direction == PlayerVariables.LookDirection.LEFT:
		owner.position -= (Vector2.RIGHT * PlayerVariables.ClimbPosition["Mid"].x - Vector2.UP * PlayerVariables.ClimbPosition["Mid"].y)	
	anim_player.disconnect("animation_finished",self,"on_animation_finished")
	pass
