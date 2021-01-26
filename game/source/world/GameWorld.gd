extends Node2D

export var alias: String = ""
export var world_data: Dictionary = {}

onready var settings := $Settings
onready var time := $Time
onready var resources := $Resources
onready var build_grid := $BuilderGrid
onready var map := $MapContainer/Map
onready var buildings := $BuildingContainer/Buildings

var sel_world: Dictionary = {}
var path := "user://worlds/"
var data: Dictionary = {}

func _ready() -> void:
	_load_game_data()

func save_data() -> Dictionary:
	data = {
		"alias" : alias,
		"settings" : settings.save_data(),
		"resources" : resources.save_data(),
		"map" : map.save_data()
	}
	
	return data

func _save_data_to_file() -> void:
	world_data = save_data()
	
	Data.save_dict_data(path, world_data)

func _load_game_data() -> void:
	sel_world = Global.selected_world
	alias = sel_world.keys()[0]
	path += alias + ".save"
	
	if sel_world[alias]:
		var size = sel_world["map_size"]
		settings.create()
		resources.create()
		map.create(size)
		# timer is set to default
		
		_save_data_to_file()
		pass
	else:
		world_data = Data.load_dict_data(path)
		
		settings.load_data(world_data["settings"])
		resources.load_data(world_data["resources"])
		map.load_data(world_data["map"])
		time.load_data(world_data["time"])
