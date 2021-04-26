tool
extends Control

#Available tags:
#Each left tag has a right counterpart
#	left_char - Set left character ID (-1 is blank)
#	left_frame - Set left character frame
#	talking - -1 = nobody, 0 = left, 1 = right

signal dialog_done

var dialog_id = -1

onready var dialog_label = $DialogContainer/HBoxContainer/Dialog
onready var portrait_left = $Portraits/PortraitLeft
onready var portrait_right = $Portraits/PortraitRight
onready var dialog_timer = $DialogTimer
onready var auto_timer = $AutoTimer

var curr_page = 0
var auto = false
var renamedialog = -1
var is_done = true

#func _display_test_dialog(value):
#	if not Engine.editor_hint: return
#	dialog_label.bbcode_text = parse_tags(value)[1]
#	new_text = value

#func _add_text(value):
#	if not Engine.editor_hint: return
#	dialog.append(new_text)

func start_dialog(id,auto=false):
	clear_dialog()
	dialog_timer.stop()
	auto_timer.stop()
	renamedialog = DialogGroups.get_dialog_by_id(id)
	curr_page = 0
	dialog_id = id
	GameManager.is_dialog_open = true
	is_done = false
	self.auto = auto
	update_dialog()

func clear_dialog():
	dialog_label.bbcode_text = ""
	dialog_timer.stop()
	dialog_label.visible_characters = 0
	dialog_label.percent_visible = 0
	curr_page = 0
	dialog_id = -1
	portrait_left.texture = null
	portrait_right.texture = null
	auto = false
	is_done = true

func _init():
#	GameManager.is_dialog_open = true
	pass

func _ready():
	if Engine.editor_hint:return
	dialog_label.visible_characters = 0
	dialog_label.percent_visible = 0
#	start_dialog(0)

func next_page():
	if is_done or curr_page >= len(renamedialog.get_children())-1:
		return false
	dialog_label.visible_characters = 0
	curr_page += 1
	update_dialog()
	return true

func update_dialog():
	if curr_page >= len(renamedialog.get_children()):
		return
	var curr_dialog = renamedialog.get_child(curr_page)
	dialog_label.bbcode_text = curr_dialog.dialog
	dialog_timer.wait_time = curr_dialog.text_speed
	dialog_timer.start()
	
	var left_id = curr_dialog.left_id
	if left_id == -1:
		portrait_left.texture = null
	else:
		var new_char = Characters.get_character_by_id(left_id)
		if new_char == null:
			print(str("No left character by id ",new_char," was found."))
			return
		set_character(0,new_char)
		set_frame(0,int(curr_dialog.left_frame))
		
	var right_id = curr_dialog.right_id
	if right_id == -1:
		portrait_right.texture = null
	else:
		var new_char = Characters.get_character_by_id(right_id)
		if new_char == null:
			print(str("No right character by id ",new_char," was found."))
			return
		set_character(1,new_char)
		set_frame(1,int(curr_dialog.right_frame))
	
	var talking = curr_dialog.speaking
	var color_see_through = Color(0.5,0.5,0.5,1)
	if talking == -1:
		portrait_left.modulate = color_see_through
		portrait_right.modulate = color_see_through
	elif talking == 0:
		portrait_left.modulate = Color.white
		portrait_right.modulate = color_see_through
	elif talking == 1:
		portrait_left.modulate = color_see_through
		portrait_right.modulate = Color.white
	elif talking == 2:
		portrait_left.modulate = Color.white
		portrait_right.modulate = Color.white

#func parse_tags(value:String):
#	if not (value.find("<") == 0 and "/>" in value):
#		return  [null,value]
#	var index1 = value.find("<")+1
#	var sub_length = value.find("/>")-index1
#	var tag_strings = value.substr(index1,sub_length).split(",")
#	var tags = {}
#	for i in tag_strings:
#		var curr = i.split("=")
#		tags[curr[0]] = curr[1]
#	return [tags,value.substr(value.find("/>")+2)]

#Side 0 is left, side 1 is right.
func set_character(side:int,character_data):
	var portrait
	if side == 0:
		portrait = portrait_left
	elif side == 1:
		portrait = portrait_right
	else: 
		print(str("No proper side passed to set_character(). side was ",side))
		return
	if character_data.frames > 0 and character_data.emotion_atlas != null and character_data.frame_box_size > 0:
		var new_atlas = AtlasTexture.new()
		new_atlas.atlas = character_data.emotion_atlas
		var frame_dimension = character_data.frame_box_size
		new_atlas.region = Rect2(0,0,frame_dimension,frame_dimension)
		portrait.texture = new_atlas
	else:
		print("Can't set texture (DialogBox set_character())")

func set_frame(side:int,frame):
	var portrait
	if side == 0:
		portrait = portrait_left
	elif side == 1:
		portrait = portrait_right
	else: 
		print(str("No proper side passed to set_frame(). side was ",side))
		return
	if portrait.texture == null:
		print("set_frame() texture is null")
		return
	var frame_dimension = portrait.texture.region.size.x
	portrait.texture.region = Rect2(frame_dimension*frame,0,frame_dimension,frame_dimension)

func _on_DialogTimer_timeout():
	if dialog_label.percent_visible < 1:
		dialog_label.visible_characters += 1
		dialog_timer.start()
	elif auto:
		auto_timer.start()

func _on_AutoTimer_timeout():
	dialog_progress()

func dialog_press():
	if dialog_label.percent_visible < 1:
		dialog_label.percent_visible = 1
		dialog_timer.stop()
	else:
		dialog_progress()

func dialog_progress():
	var is_dialog_progressing = next_page()
	if !is_dialog_progressing:
		emit_signal("dialog_done",dialog_id)
		clear_dialog()

func _input(event):
	if not is_done and not auto and GameManager.is_dialog_open and event.is_action("input_a") and not event.is_action_pressed("input_a"):
		dialog_press()
