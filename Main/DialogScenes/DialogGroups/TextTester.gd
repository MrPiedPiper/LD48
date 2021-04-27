tool
extends Node

enum Sides {
	NONE = -1,
	LEFT = 0,
	RIGHT = 1,
	BOTH = 2,
}

export(PackedScene) var chars
var localChars
export(PackedScene) var dialog_item_template

export(int) var add_to_id = -1
export(bool) var create_dialog setget create_dialog

export(String,MULTILINE) var dialog setget update_label
export(Sides) var speaking = -1 setget update_speaking
export(Characters.CharacterIds) var left_id = -1 setget update_left_id
export(Characters.FrameIds) var left_frame setget update_left_frame
export(Characters.CharacterIds) var right_id = -1 setget update_right_id
export(Characters.FrameIds) var right_frame setget update_right_frame
export(float) var text_speed = 0.125

export(bool) var play_example setget play_example

onready var dialog_label = $DialogBox/DialogContainer/Dialog
onready var portrait_left = $DialogBox/Portraits/PortraitLeft
onready var portrait_right = $DialogBox/Portraits/PortraitRight
onready var dialog_timer = $DialogBox/DialogTimer

func _ready():
	if not Engine.editor_hint:
		print("hiding")
		$DialogBox.hide()
	else:
		localChars = chars.instance()

func create_dialog(value):
	if not Engine.editor_hint:return
	if add_to_id == -1:
		return
	#Create a new DialogItem
	var new_item = dialog_item_template.instance()
	#Assign values
	new_item.dialog = dialog
	new_item.speaking = speaking
	new_item.left_id = left_id
	new_item.left_frame = left_frame
	new_item.right_id = right_id
	new_item.right_frame = right_frame
	new_item.text_speed = text_speed
	#Add to Dialog with ID
	var parent_dialog = null
	for i in get_node("../../Dialogs").get_children():
		if i.id == add_to_id:
			print(i.name)
			i.add_child(new_item)
			#Thanks Zylann (https://godotengine.org/qa/9618/in-tool-mode-is-there-a-way-to-add-new-nodes)
			new_item.set_owner(get_tree().get_edited_scene_root())
			print("added child")
			break

func update_label(value):
	if not Engine.editor_hint:return
	dialog_label.bbcode_text = value
	dialog = value

func update_speaking(value):
	if not Engine.editor_hint:return
	var color_see_through = Color(0.5,0.5,0.5,1)
	if value == Sides.NONE:
		portrait_left.modulate = color_see_through
		portrait_right.modulate = color_see_through
	elif value == Sides.LEFT:
		portrait_left.modulate = Color.white
		portrait_right.modulate = color_see_through
	elif value == Sides.RIGHT:
		portrait_left.modulate = color_see_through
		portrait_right.modulate = Color.white
	elif value == Sides.BOTH:
		portrait_left.modulate = Color.white
		portrait_right.modulate = Color.white
	speaking = value

func update_left_id(value):
	if not Engine.editor_hint:return
	if value == -1:
		portrait_left.texture = null
	else:
		set_character(0,get_character_by_id(value))
	left_id = value

func update_right_id(value):
	if not Engine.editor_hint:return
	if value == -1:
		portrait_right.texture = null
	else:
		set_character(1,get_character_by_id(value))
	right_id = value

func get_character_by_id(id):
	if not Engine.editor_hint:return
	for i in localChars.get_children():
		if i.id == id:
			return i
	return null

func update_left_frame(value):
	if not Engine.editor_hint:return
	set_frame(0,value)
	left_frame = value

func update_right_frame(value):
	if not Engine.editor_hint:return
	set_frame(1,value)
	right_frame = value

func play_example(value):
	if not Engine.editor_hint:return
	if value == true:
		dialog_timer.wait_time = text_speed
		dialog_label.percent_visible = 0
		dialog_label.visible_characters = 0
		dialog_timer.start()
	else:
		dialog_label.percent_visible = 1
		dialog_timer.stop()
	play_example = value 

func set_character(side:int,character_data):
	if not Engine.editor_hint:return
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
		print("Can't set texture (DialogGroups TextTester set_character())")

func set_frame(side:int,frame):
	if not Engine.editor_hint:return
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
	if not Engine.editor_hint:return
	if dialog_label.percent_visible < 1:
		dialog_label.visible_characters += 1
		dialog_timer.start()
