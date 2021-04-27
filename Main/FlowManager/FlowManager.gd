extends Node

signal spawn_enemies
signal stop_enemies
signal start_dialog
signal summon_boss
signal clear_stuff_from_screen

var curr_wave
var last_score

var curr_wave_info:Wave
var is_wave_active = false
var is_playing_pre_dialog = false
var is_playing_post_dialog = false

var is_setup = false

onready var wave_timer = $WaveTimer

class Wave:
	var duration
	var frequency
	var types
	var pre_dialog
	var pre_auto
	var post_dialog
	var post_auto
	var boss
	var next_wave
	
	func init(duration=30,frequency=2,types=[0],pre_dialog=-1,pre_auto=false,post_dialog=-1,post_auto=false,boss=-1,next_wave=-1):
		self.duration = duration
		self.frequency = frequency
		self.types = types
		self.pre_dialog = pre_dialog
		self.pre_auto = pre_auto
		self.post_dialog = post_dialog
		self.post_auto = post_auto
		self.boss = boss
		self.next_wave = next_wave

var waves = [
]

func setup():
	var wave1 = Wave.new()
	wave1.init(-1,-1,[],0,false,-1,false,-1,1)
	waves.append(wave1)
	
	var wave2 = Wave.new()
	wave2.init(60,2,[0],1,false,-1,false,-1,2)
	waves.append(wave2)
	
	var wave3 = Wave.new()
	wave3.init(-1,-1,[],2,false,3,false,1,-1)
	waves.append(wave3)

func finish_wave():
	is_playing_pre_dialog = false
	is_playing_post_dialog = true
	if curr_wave_info.post_dialog >= 0:
		emit_signal("start_dialog",curr_wave_info,curr_wave_info.post_dialog,curr_wave_info.post_auto)

	else:
		dialog_done()

func start_next_wave():
	if not is_setup:
		setup()
	if curr_wave < len(waves) - 1:
		curr_wave += 1
		start_wave(waves[curr_wave])

func start():
	if not is_setup:
		setup()
	curr_wave = 0
	start_wave(waves[0])

func start_wave(wave_info:Wave):
	curr_wave_info = wave_info
	is_wave_active = true
	is_playing_pre_dialog = true
	is_playing_post_dialog = false
	if curr_wave_info.pre_dialog >= 0:
		emit_signal("start_dialog",curr_wave_info,curr_wave_info.pre_dialog,curr_wave_info.pre_auto)
	else:
		dialog_done()

func _on_WaveTimer_timeout():
	emit_signal("stop_enemies")

func boss_done():
	emit_signal("clear_stuff_from_screen")
	finish_wave()
#	if curr_wave_info.post_dialog >= 0:
#		print("starting post")
#		emit_signal("start_dialog",curr_wave_info,curr_wave_info.post_dialog,curr_wave_info.post_auto)
#
#	else:
#		dialog_done()

func dialog_done():
	if is_playing_pre_dialog:
		is_playing_pre_dialog = false
		if curr_wave_info.types != []:
			emit_signal("spawn_enemies",curr_wave_info)
			if curr_wave_info.duration > 0:
				wave_timer.wait_time = curr_wave_info.duration
				wave_timer.start()
		if curr_wave_info.boss >= 0:
			emit_signal("summon_boss",curr_wave_info.boss)
	elif is_playing_post_dialog:
		if curr_wave_info.next_wave >= 0:
			start_wave(waves[curr_wave_info.next_wave])
	if curr_wave_info.boss < 0 and curr_wave_info.duration < 0:
		if curr_wave_info.next_wave >= 0:
			start_wave(waves[curr_wave_info.next_wave])
		

#Wave number
#Checkpoint score
#
#waves = []
#waveSettings = [duration,dialog=-1,boss=-1,next_wave=-1]
#
#Wave spawner(wave)
#	Start timer
#	Spawn enemies 
#	Timer goes off
#		Stop enemy spawning
#	When no more enemies
#		Trigger dialog
#	When dialog finishes
#		Start next dialog/summon boss
#
#process
#	When boss dies
#		Trigger dialog
#	When dialog finishes
#		fin		
