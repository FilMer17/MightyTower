extends Node2D

# warning-ignore:unused_signal
signal find_person
# warning-ignore:unused_signal
signal feed_people
# warning-ignore:unused_signal
signal hungry_people

onready var console := Scene.search("Console")
onready var time_overview := Scene.search("TimeOverview")

onready var settings = $Settings
onready var time = $Time
onready var resources = $Resources
onready var map = $Map

var w_name: String = ""

func _ready() -> void:
	var __
	__ = connect("find_person", self, "_on_Find_person")
	__ = connect("feed_people", self, "_on_Feed_people")
	__ = connect("hungry_people", self, "_on_Hungry_people")
	
	if GlobalData.world_is_new:
		_create_world_data(GlobalData.world_data.world_size)
		save_world_data()
	else:
		_load_world_data()
	
	time.change_clock_state()

func _input(event):
	if event.is_action_pressed("save_game"):
		save_world_data()

func save_world_data() -> void:
	var w_data = GlobalData.world_data
	w_data.settings = settings.save_data()
	w_data.time = time.save_data()
	w_data.resources = resources.save_data()
	
	var b_data = Scene.search("Buildings").data
	GlobalData.buildings_data = b_data
	
	var e_data: Dictionary = Scene.search("Entities").data
	GlobalData.entities_data = e_data
	
	var t_data: Dictionary = Scene.search("Terrain").data
	GlobalData.terrain_data = t_data
	
	var s_data = GlobalData.states_data
	s_data.entities_state = Scene.search("Entities").states
	s_data.buildings_state = Scene.search("Buildings").states
	
	FileSystem.save_world(w_data, "worlddata", true)
	FileSystem.save_world(b_data, "buildings")
	FileSystem.save_world(e_data, "entities")
	FileSystem.save_world(t_data, "terrain")
	FileSystem.save_world(s_data, "states", true)

func _create_world_data(size: String, diffic: String = "") -> void:
	# settings default
	# time default
	resources.create_data(diffic)
	map.create_data(size)

func _load_world_data() -> void:
	settings.load_data(GlobalData.world_data.settings)
	time.load_data(GlobalData.world_data.time)
	resources.load_data(GlobalData.world_data.resources)
	
	map.load_data()

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
		else:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var rnum = rng.randi_range(1, 2)
			
			if rnum == 1:
				resources.add_resource("people", 1, "idle")
				print("idle person added")
				console.write("idle person added")
			else:
				print("nobody was removed")

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
		resources.add_resource("food", -resources.food)
		console.write("Not enough food")
		resources.hungry_people = true
	else:
		resources.add_resource("food", -need_food)
		console.write("People are fed")
		resources.hungry_people = false

func _on_Hungry_people() -> void:
	if resources.hungry_people:
		time_overview.happiness_change(-3)
	else:
		time_overview.happiness_change(1)
