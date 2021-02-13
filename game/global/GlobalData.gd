extends Node

var selected_world: Dictionary = {
	"is_new" : true,
	"name" : "world1",
	"world" : WorldData.new()
}

var worlds: Dictionary = {}
var buildings: Dictionary = {}
var entities: Dictionary = {}

func _ready() -> void:
	scan()


func scan() -> void:
	_load_worlds()
	_load_buildings()
	_load_entities()


func _load_worlds() -> void:
	worlds.clear()
	
	for file_data in FileSystem.load_dir("user://worlds", ["save", "data"], false):
		worlds[file_data.id] = file_data.data


func _load_buildings() -> void:
	buildings.clear()
	
	for file_data in FileSystem.load_dir("res://data/buildings", ["tscn", "scn"]):
		buildings[file_data.data.instance().name] = file_data.data


func _load_entities() -> void:
	entities.clear()
