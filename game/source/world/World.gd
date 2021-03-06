extends Node2D

# warning-ignore:unused_signal
signal find_person

var data: WorldData = null

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map

var w_name: String = ""

func _ready() -> void:
	var __ = connect("find_person", self, "_on_Find_person")
	if GlobalData.selected_world["is_new"]:
		_create_world_data(GlobalData.selected_world["size"])
		time.change_clock_state()
		data = WorldData.new()
	else:
		data = GlobalData.selected_world["world"]
		_load_world_data()
		time.change_clock_state()

func _on_Find_person() -> void:
	if not resources.max_amount["people"] <= resources.get_all_people():
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var rnum = rng.randi_range(1, 2)
		
		if rnum == 1:
			resources.add_resource("people", 1, "idle")
			print("idle person added")
		else:
			print("nobody was added")

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
	data.settings = settings.save_data()
	data.time = time.save_data()
	data.resources = resources.save_data()
	data.map = map.save_data()
