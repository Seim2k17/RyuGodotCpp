extends Node2D

var char_state : String

func _ready():
	Events.connect("set_character_state",self,"_on_character_state")
	Events.connect("reset_overlap_detection",self,"_on_reset_positions")

func _on_reset_positions() -> void:
	get_node("OverlapDetectionUp").position = Vector2.ZERO
	get_node("OverlapDetectionDown").position = Vector2.ZERO

func _on_character_state(state : String) -> void:
	char_state = state
	
func check_overlap_state(body: Node, overlap_position: String, position : Vector2) -> void:
	match char_state:
		"JUMP":
			print("test JUMP_state at id: ",body.get_instance_id())
			#test for different groups / obstacles ?
			if body is TileMap and body.get_instance_id() == PlayerVariables.TileMapIDs["WALL"]:
				Events.emit_signal("character_at_obstacle",PlayerVariables.Obstacles["WALL"],position)
				print("BOOM down: on ",body," from ",overlap_position," at ", position," with id: ", body.get_instance_id())
