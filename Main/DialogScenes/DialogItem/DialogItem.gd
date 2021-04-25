extends Node

export(String,MULTILINE) var dialog
export(int,"None","Left","Right") var speaking = 0
export(Characters.CharacterIds) var left_id = -1
export(Characters.FrameIds) var left_frame
export(Characters.CharacterIds) var right_id = -1
export(Characters.FrameIds) var right_frame
