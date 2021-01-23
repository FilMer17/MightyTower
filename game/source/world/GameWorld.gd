extends Node2D
class_name GameWorld

#var settings_data: SettingsData = null
#var resources_data: ResourcesData = null

var map_data: MapData = null

onready var glob_sel_world = Global.selected_world

onready var settings := $Settings
onready var resources := $Resources
onready var map_cont := $MapContainer
onready var buildings_cont := $BuildingsContainer

onready var terrain = $MapContainer/Terrain

func _ready() -> void:
	_load_data()
	_load_terrain()
	# load all data later


func _load_data() -> void:
	settings.data = glob_sel_world.settings_data
	resources.data = glob_sel_world.resources_data
	map_data = glob_sel_world.map_data


func _load_terrain() -> void:
	for vector in map_data.terrain.keys():
		terrain.set_cellv(vector, map_data.terrain[vector].terrain)
