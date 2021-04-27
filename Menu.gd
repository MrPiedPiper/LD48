extends MarginContainer

export var menu_template = preload("res://HowToPlay.tscn")
var curr_menu = null

signal unpause

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		yield(get_tree(),"idle_frame")
		resume_game()
		close_menu()

func close_menu():
	queue_free()

func resume_game():
	get_tree().paused = false
	emit_signal("unpause")
	

func _on_Play_button_up():
	yield(get_tree(),"idle_frame")
	resume_game()
	close_menu()

func _on_HowToPlayButton_button_up():
	open_HowToPlay()
	close_menu()

func open_HowToPlay():
	curr_menu = menu_template.instance()
	var main = get_tree().current_scene
	main.get_node("GUI").add_child(curr_menu)

