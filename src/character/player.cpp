#include "player.h"
#include <iostream>

using namespace godot;

void Player::_register_methods()
{
	register_method("_process",&Player::_process);
	register_method("getName",&Player::getName);
}

Player::Player()
{
}

Player::~Player() {}

//std::string
void
Player::getName()
{
	//return name;
}

void
Player::_init()
{
	name = std::string("Lola");
}

void
Player::_process(float delta)
{
	// just for testing if class is working -> see console-output
	std::cout << name << std::endl;
}
