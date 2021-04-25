extends Node2D

# Make a constant variable for the Enemy scene
const GreenAlien = preload("res://GreenAlien.tscn")

# Onready var for the SpawnPoints node
onready var spawnPoints = $SpawnPoints

# Make a variable named "points" and set it to "spawnPoints" children
# Shuffle/randomize the points
# Return a random point and it's location
func get_spawn_position():
	var points = spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position

# Set a variable "spawn_position" to a random spawn point
# Instance an enemy variable from Enemy scene and add it as a child to the current scene
func spawn_enemy():
	var spawn_position = get_spawn_position()
	var greenAlien = GreenAlien.instance()
	var main = get_tree().current_scene
	main.add_child(greenAlien)
	greenAlien.global_position = spawn_position

# When the timer runs out, spawn an enemy
func _on_Timer_timeout():
	spawn_enemy()
