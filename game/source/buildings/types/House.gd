tool
extends Building
class_name House

export var people_storage: int = 0

onready var resources := Scene.search("Resources")

func _building_is_built() -> void:
	._building_is_built()
	resources.add_resource("max_amount", people_storage, "people")
