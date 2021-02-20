tool
extends Building
class_name Residence

export var food_storage: int = 0
export var material_storage: int = 0
export var people: int = 0

onready var resources := get_parent().get_parent().get_parent().get_node("Resources")

func _building_is_built() -> void:
	._building_is_built()
	resources.max_amount["material"] += material_storage
