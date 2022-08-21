#pragma once

#include <Godot.hpp>
#include <KinematicBody2D.hpp>
#include <string>

namespace godot {

class Player: public KinematicBody2D {
	GODOT_CLASS(Player, KinematicBody2D)


public:
	Player();
	~Player();

	//std::string 
	void getName();

	static void _register_methods();
	void _init();
	void _process(float delta);

private:
	std::string name;
};



}
