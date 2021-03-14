extends YSort

onready var resources := Scene.search("Resources")

var building: Building = null

func place_building(to_build: String, pos: Vector2) -> bool:
	building = GlobalData.buildings[to_build].instance()
	
	if _pay_building_cost():
		building.position = pos
		add_child(building)
		
		var group_name
		for key in building.TYPE.keys():
			if building.TYPE[key] == building.type:
				group_name = key
				building.add_to_group(group_name)
				return true
	
	building.queue_free()
	building = null
	return false

func find_workers() -> void:
	for group_building in get_tree().get_nodes_in_group("worker"):
		group_building.find_worker()

func save_data() -> Array:
	var data := []
	for child in get_children():
		data.append(child)
	return data

func _pay_building_cost() -> bool:
	var mater = resources.material
	var output = "Cost "
	
	if get_child_count() <= 0:
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
