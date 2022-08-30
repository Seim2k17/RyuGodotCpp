extends State

onready var climb_state = get_parent()
var ladder_detector = null

export var max_ladder_speed_default: =Vector2(150.0,150.0)
export var acc_ladder_default: =Vector2(100.0,100.0)
var anim_player : AnimationPlayer = null
var velocity: = Vector2.ZERO
var max_speed = max_ladder_speed_default
var acceleration = acc_ladder_default
var position = ""
var pl : Player
var ladder_infos = {}
var collide_high = false
var collide_up = false
var collide_mid = false
var collide_down = false
var direction_event_send = false

func _ready() -> void:
	#player.connect("finished", self, "playNextAnim")
	Events.connect("set_ladder_infos",self,"_on_set_ladder_infos")
	pass

func _on_set_ladder_infos(msg : Dictionary) -> void:
	ladder_infos = msg
	if "climboutTop" in msg:
		print("ClimboutTop at this Ladder: ",PlayerVariables.LadderClimboutState.keys()[ladder_infos["climboutTop"]])
	if "climboutBottom" in msg:
		print("ClimboutBtm at this Ladder: ",PlayerVariables.LadderClimboutState.keys()[ladder_infos["climboutBottom"]])	

func unhandled_input(event: InputEvent) -> void:
	climb_state.unhandled_input(event)
	pass
	
func physics_process(delta: float) -> void:
	climb_state.physics_process(delta)
	if(owner.get_climbstate() == PlayerVariables.ClimbState.NONE or owner.get_climbstate() == PlayerVariables.ClimbState.ENTERLADDER):
		return
		
	if(owner.get_climbstate() == PlayerVariables.ClimbState.EXITLADDERUP):
		exit_ladder("top")
		return

	if(owner.get_climbstate() == PlayerVariables.ClimbState.EXITLADDERDOWN):
		exit_ladder("bottom")
		return
	
	velocity = calculate_ladder_velocity(
		velocity,
		max_speed,
		acceleration,
		delta,
		get_ladder_direction()
	)
	
	var moveUp = Input.get_action_strength("move_up_jump")
	var moveDown = Input.get_action_strength("move_down")
	
	#print("ladder_move_dir: ",get_ladder_direction(), " up: ",moveUp, " down: ", moveDown)
	if(moveUp == 0 and moveDown == 0):
		on_ladder_idle()
		return
	#print(velocity)
	if moveUp > 0: 
		if(velocity.y < 0):
			move_ladder_up()
			velocity = owner.move_and_slide(velocity, owner.LADDER_NORMAL)
		else:
			velocity = Vector2.ZERO
		
	if moveDown > 0:
		if(velocity.y > 0):
			move_ladder_down()
			velocity = owner.move_and_slide(velocity, owner.LADDER_NORMAL)
		else:
			#velocity = Vector2.ZERO
			velocity.y = 50

func on_ladder_idle() -> void:
	direction_event_send = false
	if(owner.get_climbstate() != PlayerVariables.ClimbState.LADDERIDLE):
		owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_idle")
	pass		
		
func move_ladder_up() -> void:
	if(get_top_exit_state()):
		print("timeToExit")
		owner.set_climbstate(PlayerVariables.ClimbState.EXITLADDERUP)
		return
	send_direction_event("Top")
	if(owner.get_climbstate() != PlayerVariables.ClimbState.LADDERUP):
		print("play ladder_loop_up")
		Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_loop")
		owner.set_climbstate(PlayerVariables.ClimbState.LADDERUP)
	

func send_direction_event(direction: String) -> void:
	
	if(!direction_event_send):
		var _dirX = 0
		if((ladder_infos["climbout"+direction] == PlayerVariables.LadderClimboutState.BOTTOMRIGHT) or (ladder_infos["climbout"+direction] == PlayerVariables.LadderClimboutState.TOPRIGHT)):
			_dirX = 1
		if((ladder_infos["climbout"+direction] == PlayerVariables.LadderClimboutState.BOTTOMLEFT) or (ladder_infos["climbout"+direction] == PlayerVariables.LadderClimboutState.TOPLEFT)):
			_dirX = -1
		Events.emit_signal("set_character_look_direction",Vector2(_dirX,0))
		direction_event_send = true

