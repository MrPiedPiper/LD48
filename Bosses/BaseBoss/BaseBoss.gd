extends Node2D

var phase = 1
var _is_waiting = true

onready var weak_spot = $WeakSpot

onready var weapon1 = $Weapon1Area/Weapon1
onready var weapon1_timer = $Weapon1Timer
onready var weapon1_area = $Weapon1Area
onready var weapon1_offset_timer = $Weapon1OffsetTimer
var weapon1_health = 10

onready var weapon2 = $Weapon2Area/Weapon2
onready var weapon2_timer = $Weapon2Timer
onready var weapon2_area = $Weapon2Area
onready var weapon2_offset_timer = $Weapon2OffsetTimer
var weapon2_health = 10

onready var barrier_area = $BarrierArea

func disable_barrier_if_weaponless():
	if get_weapon1_health() <= 0 and get_weapon2_health() <= 0:
		disable_barrier()

func disable_weapon1():
	weapon1_timer.stop()
	weapon1_area.visible = false
	for i in weapon1_area.get_children():
		if i is CollisionShape2D:
			i.disabled = true
	disable_barrier_if_weaponless()

func enable_weapon1():
	weapon1_timer.start()
	weapon1_area.visible = true
	for i in weapon1_area.get_children():
		if i is CollisionShape2D:
			i.disabled = false

func disable_weapon2():
	weapon2_timer.stop()
	weapon2_area.visible = false
	for i in weapon2_area.get_children():
		if i is CollisionShape2D:
			i.disabled = true
	disable_barrier_if_weaponless()

func enable_weapon2():
	weapon2_timer.start()
	weapon2_area.visible = true
	for i in weapon2_area.get_children():
		if i is CollisionShape2D:
			i.disabled = false

func disable_barrier():
	for i in barrier_area.get_children():
		if i is CollisionShape2D:
			i.disabled = true

func enable_barrier():
	for i in barrier_area.get_children():
		if i is CollisionShape2D:
			i.disabled = false

func _ready():
	start()

func start():
	_is_waiting = false
	weapon1_timer.start()
	weapon2_timer.start()
		

func set_wait(value):
	_is_waiting = value

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
		set_weapon1_health(get_weapon1_health()-1)

func _on_Weapon2Area_area_entered(area):
	if area.is_in_group("PlayerBullet"):
		set_weapon2_health(get_weapon2_health()-1)

