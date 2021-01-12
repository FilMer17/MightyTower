extends Resource
class_name TileData

enum TERRAIN { grass, sand, water, stone }

export var width := 32
export var height := 16
export var depth := 0
export(TERRAIN) var terrain

var size := Vector2(width, height)
