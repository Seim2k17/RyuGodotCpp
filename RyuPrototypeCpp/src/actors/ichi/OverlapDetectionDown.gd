extends Area2D
onready var _parent = get_parent()

func _on_OverlapDetectionDown_area_entered(area):
	Events.emit_signal("set_overlap_object",PlayerVariables.DetectOverlap.DOWN,area, self.name)

func _on_OverlapDetectionDown_area_exited(area):
	Events.emit_signal("set_overlap_object",PlayerVariables.DetectOverlap.NONE,area, self.name)

func _on_OverlapDetectionDown_body_entered(body: Node):
	_parent.check_overlap_state(body,"down",self.get_global_position())
