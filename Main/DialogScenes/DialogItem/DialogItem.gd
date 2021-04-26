extends Node

enum Sides {
	NONE = -1,
	LEFT = 0,
	RIGHT = 1,
	BOTH = 2,
}

export(String,MULTILINE) var dialog
export(Sides) var speaking = -1
export(Characters.CharacterIds) var left_id = -1
export(Characters.FrameIds) var left_frame
export(Characters.CharacterIds) var right_id = -1
export(Characters.FrameIds) var right_frame
export(float) var text_speed = 0.125
