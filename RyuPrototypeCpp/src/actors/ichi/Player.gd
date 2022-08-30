extends KinematicBody2D
class_name Player
# ! need to convert to c++
# x done converting to c++

onready var state_machine: StateMachine = $StateMachine
onready var overlap: CollisionShape2D = $CollisionShape2D
onready var anim_player: AnimationPlayer = $AnimationPlayer setget ,get_animation_player
onready var spritesheets: Node2D = $Spritesheets
onready var ledge_detector_high = $LedgeDetector_high
onready var ledge_detector_up = $LedgeDetector_up
onready var ledge_detector_mid = $LedgeDetector_mid
onready var ledge_detector_down = $LedgeDetector_down
onready var ladder_detector = $LadderDetector setget ,get_ladder_detector
onready var player_position: Vector2 = Vector2.ZERO
onready var main_cam : Camera2D = get_node("/root/Scene/MainCam")
onready var player_in_scene : bool = true
onready var to_direction : String = "";
onready var clamp_direction = 0

var _move_direction = Vector2.ZERO
var ani_postfix = "r" setget , get_ani_postfix
var _playerstate = PlayerVariables.CharacterState.IDLE setget set_playerstate, get_playerstate
var _climbstate = PlayerVariables.ClimbState.NONE setget set_climbstate, get_climbstate
var _combatstate = PlayerVariables.CombatState.FIST setget set_combatstate, get_combatstate
var inside_ladder_area = false setget , get_inside_ladder
const FLOOR_NORMAL : = Vector2.UP
const LADDER_NORMAL = Vector2.ONE
var ACTIVE_WEAPON = PlayerVariables.Weapons.NONE

var ledge_detection_on = true
var is_active: bool = true setget set_is_active
var look_direction = PlayerVariables.LookDirection.RIGHT setget ,get_look_direction
var overlap_up : bool
var overlap_down: bool

func _ready() -> void:
	connect_signals()
	set_ledge_detection(ledge_detection_on)
	
func connect_signals() -> void:
	Events.connect("set_character_look_direction",self,"_on_character_look_direction")
	Events.connect("set_animation_frame",self,"_on_set_animation_frame")
	Events.connect("set_player_in_scene",self,"_on_set_player_in_scene")
	Events.connect("play_animation",self,"_on_play_animation")
	Events.connect("set_ladder_area",self,"_on_inside_ladder_area")
	Events.connect("set_overlap_object",self,"_on_overlap_detection")	
	anim_player.connect("animation_finished",self,"_on_animation_finished")

func _on_overlap_detection(state, overlap: Area2D, source: String) -> void:
	var _text : String = ""
	#print(overlap.name+" overlaps from "+ source)
	if (state == PlayerVariables.DetectOverlap.DOWN):
		overlap_down = true
	
	if (state == PlayerVariables.DetectOverlap.UP):
		overlap_up = true
	
	if (source == "OverlapDetectionUp" and state == PlayerVariables.DetectOverlap.NONE):
		overlap_up = false
		
	if (source == "OverlapDetectionDown" and state == PlayerVariables.DetectOverlap.NONE):
		overlap_down = false
		
	if (overlap_up and overlap_down):
		_text = "OverlapUpDown"
	else:
		if(overlap_up):
			_text = "OverlapUp"
		if(overlap_down):
			_text = "OverlapDown"
		if(overlap_up == false and overlap_down == false):
			_text = "-NONE-"

	Events.emit_signal("set_overlap_label",_text)
	
func get_overlap_state() -> Dictionary :
	return {"up" : overlap_up, "down" : overlap_down}
	
func get_ani_postfix() -> String:
	return ani_postfix
	
func get_ladder_detector() -> RayCast2D:
	return ladder_detector
	
func get_inside_ladder() -> bool:
	return inside_ladder_area

func _on_inside_ladder_area(inside: bool) -> void:
	inside_ladder_area = inside
	print("inside ladder: ",inside_ladder_area)

func _on_animation_finished(name: String) -> void:
	pass
	
func set_combatstate(state) -> void:
	_combatstate = state

func get_combatstate():
	return _combatstate
		
func set_playerstate(state) -> void:
	_playerstate = state
	Events.emit_signal("set_charstate_label",PlayerVariables.CharacterState.keys()[state])

func get_playerstate() :
	return _playerstate
	
func set_climbstate(state) -> void:
	_climbstate = state
	Events.emit_signal("set_climbstate_label",PlayerVariables.ClimbState.keys()[state])
	
func set_activeweapon(weapon) -> void:
	ACTIVE_WEAPON = weapon
	pass

