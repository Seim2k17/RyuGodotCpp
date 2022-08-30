#pragma once
//#include <Godot.hpp>
//#include <Node.hpp>

/*
namespace godot {

class CharacterState: public Node {
	GODOT_CLASS(CharacterState, Node)
*/

/*
* This class is an interface for every CharacterState
*/

class CharacterState{

public:

    virtual ~CharacterState();

    virtual void update(/*player ...*/);

    virtual void handleInput(/*player ...*/);


};

//}