extends Resource
class_name TerrainData

enum TERRAIN { grass, sand, stone, water }

export(TERRAIN) var terrain := TERRAIN.grass
export var depth := 0
export var num_of_res := 0
export var is_empty := true

func _init(_terrain: int, _depth := 0, _num_of_res := 0, _is_empty := true) -> void:
	terrain = _terrain
	depth = _depth
	num_of_res = _num_of_res
	is_empty = _is_empty
