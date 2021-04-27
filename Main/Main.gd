extends Node2D

var score = 0 setget set_score
var is_stopping = false

onready var scoreLabel = $GUI/ScoreLabel
onready var enemy_spawner = $EnemySpawner
onready var flow_manager = $FlowManager

export var menu_template = preload("res://Menu.tscn")
var curr_menu = null

# Check if ESC is being pressed
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		open_menu()
	
# Instance an enemy variable from Enemy scene and add it as a child to the current scene
# To prevent opening multiple menus, set a bool to true
func open_menu():
	curr_menu = menu_template.instance()
	curr_menu.connect("unpause",self,"_on_menu_unpause")
	var main = get_tree().current_scene
	$GUI.add_child(curr_menu)
	get_tree().paused = true

func _on_menu_unpause():
	pass

func set_score(value):
	score = value
	GameManager.score = score
	scoreLabel.text = "Score = " + str(score)

func _process(delta):
	var enemies = get_tree().get_nodes_in_group("Enemy")
	var enemy_bullets = get_tree().get_nodes_in_group("EnemyBullet")
	if is_stopping and len(enemies) == 0 and len(enemy_bullets) == 0:
		is_stopping = false
		flow_manager.finish_wave()

func _on_DialogBox_dialog_done(id):
	flow_manager.dialog_done()

func summon_boss(id):
	if id == 1:
		var boss_scene = load("res://Bosses/Boss1/Boss1.tscn")
		var curr_boss = boss_scene.instance()
		curr_boss.connect("boss_defeated",self,"_on_Boss1_boss_defeated")
		curr_boss.global_position = Vector2(270,68)
		print("pos set")
		add_child(curr_boss)

func _ready():
	flow_manager.start()

#on boss defeated trigger FlowManager to progress, kill all enemy grunts, and all enemy bullets.

func _on_FlowManager_spawn_enemies(wave_info):
	enemy_spawner.start(wave_info.frequency,wave_info.types)

func _on_FlowManager_stop_enemies():
	enemy_spawner.stop()
	is_stopping = true

func _on_Boss1_boss_defeated():
	clear_screen()
	flow_manager.boss_done()

func clear_screen():
	for i in get_tree().get_nodes_in_group("Grunt"):
		if i.is_in_group("Enemy"):
			i.queue_free()
	for i in get_tree().get_nodes_in_group("Bullet"):
		i.queue_free()

func _on_FlowManager_start_dialog(wave_info,dialog_id,is_auto):
	$GUI/DialogBox.start_dialog(dialog_id,is_auto)

func _on_FlowManager_summon_boss(id):
	summon_boss(id)

func _on_FlowManager_clear_stuff_from_screen():
	clear_screen()
