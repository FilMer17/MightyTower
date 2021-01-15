extends Node

var scenes := {
	"TitleScreen" : "res://source/menu/TitleScreen.tscn"
}

func change(scene_name: String) -> void:
	if not scenes.has(scene_name):
		# log here
		print("*ERROR* - [" + scene_name + "] not find")
		return
	
# warning-ignore:return_value_discarded
	get_tree().change_scene(scenes[scene_name])
	# log here
	print("Scene changed to [" + scene_name + "]")
