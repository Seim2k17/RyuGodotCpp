#pragma once

#include <Godot.hpp>
#include <Node.hpp>
#include "character_state.h"

namespace godot {

class CharacterStateIdle: public CharacterState, public Node {
	GODOT_CLASS(CharacterStateIdle, Node)

public:

    static void _register_methods();
	void _init();
	void _process(float delta);

    void update(/*player ...*/) override;

    void handleInput(/*player ...*/) override;



};

} // namespace godot