extends CanvasLayer

onready var _container = $PanelContainer
onready var _content = get_node("PanelContainer/VBoxContainer/HBoxContainer/InteractionLabel_static")

export var visible = false

func _ready() -> void:
	Events.connect("set_interaction_ui",self,"_on_interaction_ui")
	_container.visible = visible
	
func _on_interaction_ui(is_visible: bool, text: String) -> void:
	_container.visible = is_visible
	_content.text = text
