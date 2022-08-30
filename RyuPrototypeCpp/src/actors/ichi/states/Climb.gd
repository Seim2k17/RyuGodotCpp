extends State

"""
This is the base-class for climbing states, here is everthing which is important for every climbing stae
"""

func unhandled_input(event: InputEvent) -> void:
	pass
	
func physics_process(delta: float) -> void:
	owner.check_viewport()
	pass
	
# enter the state
func enter(msg: Dictionary = {}) -> void:
	pass
	
# exit the state
func exit() -> void:
	
	
	pass
