tool
extends Building
class_name Worker

enum WORKTYPE { stone, wood, coal, gold, iron }

export(WORKTYPE) var worktype: int = WORKTYPE.wood
export var capacity: int = 0
export(float, 0, 1) var help_with_cld: float = 0

onready var area := $WorkerArea as Area2D
onready var area_zone := $WorkerArea/Zone as CollisionShape2D

onready var resources := Scene.search("Resources")

var people_in: int = 0
var ready_help: bool = false

func _ready() -> void:
	if is_loaded and is_built:
		people_in = buildings.data[position].people_in
		if people_in == capacity:
			ready_help = true
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
		ready_help = true
	else:
		ready_help = false
	return

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Work type" : WORKTYPE.keys()[worktype],
		"Capacity" : capacity,
		"Reduction" : 100 - (help_with_cld * 100)
	}
	building_overview.update_info(infos)

func _enter_tree() -> void:
	._enter_tree()
	
	if not $WorkerArea:
		area = Area2D.new()
		area.name = "WorkerArea"
		add_child(area)
		area.owner = get_tree().edited_scene_root
		print("Node added: %s" % area.name)

	if not $WorkerArea/Zone:
		area_zone = CollisionShape2D.new()
		area_zone.name = "Zone"
		area.add_child(area_zone)
		area_zone.owner = get_tree().edited_scene_root
		print("Node added: %s" % area_zone.name)
