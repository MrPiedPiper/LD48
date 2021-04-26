extends "res://Bosses/BaseBoss/BaseBoss.gd"

onready var barrier_sprite = $BarrierArea/Sprite

func set_weapon1_health(value):
	.set_weapon1_health(value)
	if get_weapon1_health() <= 0:
		disable_weapon1()

func set_weapon2_health(value):
	.set_weapon2_health(value)
	if get_weapon2_health() <= 0:
		disable_weapon2()

func disable_barrier():
	.disable_barrier()
	barrier_sprite.hide()

func enable_barrier():
	.enable_barrier()
	barrier_sprite.show()

func ship_destroyed():
	.ship_destroyed()
	$AnimationPlayer.play("Death")
	$CPUParticles2D.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		queue_free()
