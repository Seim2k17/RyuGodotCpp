extends Node

class_name StateMachine,"res://assets/icons/state_machine.svg"

"""
Generic State machine, initializes states and delegate engine callbacks
(_physics_process, _unhandled_input) to the active state
"""

export var initial_state: = NodePath()

onready var state: = get_node(initial_state) as State setget set_state
onready var _state_name: = state.name

func _ready() -> void:
	# wait until owner/the player is ready, the continue script
	# wait until the owner emits the ready signal (its ready function is exected)
	yield(owner,"ready")
	state.enter()

func _init() -> void:
	add_to_group("state_machine")
	
func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)
	
func _physics_process(delta: float) -> void:
	state.physics_process(delta)

func set_state(value: State)->void:
	state = value
	_state_name = value.name

func transition_to(target_state_path: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		print("target_state_path:  ",target_state_path," not part of the state machine.")
		return
	print("transition to: "+target_state_path+" with msg: ",msg)
	var target_state: Node = get_node(target_state_path)
	# exit the current state
	state.exit()
	# enter the new one
	self.state = target_state
	state.enter(msg)
