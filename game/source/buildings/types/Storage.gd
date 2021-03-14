tool
extends Building
class_name Storage

enum USAGE { food, material, ore }

export var capacity: int = 0
export(USAGE) var usage: int = USAGE.food

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Usage" : USAGE.keys()[usage],
		"Capacity" : capacity
	}
	building_overview.update_info(infos)
