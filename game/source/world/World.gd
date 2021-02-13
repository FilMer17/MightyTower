extends Node2D

var data: WorldData = null

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map
onready var res_w_data := get_tree().get_nodes_in_group("res_world_data")

func _ready() -> void:
	if GlobalData.selected_world["is_new"]:
		pass
	else:
		data = GlobalData.selected_world["world"]
		_load_world_data()

func _load_world_data() -> void:
	settings.load_data(data.settings)
	time.load_data(data.time)
	resources.load_data(data.resources)
	map.load_data(data.map)
	
	data.name = GlobalData.selected_world["name"]

func _save_world_data() -> void:
	for w_data in res_w_data:
		w_data.save_data()
