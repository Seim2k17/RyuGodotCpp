extends State

onready var move_state = get_parent()
var anim_player : AnimationPlayer = null

func _ready():
	pass # Replace with function body.

func unhandled_input(event: InputEvent) -> void:
	return
	
func physics_process(delta: float) -> void:
	return
	
func on_animation_finished(name: String)->void:
	# later check if character is in air at the last part of animation then falling state, otherwise idle
	_state_machine.transition_to("Move/Idle")
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	anim_player = move_state.get_animation_player()
	anim_player.connect("animation_finished",self,"on_animation_finished")
	Events.emit_signal("activate_spritesheet_animation","jump_up","jump_up_"+owner.get_ani_postfix())
	
# exit the state
func exit() -> void:
	anim_player.disconnect("animation_finished",self,"on_animation_finished")
	return
