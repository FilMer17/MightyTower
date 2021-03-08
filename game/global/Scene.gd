extends Node

var scenes := {
	"TitleScreen" : "res://ui/menu/TitleMenu.tscn",
	"NewGameMenu" : "res://ui/menu/NewGameMenu.tscn",
	"Game" : "res://source/game/Game.tscn"
}

var nodes := {
	"GameCamera" : "/root/Game/GameCamera",
	"Console" : "/root/Game/GameUI/Console",
	"Settings" : "/root/Game/World/Settings",
	"Time" : "/root/Game/World/Time",
	"Resources" : "/root/Game/World/Resources",
	"Map" : "/root/Game/World/Map",
	"Builder" : "/root/Game/World/Map/Builder",
	"Terrain" : "/root/Game/World/Map/Terrain",
	"Entities" : "/root/Game/World/Map/Entities"
}

func change(scene_name: String) -> void:
	if not scenes.has(scene_name):
		print("Scene: cannot change to scene %s" % scene_name)
		return
	
	var __ = get_tree().change_scene(scenes[scene_name])

func search(node_name: String) -> Node:
	if not nodes.has(node_name):
		print("Scene|Node: cannot change to node %s" % node_name)
		return null
	
	return get_node(nodes[node_name])
