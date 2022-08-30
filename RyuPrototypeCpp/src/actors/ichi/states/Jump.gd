extends State

onready var move_state = get_parent()
onready var ground_detector = owner.get_ladder_detector()
var move_to_obstacle = false

var anim_player : AnimationPlayer = null
var x_size_jump = 260
var char_hits_obstacle = false
var char_at_obstacle_position : Vector2 = Vector2.ZERO

func _ready():
	Events.connect("character_at_obstacle",self,"_on_hit_obstacle")

func _on_hit_obstacle(obstacle: String, position : Vector2) -> void:
	print(" hit on ",obstacle)
	char_at_obstacle_position = position
	char_hits_obstacle = true
	if obstacle == PlayerVariables.Obstacles["WALL"]:
			# refine: atm just set to falling
			character_on_wall()
			
func character_on_wall() -> void:
	# stops current animations / set character on current position
	Events.emit_signal("reset_overlap_detection")
	# TODO: when character hits an obstacle a rebound state is set (acc. how hard)  
	_state_machine.transition_to("Move/Air")


func unhandled_input(event: InputEvent) -> void:
	move_state.unhandled_input(event)
	return
	
func physics_process(delta: float) -> void:
	pass

func on_animation_finished(name: String)->void:
	# later check if character is in air at the last part of animation then falling state, otherwise idle
	_state_machine.transition_to("Move/Air")

func check_collider() -> Dictionary:
	var collide_high = owner.is_ledge_colliding(PlayerVariables.LedgePosition.HIGH)
	var collide_up = owner.is_ledge_colliding(PlayerVariables.LedgePosition.UP)
	var collide_mid = owner.is_ledge_colliding(PlayerVariables.LedgePosition.MID)
	var collide_down = owner.is_ledge_colliding(PlayerVariables.LedgePosition.DOWN)
	
	return {"high": collide_high, "up":collide_up,"mid":collide_mid,"down":collide_down}
	
# enter the state
#to do adjust on new signal
func enter(msg: Dictionary = {}) -> void:
	anim_player = move_state.get_animation_player()
	anim_player.connect("animation_finished",self,"on_animation_finished")	
	var test = check_collider()
	# if climbable ledge in sight
	if(test["high"] or test["up"] or test["mid"] or test["down"]) :
		var rc : RayCast2D = owner.get_mid_ledge_detector()
		print(rc.get_collision_point())
		if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
			char_at_obstacle_position = Vector2(rc.get_collision_point().x-15,owner.position.y)
		if owner.look_direction == PlayerVariables.LookDirection.LEFT:
			char_at_obstacle_position = Vector2(rc.get_collision_point().x+15,owner.position.y)
		char_hits_obstacle = true
		_state_machine.transition_to("Move/Idle")
		
	else:
		
		Events.emit_signal("set_character_state","JUMP")
		Events.emit_signal("activate_spritesheet_animation","jump_"+owner.get_ani_postfix(),"jump_"+owner.get_ani_postfix())
		Events.emit_signal("set_animation_frame","jump_"+owner.get_ani_postfix(),0)
		owner.set_playerstate(PlayerVariables.CharacterState.JUMP)
		return
	
# exit the state
func exit() -> void:
	if char_hits_obstacle == false:
		if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
			owner.position += Vector2.RIGHT * x_size_jump
		if owner.look_direction == PlayerVariables.LookDirection.LEFT:
			owner.position -= Vector2.RIGHT * x_size_jump
	else:
		char_hits_obstacle = false
		owner.position = char_at_obstacle_position
		char_at_obstacle_position = Vector2.ZERO
		
	anim_player.disconnect("animation_finished",self,"on_animation_finished")
	
	#Todo: check position if outside the screen and switch camera
	return
