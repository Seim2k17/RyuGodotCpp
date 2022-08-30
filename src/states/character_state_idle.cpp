#include "character_state_idle.h"

using namespace godot;

void CharacterStateIdle::_register_methods()
{
	register_method("_process",&CharacterStateIdle::_process);
    register_method("handleInput",&CharacterStateIdle::handleInput);
	//register_method("update",&Player::getName);
}

void CharacterStateIdle::_init() {}

void CharacterStateIdle::_process(float delta) {
    update();
}

void CharacterStateIdle::update(/*player ...*/) {}

void CharacterStateIdle::handleInput(/*player ...*/){}