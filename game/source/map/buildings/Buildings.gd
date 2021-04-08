extends YSort

# warning-ignore:unused_signal
signal make_entities
# warning-ignore:unused_signal
signal find_workers

onready var resources := Scene.search("Resources")

var data: Dictionary = {}
var states: Dictionary = {}

func _ready() -> void:
	var __
	__ = connect("make_entities", self, "_on_Make_entities")
	__ = connect("find_workers", self, "_on_Find_workers")

func place_building(building: Building, pos: Vector2) -> bool:
	if _pay_building_cost(building):
		building.position = pos
		
		data[building.position] = {
			"name" : building.node_name,
			"is_built" : false
		}
		
		add_child(building)
		
		var group_name
		for key in building.TYPE.keys():
			if building.TYPE[key] == building.type:
				group_name = key
				building.add_to_group(group_name)
				return true
	
	return false

func load_buildings(b_data: Dictionary, buildings_state: Dictionary) -> void:
	data = b_data
	states = buildings_state
	
	for building_pos in data:
		var loaded_building = GlobalData.buildings[data[building_pos].name].instance()
		loaded_building.position = building_pos
		loaded_building.is_loaded = true
		loaded_building.is_built = data[building_pos].is_built
		add_child(loaded_building)
		
		var group_name
		for key in loaded_building.TYPE.keys():
			if loaded_building.TYPE[key] == loaded_building.type:
				group_name = key
				loaded_building.add_to_group(group_name)

func _on_Find_workers() -> void:
	for group_building in get_tree().get_nodes_in_group("worker"):
		group_building.find_worker()
	
	for group_building in get_tree().get_nodes_in_group("tower"):
		group_building.find_worker()

func _pay_building_cost(building) -> bool:
	var mater = resources.material
	var output = "Cost "
	
	if get_child_count() <= 0:
		Scene.search("BuilderOverview").hide_data()
		Scene.search("Game").get_node("GameShader").visible = true
		return true
	
	for key in building.cost:
		if mater[key] - building.cost[key] >= 0:
			resources.add_resource("material", -building.cost[key], key)
			output += String(building.cost[key]) + "|" + key + " "
		else:
			print("Not enough resources!")
			Scene.search("Console").write("Not enough resources")
			return false
	print(output + "was paid")
	Scene.search("Console").write(output + "was paid")
	return true

func _on_Make_entities() -> void:
	for child in get_tree().get_nodes_in_group("maker"):
		child.emit_signal("make_entity")
