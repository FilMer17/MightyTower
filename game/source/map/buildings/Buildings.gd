extends Node2D

onready var building := GlobalData.buildings

var is_building: bool = false
var build: Building = null

onready var grid := get_parent().get_node("IsoGrid")
onready var terrain := get_parent().get_node("Terrain")

func _physics_process(_delta):
	if is_building:
		var pos = get_global_mouse_position()
		build.position = grid.map_to_world(grid.world_to_map(pos))

func _input(event):
	if is_building:
		pass

func build_building(bname: String) -> void:
	build = building[bname].instance()
	add_child(build)
	is_building = true