func get_climbstate() :
	return _climbstate

func set_ledge_detection(state:bool) -> void:
	ledge_detector_down.set_enabled(state)
	ledge_detector_mid.set_enabled(state)
	ledge_detector_up.set_enabled(state)
	ledge_detector_high.set_enabled(state)
	ladder_detector.set_enabled(state)	
	
func _on_set_player_in_scene(char_in_scene:bool) -> void:
	player_in_scene = char_in_scene
	
func is_ledge_colliding(direction) -> bool:
	match(direction):
		PlayerVariables.LedgePosition.HIGH:
			return ledge_detector_high.is_colliding()
		PlayerVariables.LedgePosition.UP:
			return ledge_detector_up.is_colliding()
		PlayerVariables.LedgePosition.MID:
			return ledge_detector_mid.is_colliding()
		PlayerVariables.LedgePosition.DOWN:
			return ledge_detector_down.is_colliding()
		'': 
			print("PLease select ledge detector: {HIGH,UP,MID,DOWN}")		
			
	return false
	
func get_clamp_direction() -> int:
	return clamp_direction
	
func is_char_in_viewport() -> bool:
	var in_viewport : bool = true
	var playerPosi : Vector2 = get_position()
	var viewportSize : Vector2 = main_cam.get_viewport().get_size_override()

	if playerPosi.x < (main_cam.position.x - viewportSize.x/2):
		to_direction = "left"
		in_viewport = false

	if playerPosi.x > (main_cam.position.x + viewportSize.x/2):
		to_direction = "right"
		in_viewport = false 

	if playerPosi.y < (main_cam.position.y - viewportSize.y/2):
		to_direction = "up"
		in_viewport = false	

	if playerPosi.y > (main_cam.position.y + viewportSize.y/2):
		to_direction = "down"
		in_viewport = false
		
	return in_viewport

func change_scene(new_posi: String) -> void:
	print("outside scene ",new_posi)
	player_in_scene = false
	Events.emit_signal("move_camera",new_posi)
	
func check_viewport() -> void:
	if is_char_in_viewport() == false and player_in_scene == true:
		change_scene(to_direction)
		#to_direction = ""

func _on_set_animation_frame(animation: String, frame: int) -> void:
	print("set ",animation," to frame: ",frame)
	anim_player.seek(0)
	#anim_player.get_animation(animation).set
	pass

func get_animation_player() -> AnimationPlayer:
	return anim_player
	
func get_mid_ledge_detector() -> RayCast2D:
	return ledge_detector_mid

func _on_character_look_direction(move_direction: Vector2) -> void:
	_move_direction = move_direction
	if move_direction.x > 0:
		look_direction = PlayerVariables.LookDirection.RIGHT
		ani_postfix = "r"
		
	if move_direction.x < 0:
		look_direction = PlayerVariables.LookDirection.LEFT
		ani_postfix = "l"
	# up dan down (y) added here if needable
	
	if look_direction == PlayerVariables.LookDirection.RIGHT : clamp_direction = 1
	if look_direction == PlayerVariables.LookDirection.LEFT : clamp_direction = -1
	
	ledge_detector_high.cast_to = PlayerVariables.LedgeDetectorCastTo * clamp_direction
	ledge_detector_up.cast_to = PlayerVariables.LedgeDetectorCastTo * clamp_direction
	ledge_detector_mid.cast_to = PlayerVariables.LedgeDetectorCastTo * clamp_direction
	ledge_detector_down.cast_to = PlayerVariables.LedgeDetectorCastTo * clamp_direction	
	
	return
	
func get_look_direction():
	return look_direction
	
func flip_sprite_horizontal(flip: bool) -> void:
	return
	
func set_is_active(value: bool) -> void:
	is_active = value
	# if there is no overlap -> exit
	if not overlap:
		return
	overlap.disabled = not value

func _on_play_animation(name: String) -> void:
	anim_player.stop()
	anim_player.play(name)

func play_animation(name: String, x_dir_val: Vector2) -> void:
	anim_player.stop()
	#print("anim_player: ",name," dir: ",str(x_dir_val))
	anim_player.play(name+"_l") if x_dir_val.x < 0 else anim_player.play(name+"_r")
	pass
	
func _physics_process(delta: float) -> void:
	pass
	
func set_velocity(velo: Vector2) -> void:
	pass	
	
func print_camprefs() -> void:
	print("CamPosi: ",main_cam.position)
	print("CamViewportSizeOverride: ",main_cam.get_viewport().get_size_override())
	print("CamViewportSize: ",main_cam.get_viewport().get_size())
	print("CharacterPosition: ",get_position())
