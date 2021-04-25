extends Node

enum CharacterIds {
	NONE=-1,
	PLAYER,
}
enum FrameIds {
	NEUTRAL,
	SHOCK,
	ANGER,
	SAD,
}

func get_characters():
	return get_children()

func get_character_by_id(id):
	for i in get_characters():
		if i.id == id:
			return i
	return null
