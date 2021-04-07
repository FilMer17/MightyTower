tool
extends Building
class_name House

export var people_storage: int = 0

onready var resources := Scene.search("Resources")

func _building_is_built() -> void:
	._building_is_built()
	if not is_loaded:
		resources.add_resource("max_amount", people_storage, "people")

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Capacity" : people_storage
	}
	building_overview.update_info(infos)
