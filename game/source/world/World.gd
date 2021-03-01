extends Node2D

var data: WorldData = null

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map

var w_name: String = ""

func _ready() -> void:
	if GlobalData.selected_world["is_new"]:
		_create_world_data(GlobalData.selected_world["size"])
		time.change_clock_state()
	else:
		data = GlobalData.selected_world["world"]
		_load_world_data()
		time.change_clock_state()

func _create_world_data(diffic: String) -> void:
	# settings default
	# time default
	w_name = GlobalData.selected_world["name"]
	resources.create_data(diffic)
	map.create_data(diffic)

func _load_world_data() -> void:
	w_name = GlobalData.selected_world["name"]
	settings.load_data(data.settings)
	time.load_data(data.time)
	resources.load_data(data.resources)
	map.load_data(data.map)

func _save_world_data() -> void:
	data.settings = settings.save_data(data.settings)
	data.time = time.save_data(data.time)
	data.resources = resources.save_data(data.resources)
	data.map = map.save_data(data.map)
