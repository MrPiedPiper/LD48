extends Node2D

var score = 0 setget set_score

onready var scoreLabel = $GUI/ScoreLabel

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
