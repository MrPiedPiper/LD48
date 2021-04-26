extends MarginContainer

var curr_menu = null

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		yield(get_tree(),"idle_frame")
		open_menu()
		close_menu()

func close_menu():
	queue_free()

func _on_BackButton_button_up():
	open_menu()
	close_menu()

func open_menu():
	var menu_template = load("res://Menu.tscn")
	curr_menu = menu_template.instance()
	var main = get_tree().current_scene
	main.get_node("GUI").add_child(curr_menu)
