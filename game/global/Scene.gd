extends Node

var scenes := {
	"TitleScreen" : "res://"
}

func change(scene_name: String) -> void:
	if not scenes.has(scene_name):
		print("cannot change to scene %s" % scene_name)
		return
	
	var __ = get_tree().change_scene(scenes[scene_name])
