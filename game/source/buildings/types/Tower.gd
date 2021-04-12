tool
extends Building
class_name Tower

export var capacity: int = 1

onready var resources := Scene.search("Resources")
onready var builder := Scene.search("Builder")

onready var area := $BuildingArea as Area2D
onready var area_zone := $BuildingArea/Zone as CollisionShape2D
onready var light := $Light as Light2D

var people_in: int = 0

func _ready() -> void:
	var __
	__ = area.connect("area_entered", self, "_on_Area_entered")
	__ = area.connect("area_exited", self, "_on_Area_exited")
	
	light.color = Color("#f0dc96")
	
	if is_loaded and is_built:
		people_in = buildings.data[position].people_in
		if people_in == capacity:
			area_zone.disabled = false
			light.visible = true
	else:
		buildings.data[position]["people_in"] = people_in

func find_worker() -> void:
	if is_built and people_in < capacity:
		if not resources.people["idle"] <= 0:
			resources.add_resource("people", -1, "idle")
			resources.add_resource("people", 1, "employed")
			Scene.search("Console").write("Person add to " + alias)
			people_in += 1
			buildings.data[position]["people_in"] = people_in
	if people_in == capacity:
		area_zone.disabled = false
		light.visible = true
	else:
		area_zone.disabled = true
		light.visible = false
	return

func _on_Area_entered(_area: Area2D) -> void:
	if _area.get_parent().name == "Builder":
		builder.emit_signal("entered_build_area")

func _on_Area_exited(_area: Area2D) -> void:
	if _area.get_parent().name == "Builder":
		builder.emit_signal("exited_build_area")

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Capacity" : capacity
	}
	building_overview.update_info(infos)

func _enter_tree() -> void:
	._enter_tree()
	
	if not $BuildingArea:
		area = Area2D.new()
		area.name = "BuildingArea"
		add_child(area)
		area.owner = get_tree().edited_scene_root
		print("Node added: %s" % area.name)

	if not $BuildingArea/Zone:
		area_zone = CollisionShape2D.new()
		area_zone.name = "Zone"
		area.add_child(area_zone)
		area_zone.owner = get_tree().edited_scene_root
		area_zone.disabled = true
		print("Node added: %s" % area_zone.name)
	
	if not $Light:
		light = Light2D.new()
		light.name = "Light"
		add_child(light)
		light.mode = Light2D.MODE_MIX
		light.owner = get_tree().edited_scene_root
		light.visible = false
		print("Node added: %s" % light.name)
