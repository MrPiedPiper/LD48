extends Node2D

var speed = 250

func _process(delta):
	#Thanks to kidscancode for the next line. Page found at https://godotengine.org/qa/25996/how-to-do-movement-based-on-rotation
	position += Vector2(1,0).rotated(rotation) * speed * delta
