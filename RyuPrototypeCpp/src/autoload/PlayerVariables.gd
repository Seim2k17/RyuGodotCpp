extends Node

enum LookDirection {LEFT, RIGHT, UP, DOWN}

enum LedgePosition {HIGH,UP,MID,DOWN}

var LedgeDetectorCastTo = Vector2(50,0) 

enum CharacterState {
	IDLE,
	RUN,
	CLIMB,
	JUMP,
	FALLING,
	FALLING_END,
	COMBAT,
}

enum CombatState{
	FIST,
	SWORD,
}

enum CombatMove{
	STAND,
	WALK
}
					
enum ClimbState {
	NONE,
	ENTERLADDER,
	LADDERIDLE,
	LADDERUP,
	LADDERDOWN,
	EXITLADDERUP,
	EXITLADDERDOWN,
	CLIMBLEDGE
}

enum DetectOverlap {
	NONE,
	UP,
	DOWN,
	UPDOWN
}

enum LadderClimboutState {
	TOPRIGHT,TOPLEFT,TOPBOTH,BOTTOMLEFT,BOTTOMRIGHT,BOTTOMBOTH
}

enum Weapons {
	NONE,
	KATANA,
}

var Obstacles = {
	"WALL" : "_wall_",
	"SPIKES" : "_spikes_",
	"BOX" : "_box_"
}

var ClimbPosition = {
	"High" : Vector2(0,0),
	"Mid" : Vector2(41,82),
	"Low" : Vector2(0,0),
	"LadderMid" : Vector2(-20,10),
	"LadderTopRight" : Vector2(25,60),
	"LadderTopLeft" : Vector2(-25,60),
	"LadderBtmRight" : Vector2(10,0),
	"LadderBtmLeft" : Vector2(-10,0),
}

# this is not a perfect approach, we need to find out the IDs 
# of the used tileMaps to which the character reacts differently 
# when colliding / overlaps in animations
# LOL: the ids ar not uniqie !-> after restart they are newly generated ?
var TileMapIDs = {
	"WALL" : 1336, #1330, 1355,1336,1335
	"GROUND" : 1329
}
