extends Node

var world_is_new: bool = true

var world_data: WorldData = WorldData.new()
var states_data: StatesData = StatesData.new()
var buildings_data: Dictionary = {}
var entities_data: Dictionary = {}
var terrain_data: Dictionary = {}

var worlds: Array = []
var buildings: Dictionary = {}
var entities: Dictionary = {}

func _ready() -> void:
	scan()
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	var dir = Directory.new()
	if not dir.open("user://worlds") == OK:
		dir.open("user://")
		dir.make_dir("worlds")

func _input(event) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func scan() -> void:
	load_worlds()
	_load_buildings()
	_load_entities()

func load_worlds() -> void:
	worlds.clear()
	
#	for file_data in FileSystem.load_dir("user://worlds", ["save", "data"], false):
#		worlds[file_data.id] = file_data.data
	
	var dir = Directory.new()
	dir.open("user://worlds")
	var __ = dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			worlds.append(file)

func _load_buildings() -> void:
	buildings.clear()
	
	for file_data in FileSystem.load_dir("res://data/buildings", ["tscn", "scn"]):
		buildings[file_data.data.instance().name] = file_data.data

func _load_entities() -> void:
	entities.clear()
	
	for file_data in FileSystem.load_dir("res://data/entities", ["tscn", "scn"]):
		entities[file_data.data.instance().name] = file_data.data
