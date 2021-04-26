extends Node2D

export var bullet = preload("res://Weapons/Bullets/BaseBullet/BaseBullet.tscn")
export var shoot_cooldown = 0.5
export var is_player = true
export var bullet_speed = -1
export(float) var shoot_delay = 0

#BaseWeapon needs a delay from click to shot. 
#Split fire() into 2 functions. One to summon the bullet, one to "fire". 
#Only fire if the weapon is not already firing. 
#The fire uses the delay timer if the delay exists. 

var can_shoot = true
onready var timer = $TimerShoot
onready var timer_delay = $TimerDelay

func _ready():
	timer.wait_time = shoot_cooldown
	timer_delay.wait_time = shoot_delay

func summon_bullet():
	var curr_bullet = bullet.instance()
	if is_player:
		curr_bullet.add_to_group("PlayerBullet")
	else:
		curr_bullet.add_to_group("EnemyBullet")
	if bullet_speed != -1:
		curr_bullet.speed = bullet_speed
	curr_bullet.global_position = global_position
	get_tree().current_scene.add_child(curr_bullet)
	timer.start()

#On press summon shot and assign group
func fire():
	if can_shoot:
		if shoot_delay <= 0:
			summon_bullet()
			can_shoot = false
		else:
			timer_delay.start()
			can_shoot = false

func _on_TimerShoot_timeout():
	can_shoot = true
	if is_player and Input.is_action_pressed("input_a"):
		fire()

func _on_TimerDelay_timeout():
	summon_bullet()