func move_ladder_down() -> void:
	send_direction_event("Bottom")
	if (ladder_detector.is_colliding()):
		print("On the ground")
		if(owner.get_climbstate() != PlayerVariables.ClimbState.EXITLADDERDOWN):
			#Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_out_btm")
			owner.set_climbstate(PlayerVariables.ClimbState.EXITLADDERDOWN)
			return
		
	if(owner.get_climbstate() != PlayerVariables.ClimbState.LADDERDOWN):
		print("play ladder_loop_down")
		Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_loop")
		owner.set_climbstate(PlayerVariables.ClimbState.LADDERDOWN)
	pass
	
func exit_ladder(out_position: String) -> void:
	position = out_position
	print("exit ladder: ",out_position)
	if (out_position == "top"):
		if (ladder_infos["climboutTop"] == PlayerVariables.LadderClimboutState.TOPRIGHT):
			Events.emit_signal("activate_spritesheet_animation","climb_ladder_out_r","climb_ladder_out_top_r")
		if (ladder_infos["climboutTop"] == PlayerVariables.LadderClimboutState.TOPLEFT):
			Events.emit_signal("activate_spritesheet_animation","climb_ladder_out_l","climb_ladder_out_top_l")	
		else:
			if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
				Events.emit_signal("activate_spritesheet_animation","climb_ladder_out_r","climb_ladder_out_top_r")
			if owner.look_direction == PlayerVariables.LookDirection.LEFT:
				Events.emit_signal("activate_spritesheet_animation","climb_ladder_out_l","climb_ladder_out_top_l")
	if (out_position == "bottom"):
		Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_out_btm")
		
	owner.set_climbstate(PlayerVariables.ClimbState.NONE)		
	
	
func on_animation_finished(name: String) -> void:
	match name:
		"climb_ladder_out_top_l":
			_state_machine.transition_to("Move/Idle",{"ladder":true})
		"climb_ladder_out_top_r":
			_state_machine.transition_to("Move/Idle",{"ladder":true})
		"climb_ladder_out_btm":
			_state_machine.transition_to("Move/Idle",{"ladder":true})
		"climb_ladder_in_top_l":
			owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		"climb_ladder_in_top_r":
			owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		"climb_ladder_in_btm_r":
			owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		"climb_ladder_in_btm_l":
			owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		
func get_top_exit_state() -> bool:
	collide_high = owner.is_ledge_colliding(PlayerVariables.LedgePosition.HIGH)
	collide_up = owner.is_ledge_colliding(PlayerVariables.LedgePosition.UP)
	collide_mid = owner.is_ledge_colliding(PlayerVariables.LedgePosition.MID)
	collide_down = owner.is_ledge_colliding(PlayerVariables.LedgePosition.DOWN)	
	return (!collide_high and !collide_up and !collide_mid and collide_down)
	

func enter(msg: Dictionary = {}) -> void:
	climb_state.enter(msg)
	Events.emit_signal("set_character_state","LADDER")
	ladder_detector = owner.get_ladder_detector()	
	Events.emit_signal("activate_spritesheet_animation","climb_ladder","climb_ladder_idle")
	#Events.emit_signal("set_animation_frame","climb_ledge_"+owner.get_ani_postfix(),0)
	
	owner.set_playerstate(PlayerVariables.CharacterState.CLIMB)
	
	anim_player = owner.get_animation_player()
	anim_player.connect("animation_finished", self, "on_animation_finished")
	print("ladderpos: ",ladder_infos["position"]," x: ",ladder_infos["position"].x)
	
	set_player_on_ladder()
	
