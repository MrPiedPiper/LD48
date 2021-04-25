tool
extends Node

export(PackedScene) var dialog_template
export(bool) var new_dialog setget create_new_dialog

func create_new_dialog(value):
	if not Engine.editor_hint:return
	var new_scene = dialog_template.instance()
	var highest = -1
	for i in get_children():
		if i.id > highest:
			highest = i.id
	new_scene.id = highest + 1
	add_child(new_scene)
	#Thanks Zylann (https://godotengine.org/qa/9618/in-tool-mode-is-there-a-way-to-add-new-nodes)
	new_scene.set_owner(get_tree().get_edited_scene_root())
