extends Node

class_name State, "res://assets/icons/state.svg"

"""
State Interface for the character state machine
"""

#reference to the state machine this state belongs to
onready var _state_machine: = _get_state_machine(self)

# to make sure we call our own undhandled_input() 
# & physics_process() from the statemachine and not the engine-automatic-calls
func unhandled_input(event: InputEvent) -> void:
	return
	
func physics_process(delta: float) -> void:
	return
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	return
	
# exit the state
func exit() -> void:
	return

func _get_state_machine(node: Node) -> Node:
	if(node != null) and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())		
	return node
