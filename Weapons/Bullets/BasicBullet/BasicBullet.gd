extends "res://Weapons/Bullets/BaseBullet/BaseBullet.gd"

func _on_BaseBullet_area_entered(area):
	if not is_in_group("EnemyBullet") and area.is_in_group("Enemy"):
		queue_free()
	elif not is_in_group("PlayerBullet") and area.is_in_group("Player"):
		queue_free()
