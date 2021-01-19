extends Node2D
class_name GameWorld

var settings_data: SettingsData = null
var resources_data: ResourcesData = null
var map_data: MapData = null

func _ready() -> void:
	_load_data()
	_load_terrain()


func _load_data() -> void:
#	settings_data = 
#	resources_data = 
#	map_data = 
	pass

func _load_terrain() -> void:
	pass
