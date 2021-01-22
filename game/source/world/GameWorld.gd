extends Node2D
class_name GameWorld

var settings_data: SettingsData = null
var resources_data: ResourcesData = null
var map_data: MapData = null
var building_data: BuildingData = null

onready var sel_world = Global.selected_world
onready var terrain = $Terrain

func _ready() -> void:
	_load_data()
	_load_terrain()
	# load all data later


func _load_data() -> void:
	settings_data = sel_world.settings_data
	resources_data = sel_world.resources_data
	map_data = sel_world.map_data
	building_data = sel_world.building_data
	pass

func _load_terrain() -> void:
	for vector in map_data.terrain.keys():
		terrain.set_cellv(vector, map_data.terrain[vector].terrain)
