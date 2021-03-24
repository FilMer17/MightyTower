tool
extends Building
class_name Storage

enum USAGE { food, material, ore }

onready var resources := Scene.search("Resources")

export var capacity: int = 0
export(USAGE) var usage: int = USAGE.food

func _building_is_built() -> void:
	._building_is_built()
	resources.add_resource("max_amount", capacity, USAGE.keys()[usage])

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Usage" : USAGE.keys()[usage],
		"Capacity" : capacity
	}
	building_overview.update_info(infos)
