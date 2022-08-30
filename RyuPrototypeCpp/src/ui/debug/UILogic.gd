extends CanvasLayer

export var fps_active : bool = false
var text = ""

func _ready() -> void:
	Events.connect("set_charstate_label",self,"_on_charstatelabel_text")
	Events.connect("set_climbstate_label",self,"_on_climbstatelabel_text")
	Events.connect("set_character_look_direction",self,"_on_lookdirection_text")
	Events.connect("set_overlap_label",self,"_on_overlaplabel_text")
	
func _on_overlaplabel_text(text_in: String) -> void:
	get_node("PanelContainer/VBoxContainer/HBoxContainerOverlap/CurrentOverlapLabel").text = text_in

func _on_climbstatelabel_text(text_in: String) -> void:
	get_node("PanelContainer/VBoxContainer/HBoxContainerClimb/CurrentClimbLabel").text = text_in

func _on_lookdirection_text(dir_in:Vector2) -> void:
	if(dir_in.x < 0) : text = "Left"
	if(dir_in.x > 0) : text = "Right"
	get_node("PanelContainer/VBoxContainer/HBoxContainerLookDir/CurrentDirLabel").text = text	
	
func _on_charstatelabel_text(text_in: String) -> void:
	get_node("PanelContainer/VBoxContainer/HBoxContainer/CurrentStateLabel").text = text_in
	
func _physics_process(delta: float) -> void:
	if fps_active:
		get_node("PanelContainer/VBoxContainer/HBoxContainerFPS/CurrentFPSLabel").text = str(Performance.get_monitor(Performance.TIME_FPS))
