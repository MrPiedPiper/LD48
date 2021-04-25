extends Node2D

export var speed = 30.0
export var max_speed = 100.0
export var ship_size = Vector2(16,16)

var velocity = Vector2.ZERO
var friction = 25.0

#Player movement code is based on movement code from HeartBeast's video: "Make an Action RPG in Godot 3.2 (P2 | delta + smooth movement)"
func _process(delta):
	var input = Vector2(Input.get_action_strength("input_right")-Input.get_action_strength("input_left"),Input.get_action_strength("input_down")-Input.get_action_strength("input_up"))
	input = input.normalized()
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
		$BaseWeapon.fire()
