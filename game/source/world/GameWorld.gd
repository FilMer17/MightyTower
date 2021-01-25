extends Node2D

export var alias: String = ""

onready var settings := $Settings
onready var resources := $Resources
onready var build_grid := $BuilderGrid
onready var map := $MapContainer/Map
onready var buildings := $BuildingContainer/Buildings

var sel_world: Dictionary = {}
var world_data: Dictionary = {}
var path := "user://worlds/"

func _ready() -> void:
	_load_game_data()

func _load_game_data() -> void:
	sel_world = Global.selected_world
	alias = sel_world.keys()[0] 

	if sel_world[alias]:
		create_map()
	else:
#		path += alias + ".save"
#		world_data = Data.load_data(path)

#		settings.data = world_data["settings"]
#		resources.data = world_data["resources"]
#		map.data = world_data["map"]
#		buildings.data = world_data["buildings"]
		pass

func create_map() -> void:
	var size = sel_world["map_size"]
	map.create_terrain(size)
