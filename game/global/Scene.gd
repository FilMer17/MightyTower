extends Node

var scenes := {
	"TitleScreen" : "res://ui/menu/TitleMenu.tscn",
	"Game" : "res://source/game/Game.tscn"
}

func change(scene_name: String) -> void:
	if not scenes.has(scene_name):
		print("Scene: cannot change to scene %s" % scene_name)
		return
	
	var __ = get_tree().change_scene(scenes[scene_name])
