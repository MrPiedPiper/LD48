extends Node2D

export var bullet = preload("res://Weapons/BaseBullet/BaseBullet.tscn")
export var shoot_delay = 0.5
export var is_player = true

var can_shoot = true
onready var timer = $TimerShoot

#On press summon shot and assign group
func fire():
	if can_shoot:
		#fire
		var curr_bullet = bullet.instance()
		if is_player:
			curr_bullet.add_to_group("PlayerBullet")
		else:
			curr_bullet.add_to_group("EnemyBullet")
		curr_bullet.position = get_parent().position
		get_tree().current_scene.add_child(curr_bullet)
		can_shoot = false
		timer.start()

func _on_TimerShoot_timeout():
	can_shoot = true
	if Input.is_action_pressed("input_a"):
		fire()
