extends Node2D

"""

enum move_types {walk,run,fall_low}

export var spritesheets_mapping = {
	#str(move_types.keys()[walk]) : 1
}

var active_spritesheet : String = "fall_low";

func _ready() -> void:
	Events.connect("activate_spritesheet_animation",self,"_on_spritesheet_activate")
	#Events.connect("flip_spritesheet",self,"_on_spritesheet_flip")
	
func _on_spritesheet_flip(flip: bool) -> void:
	get_node(spritesheets_mapping[active_spritesheet]).flip_h = flip
	return
	
func _on_spritesheet_activate(sheet: String, animation: String) -> void:
	if active_spritesheet != "":
		get_node(spritesheets_mapping[active_spritesheet]).visible = false
	var new_sheet = get_node(spritesheets_mapping[sheet])
	new_sheet.visible = true
	#Events.
	active_spritesheet = sheet
	#print("activate spritesheet ",sheet," and animation: ",animation)
	#we don't want to use animationtree anymore
	#if state != "" : Events.emit_signal("travel_to_state",state) 
	Events.emit_signal("play_animation",animation)

"""
