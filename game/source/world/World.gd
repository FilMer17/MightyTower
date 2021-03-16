extends Node2D

# warning-ignore:unused_signal
signal find_person
# warning-ignore:unused_signal
signal feed_people
# warning-ignore:unused_signal
signal no_people

onready var console := Scene.search("Console")

var data: WorldData = null

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map

var w_name: String = ""

func _ready() -> void:
	var __
	__ = connect("find_person", self, "_on_Find_person")
	__ = connect("feed_people", self, "_on_Feed_people")
	__ = connect("no_people", self, "_on_No_people")
	
	if GlobalData.selected_world["is_new"]:
		_create_world_data(GlobalData.selected_world["size"])
		time.change_clock_state()
		data = WorldData.new()
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

func save_world_data() -> void:
	data = WorldData.new()
	data.settings = settings.save_data()
	data.time = time.save_data()
	data.resources = resources.save_data()
	data.buildings = map.save_data("buildings")
	data.entities = map.save_data("entities")
	data.terrain = map.save_data("terrain")

func _on_Find_person() -> void:
	if not resources.max_amount["people"] <= resources.get_all_people():
		if not resources.hungry_people:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rnum = rng.randi_range(1, 2)
			
			if rnum == 1:
				resources.add_resource("people", 1, "idle")
				print("idle person added")
				console.write("idle person added")
			else:
				print("nobody was added")

func _on_Feed_people() -> void:
	var need_food := 0
	for key in resources.people.keys():
		match key:
			"idle":
				need_food += resources.people[key] * 1
			"employed":
				need_food += resources.people[key] * 2
			"busy":
				need_food += resources.people[key] * 3
	
	if need_food == 0:
		return
	
	if need_food > resources.food:
		console.write("Not enough food")
		resources.hungry_people = true
	else:
		resources.add_resource("food", -need_food)
		console.write("People are fed")
		resources.hungry_people = false
