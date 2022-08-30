extends State

"""
parent state that abstracts & handles basic movement, move related nodes 
can delegate movement / utility functions to it
"""

export var max_speed_default: =Vector2(500.0,1500.0)
# very high acc_x value will result that the char will instant go up to 500px/sec, acc_y = gravity
export var acceleration_default: =Vector2(100000.0,3000.0)
export var jump_impulse: = 900.0 
export var falling_velo_threshold = 550

var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO
var anim_player:AnimationPlayer setget , get_animation_player

func get_animation_player() -> AnimationPlayer: 
	return owner.get_animation_player()

func physics_process(delta: float) -> void:
	#if owner.get_climbstate() == PlayerVariables.ClimbState.ENTERLADDER : return
	velocity = calculate_velocity(
		velocity,
		max_speed,
		acceleration,
		delta,
		get_move_direction()
	)
	#print("velo ", velocity)
	#this is responsible for moving the character
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	#Events.emit_signal("player_moved",owner)
	
	
static func calculate_velocity(
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
	#if owner.is_on_floor():
	#	new_velocity.y = 0	
	#print("new: ",new_velocity)		
	return new_velocity

static func get_move_direction() -> Vector2:
	var dir_ :Vector2 = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		1.0
	)
	#print(dir_)
	return dir_
