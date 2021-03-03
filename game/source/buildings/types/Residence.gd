tool
extends Building
class_name Residence

export var food_storage: int = 0
export var material_storage: int = 0
export var people_storage: int = 0

onready var resources := get_parent().get_parent().get_parent().get_node("Resources")

onready var area := $Area as Area2D
onready var area_zone := $Area/Zone as CollisionShape2D

func _ready() -> void:
	var __ = area.connect("area_entered", self, "_on_Area_entered")

func _on_Area_entered(_area: Area2D) -> void:
	if _area.get_parent().name == "Builder":
		print("hi")

func _building_is_built() -> void:
	._building_is_built()
	resources.add_resource("max_amount", food_storage, "food")
	resources.add_resource("max_amount", material_storage, "material")
	resources.add_resource("max_amount", people_storage, "people")

func _enter_tree() -> void:
	._enter_tree()
	
	if not $Area:
		area = Area2D.new()
		area.name = "Area"
		add_child(area)
		area.owner = get_tree().edited_scene_root
		print("Node added: %s" % area.name)

	if not $Area/Zone:
		area_zone = CollisionShape2D.new()
		area_zone.name = "Zone"
		get_node("Area").add_child(area_zone)
		area_zone.owner = get_tree().edited_scene_root
		print("Node added: %s" % area_zone.name)
