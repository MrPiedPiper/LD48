extends Area2D

var speed = 250

func _ready():
	if not is_in_group("PlayerBullet"):
		rotation_degrees = 180
		$icon.flip_v = true
#		modulate = Color(0.5,0,0,1)

func _process(delta):
	#Thanks to kidscancode for the next line. Page found at https://godotengine.org/qa/25996/how-to-do-movement-based-on-rotation
	position += Vector2(1,0).rotated(rotation) * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_BaseBullet_area_entered(area):
	pass # Replace with function body.
