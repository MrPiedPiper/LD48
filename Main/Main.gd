extends Node2D

var score = 0 setget set_score

onready var scoreLabel = $GUI/ScoreLabel

export var menu_template = preload("res://Menu.tscn")
var curr_menu = null

# Check if ESC is being pressed
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		open_menu()
	
# Instance an enemy variable from Enemy scene and add it as a child to the current scene
# To prevent opening multiple menus, set a bool to true
func open_menu():
	curr_menu = menu_template.instance()
	curr_menu.connect("unpause",self,"_on_menu_unpause")
	var main = get_tree().current_scene
	$GUI.add_child(curr_menu)
	get_tree().paused = true

func _on_menu_unpause():
	pass

func set_score(value):
	score = value
	scoreLabel.text = "Score = " + str(score)
	if score == 10:
		$GUI/DialogBox.start_dialog(2,true)
	elif score == 20:
		$GUI/DialogBox.start_dialog(3,false)


func _on_DialogBox_dialog_done(id):
#	print(str("finished dialog ",id))
	pass
