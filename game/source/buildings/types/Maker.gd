tool
extends Building
class_name Maker

enum MAKETYPE { Rock, Tree, Coal, Gold, Iron }

export(MAKETYPE) var maketype := MAKETYPE.Rock

onready var grid := IsoGrid.new()

func _ready() -> void:
	_on_Create_entity()

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Make type" : MAKETYPE.keys()[maketype]
	}
	building_overview.update_info(infos)

func _on_Create_entity() -> void:
	for neigh_coord in grid.NEIGHBOR_TABLE:
		var neighbor = grid.world_to_map(position + Vector2(0, 24)) + neigh_coord
		var entity = GlobalData.entities["Tree"].instance()
		entity.position = grid.map_to_world(neighbor)
		Scene.search("Entities").add_child(entity)
