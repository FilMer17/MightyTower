extends Node2D
class_name Map

var map_data: MapData

onready var terrain := $Terrain

func _ready() -> void:
#	for_new_game(2)
	_build_map()

func initialize(_map_data: MapData) -> void:
	map_data = _map_data

func _build_map() -> void:
	for key in map_data.data.keys():
		var tile_pos: Vector2 = key
		var tile_terrain: int = map_data.data[key]
		
		terrain.set_cellv(tile_pos, tile_terrain)

func for_new_game(level: int) -> void:
	map_data = MapData.new()
	map_data.create(level)
