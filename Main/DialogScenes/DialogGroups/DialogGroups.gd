extends Node

func get_dialog_by_id(id):
	if id == -1:
		return null
	for i in $Dialogs.get_children():
		if i.id == id:
			return i
	return null
