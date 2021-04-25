extends Area2D

export(int) var SPEED = 30
export(int) var ARMOR = 2

onready var animationPlayer = $AnimationPlayer

# Make the alien move left
func _process(delta):
	position.x -= SPEED * delta
	animationPlayer.play("Move")

# When the enemy enters a body, delete the body and take damage on the Enemy's armor
# If the Enemy's armor is less than 0, delete the enemy.
# Update the score
func _on_PinkAlien_area_entered(area):
	area.queue_free()
	ARMOR -= 1
	if ARMOR <= 0:
		var main = get_tree().current_scene
		if main.is_in_group("World"):
			main.score += 20
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# When the node exits the scene tree, activate explosion animation
func _exit_tree():
	# get the current scene tree
	var main = get_tree().current_scene
	# instance the explosionEffect as a variable
	#var explosionEffect = ExplosionEffect.instance()
	# add the explosionEffect to the scene tree
	#main.add_child(explosionEffect)
	# set the explosionEffect to the global position
	#explosionEffect.global_position = global_position
