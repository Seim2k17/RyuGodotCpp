"""

extends Node

# player state
signal player_moved(player)
signal set_character_look_direction(direction)
signal set_ladder_infos(message)
signal set_ladder_area(inside)
signal set_overlap_object(state, collider, source)
# [set_character_state] - signal transmit an string describing the state 
# (as enums are not unique when more than one enum is involed) 
# -> for detecting overlaps in cinematic animations
signal set_character_state(state)
signal character_at_obstacle(obstacle,position)

# camera
signal move_camera(newPosition)
signal set_player_in_scene(state)

# animation
signal play_animation(animationname)
signal activate_spritesheet_animation(sheet,animation)
signal flip_spritesheet(flip)
signal set_animation_frame(animation,frame)
signal reset_overlap_detection()
# ui
signal set_interaction_ui(visible, content)
signal set_charstate_label(state)
signal set_climbstate_label(state)
signal set_overlap_label(collission)

"""
