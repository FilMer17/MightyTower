extends Node2D

var data: WorldData = null

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map

func _ready() -> void:
	_create_world_data("S")
	
#	if GlobalData.selected_world["is_new"]:
#		pass
#	else:
#		data = GlobalData.selected_world["world"]
#		_load_world_data()

func _create_world_data(diffic: String) -> void:
	# settings default
	# time default
	resources.create_data(diffic)
	map.create_data(diffic)

func _load_world_data() -> void:
	settings.load_data(data.settings)
	time.load_data(data.time)
	resources.load_data(data.resources)
	map.load_data(data.map)
	
	data.name = GlobalData.selected_world["name"]

func _save_world_data() -> void:
	data.settings = settings.save_data(data.settings)
	data.time = time.save_data(data.time)
	data.resources = resources.save_data(data.resources)
	data.map = map.save_data(data.map)
