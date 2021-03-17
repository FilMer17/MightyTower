tool
extends Building
class_name Maker

# warning-ignore:unused_signal
signal make_entity

enum MAKETYPE { Rock, Tree, Coal, Gold, Iron }

export(MAKETYPE) var maketype := MAKETYPE.Rock

onready var grid := IsoGrid.new()
onready var entities := Scene.search("Entities")

var free_pos: Array = [0, 1, 2, 3, 4, 5, 6, 7]
var max_entities: bool = false

func _ready() -> void:
	var __
	__ = connect("make_entity", self, "_on_Make_entity")

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Make type" : MAKETYPE.keys()[maketype]
	}
	building_overview.update_info(infos)

func _on_Make_entity() -> void:
	if free_pos.empty():
		return
	
	var neigh_num = free_pos[0]
	
	if not max_entities:
		var ent_pos = grid.world_to_map(position + Vector2(0, 24)) + grid.NEIGHBOR_TABLE[neigh_num]
		free_pos.erase(neigh_num)
		var entity = GlobalData.entities["Tree"].instance()
		entity.maker_help = { "path" : get_path(), "num" : neigh_num }
		entity.position = grid.map_to_world(ent_pos)
		entities.add_child(entity)
		Scene.search("Console").write(MAKETYPE.keys()[maketype] + " was made")
