extends Node2D

onready var resources := get_parent().get_parent().get_node("Resources")

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

	building = null	
	return false

func _pay_building_cost() -> bool:
	var mater = resources.material
	var output = "Cost "
	for key in building.cost:
		if mater[key] - building.cost[key] >= 0:
			mater[key] -= building.cost[key]
			output += String(building.cost[key]) + "|" + key + " "
		else:
			print("Not enough resources!")
			return false
	print(output + "was paid")
	return true