func set_player_on_ladder() -> void:
	var overlaps : Dictionary = owner.get_overlap_state()
	var ladderPosi = Vector2(ladder_infos["position"].x,0)
	if overlaps["up"] == true:
		send_direction_event("Top")
		#TODO remove the flwd. line later when animation is there
		owner.set_climbstate(PlayerVariables.ClimbState.LADDERIDLE)
		if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
			ladderPosi.y = owner.position.y - PlayerVariables.ClimbPosition["LadderMid"].y
		if owner.look_direction == PlayerVariables.LookDirection.LEFT:
			ladderPosi.y = owner.position.y + PlayerVariables.ClimbPosition["LadderMid"].y
	else:
		if overlaps["down"] == true:
			send_direction_event("Bottom")
			ladderPosi.y = owner.position.y + PlayerVariables.ClimbPosition["LadderTopRight"].y
			if owner.position.x < ladderPosi.x:
				Events.emit_signal("activate_spritesheet_animation","climb_ladder_in_l","climb_ladder_in_top_l")
			if owner.position.x > ladderPosi.x:
				Events.emit_signal("activate_spritesheet_animation","climb_ladder_in_r","climb_ladder_in_top_r")
	
	owner.position = ladderPosi
	
static func calculate_ladder_velocity(
	old_velocity : Vector2,
	max_speed : Vector2,
	acceleration : Vector2,
	delta: float,
	move_direction : Vector2
) -> Vector2:
	var new_velocity: =old_velocity
	#print("old: ",new_velocity)
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x,-max_speed.x,max_speed.x)
	new_velocity.y = clamp(new_velocity.y,-max_speed.y,max_speed.y)
	if(Input.get_action_strength("move_right") == 0 and Input.get_action_strength("move_left") == 0):
		new_velocity.x = 0
	if(Input.get_action_strength("move_up_jump") == 0 and Input.get_action_strength("move_down") == 0):
		new_velocity.y = 0
	#if owner.is_on_floor():
	#	new_velocity.y = 0	
	#print("new: ",new_velocity)		
	return new_velocity

func get_player_climbout(side) -> Vector2:
	var p_position: Vector2 = owner.position
	match side:
		#Top
		PlayerVariables.LadderClimboutState.TOPLEFT :
			p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderTopLeft"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderTopLeft"].y)
		PlayerVariables.LadderClimboutState.TOPRIGHT :
			p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderTopRight"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderTopRight"].y) 
		PlayerVariables.LadderClimboutState.TOPBOTH :
			if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
				p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderTopRight"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderTopRight"].y) 
			if owner.look_direction == PlayerVariables.LookDirection.LEFT:
				p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderTopLeft"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderTopLeft"].y)	
		#Bottom
		PlayerVariables.LadderClimboutState.BOTTOMLEFT :
			p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderBtmLeft"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderBtmLeft"].y)
		PlayerVariables.LadderClimboutState.BOTTOMRIGHT :
			p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderBtmRight"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderBtmRight"].y)
		PlayerVariables.LadderClimboutState.BOTTOMBOTH :
			if owner.look_direction == PlayerVariables.LookDirection.RIGHT:
				p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderBtmRight"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderBtmRight"].y) 
			if owner.look_direction == PlayerVariables.LookDirection.LEFT:
				p_position += (Vector2.RIGHT * PlayerVariables.ClimbPosition["LadderBtmLeft"].x + Vector2.UP * PlayerVariables.ClimbPosition["LadderBtmLeft"].y)	
	return p_position

func exit() -> void:
	climb_state.exit()
	var side = check_climbout_side(position)
	owner.position = get_player_climbout(side)
	
	anim_player.disconnect("animation_finished",self,"on_animation_finished")
	if owner.get_inside_ladder():
		Events.emit_signal("set_interaction_ui",true,ladder_infos["ladderText"])
		owner.set_climbstate(PlayerVariables.ClimbState.ENTERLADDER)
	pass
	
func check_climbout_side(position : String) :
	if position == "top" :
		if "climboutTop" in ladder_infos:
			return ladder_infos["climboutTop"]
	if position == "bottom" :
		if "climboutBottom" in ladder_infos:
			return ladder_infos["climboutBottom"]

static func get_ladder_direction() -> Vector2:
	var dir_ :Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up_jump")
	)
	#print(dir_)
	return dir_
