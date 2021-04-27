extends Node2D

export var speed = 30.0
export var max_speed = 100.0
export var ship_size = Vector2(16,16)

var curr_menu = null

var velocity = Vector2.ZERO
var friction = 25.0

onready var audioStreamPlayer2D = $AudioStreamPlayer2D

# when the node and it's children are ready, creates a variable, animationPlayer, that is the AnimationPlayer
onready var animationPlayer = $AnimationPlayer

#Player movement code is based on movement code from HeartBeast's video: "Make an Action RPG in Godot 3.2 (P2 | delta + smooth movement)"
func _process(delta):
	var input = Vector2(Input.get_action_strength("input_right")-Input.get_action_strength("input_left"),Input.get_action_strength("input_down")-Input.get_action_strength("input_up"))
	input = input.normalized()
	
	#input has the player input as a normalized Vector2
	if input.y > 0:
		animationPlayer.play("Down")
	elif input.y < 0:
		animationPlayer.play("Up")	
	if input.y == 0:
		animationPlayer.play("LeftRight")
	
	if input == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
	else:
		velocity += input.normalized()*speed*delta
		velocity = velocity.clamped(max_speed*delta)
		
	var ship_rect_size = ship_size
	ship_rect_size = Vector2(16,16) #TODO Change when new sprite is decided
	if global_position.y - ship_rect_size.y/2 + velocity.y < 0:
		velocity.y = 0
		position.y = 0 + ship_rect_size.y/2
	if global_position.x - ship_rect_size.x/2 + velocity.x < 0:
		velocity.x = 0
		position.x = 0 + ship_rect_size.x/2
	if global_position.y + ship_rect_size.y/2 + velocity.y > 135:
		velocity.y = 0
		position.y = 135 - ship_rect_size.y/2
	if global_position.x + ship_rect_size.x/2 + velocity.x > 320:
		velocity.x = 0
		position.x = 320 - ship_rect_size.x/2
	position += velocity

func _input(event):
	if Input.is_action_just_pressed("input_a"):
		$BasicWeapon.fire()
#		audioStreamPlayer2D.play()


func _on_Player_area_entered(area):
	if area.is_in_group("PlayerBullet"): return
	area.queue_free()
	queue_free()
	open_menu()
	
func open_menu():
	var menu_template = load("res://DeathMenu.tscn")
	curr_menu = menu_template.instance()
	var main = get_tree().current_scene
	main.get_node("GUI").add_child(curr_menu)
