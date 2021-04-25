tool
extends Control

#Available tags:
#Each left tag has a right counterpart
#	left_char - Set left character ID (-1 is blank)
#	left_frame - Set left character frame
#	talking - -1 = nobody, 0 = left, 1 = right

signal dialog_done

var _text_storage
export(String,MULTILINE) var new_text setget _display_test_dialog
export(bool) var add_label_contents setget _add_text
export(Array,String,MULTILINE) var dialog

onready var dialog_label = $DialogContainer/Dialog
onready var portrait_left = $Portraits/PortraitLeft
onready var portrait_right = $Portraits/PortraitRight
onready var dialog_timer = $DialogTimer

var curr_page = 0
var char_left = -1
var char_right = -1

func _display_test_dialog(value):
	if not Engine.editor_hint: return
	dialog_label.bbcode_text = parse_tags(value)[1]
	new_text = value

func _add_text(value):
	if not Engine.editor_hint: return
	dialog.append(new_text)

func _init():
	GameManager.is_dialog_open = true

func _ready():
	if Engine.editor_hint:return
	dialog_label.visible_characters = 0
	dialog_label.percent_visible = 0
	dialog_timer.start()
	update_dialog()

func next_page():
	if curr_page >= len(dialog)-1:
		return false
	dialog_label.visible_characters = 0
	curr_page += 1
	dialog_timer.start()
	update_dialog()
	return true

func update_dialog():
	if curr_page < 0 or curr_page >= len(dialog):
		print("Dialog page out of range")
		return
	var parsed_text = parse_tags(dialog[curr_page])
	var tags = parsed_text[0]
	var text = parsed_text[1]
	dialog_label.bbcode_text = text
	
	if tags == null:
		return
	if "left_char" in tags:
		var char_id = int(tags["left_char"])
		if char_id == -1:
			portrait_left.texture = null
		else:
			var new_char = Characters.get_character_by_id(char_id)
			if new_char == null:
				print(str("No character by id ",new_char," was found."))
				return
			set_character(0,new_char)
		
	if "right_char" in tags:
		var char_id = int(tags["right_char"])
		if char_id == -1:
			portrait_right.texture = null
		else:
			var new_char = Characters.get_character_by_id(char_id)
			if new_char == null:
				print(str("No character by id ",new_char," was found."))
				return
			set_character(1,new_char)
	
	if "left_frame" in tags:
		if portrait_left.texture == null:
			print("Can't set left frame, left has no texture")
			return
		set_frame(0,int(tags["left_frame"]))
	
	if "right_frame" in tags:
		if portrait_right.texture == null:
			print("Can't set right frame, right has no texture")
			return
		set_frame(1,int(tags["right_frame"]))
	
	if "talking" in tags:
		var talking = int(tags["talking"])
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

func parse_tags(value:String):
	if not (value.find("<") == 0 and "/>" in value):
		return  [null,value]
	var index1 = value.find("<")+1
	var sub_length = value.find("/>")-index1
	var tag_strings = value.substr(index1,sub_length).split(",")
	var tags = {}
	for i in tag_strings:
		var curr = i.split("=")
		tags[curr[0]] = curr[1]
	return [tags,value.substr(value.find("/>")+2)]

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

func _input(event):
	if GameManager.is_dialog_open and event.is_action("input_a") and not event.is_action_pressed("input_a"):
		if dialog_label.percent_visible < 1:
			dialog_label.percent_visible = 1
			dialog_timer.stop()
		else:
			var is_dialog_progressing = next_page()
			if not is_dialog_progressing:
				emit_signal("dialog_done")
