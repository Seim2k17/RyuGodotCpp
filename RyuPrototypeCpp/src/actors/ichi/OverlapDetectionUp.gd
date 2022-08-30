extends Area2D
onready var _parent = get_parent()

func _on_OverlapDetectionUp_area_entered(area):
	Events.emit_signal("set_overlap_object",PlayerVariables.DetectOverlap.UP,area, self.name)

func _on_OverlapDetectionUp_area_exited(area):
	Events.emit_signal("set_overlap_object",PlayerVariables.DetectOverlap.NONE,area, self.name)

func _on_OverlapDetectionUp_body_entered(body: Node):
	_parent.check_overlap_state(body,"up",self.get_global_position())
