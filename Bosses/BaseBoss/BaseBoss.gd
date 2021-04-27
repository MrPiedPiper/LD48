extends Node2D

signal boss_defeated

var phase = 1
var _is_waiting = true

onready var weak_spot = $PosNode/WeakSpot
onready var weak_spot_hurt_animation_player = $PosNode/WeakSpot/WeakSpotHurtAnimationPlayer
var weak_spot_health = 10

onready var weapon1 = $PosNode/Weapon1Area/Weapon1
onready var weapon1_timer = $PosNode/Weapon1Timer
onready var weapon1_area = $PosNode/Weapon1Area
onready var weapon1_offset_timer = $PosNode/Weapon1OffsetTimer
onready var weapon1_hurt_animation_player = $PosNode/Weapon1Area/Weapon1HurtAnimationPlayer
var weapon1_health = 10

onready var weapon2 = $PosNode/Weapon2Area/Weapon2
onready var weapon2_timer = $PosNode/Weapon2Timer
onready var weapon2_area = $PosNode/Weapon2Area
onready var weapon2_offset_timer = $PosNode/Weapon2OffsetTimer
onready var weapon2_hurt_animation_player = $PosNode/Weapon2Area/Weapon2HurtAnimationPlayer
var weapon2_health = 10

onready var barrier_area = $PosNode/BarrierArea
onready var barrier_hurt_animation_player = $PosNode/BarrierArea/BarrierHurtAnimationPlayer

func disable_barrier_if_weaponless():
	if get_weapon1_health() <= 0 and get_weapon2_health() <= 0:
		disable_barrier()

func disable_weapon1():
	weapon1_timer.stop()
	weapon1_area.visible = false
	for i in weapon1_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",true)
	disable_barrier_if_weaponless()

func enable_weapon1():
	weapon1_timer.start()
	weapon1_area.visible = true
	for i in weapon1_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",false)

func disable_weapon2():
	weapon2_timer.stop()
	weapon2_area.visible = false
	for i in weapon2_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",true)
	disable_barrier_if_weaponless()

func enable_weapon2():
	weapon2_timer.start()
	weapon2_area.visible = true
	for i in weapon2_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",false)

func disable_barrier():
	for i in barrier_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",true)

func enable_barrier():
	for i in barrier_area.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",false)

func disable_weak_spot():
	for i in weak_spot.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",true)

func enable_weak_spot():
	for i in weak_spot.get_children():
		if i is CollisionShape2D:
			i.set_deferred("disabled",false)

func start():
	_is_waiting = false
	weapon1_timer.start()
	weapon2_timer.start()

func set_wait(value):
	_is_waiting = value

func set_weak_spot_health(value):
	if value <= 0:
		disable_weak_spot()
		ship_destroyed()
	weak_spot_health = value

func ship_destroyed():
	pass

func get_weak_spot_health():
	return weak_spot_health

func set_weapon1_health(value):
	if value <= 0:
		weapon1_timer.stop()
	weapon1_health = value

func get_weapon1_health():
	return weapon1_health

func set_weapon2_health(value):
	if value <= 0:
		weapon2_timer.stop()
	weapon2_health = value

func get_weapon2_health():
	return weapon2_health

func start_next_phase():
	phase += 1

func _on_Weapon1Timer_timeout():
	if weapon1_health <= 0:
		weapon1_timer.stop()
		return
	if not _is_waiting:
		weapon1.fire()

func _on_Weapon2Timer_timeout():
	if weapon2_health <= 0:
		weapon2_timer.stop()
		return
	if not _is_waiting:
		weapon2.fire()

func _on_Weapon1Area_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		weapon1_hurt_animation_player.play("HurtFlash")
		set_weapon1_health(get_weapon1_health()-1)

func _on_Weapon2Area_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		weapon2_hurt_animation_player.play("HurtFlash")
		set_weapon2_health(get_weapon2_health()-1)

func _on_WeakSpot_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		weak_spot_hurt_animation_player.play("HurtFlash")
		set_weak_spot_health(get_weak_spot_health()-1)
