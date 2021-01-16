extends Resource
class_name MapData

enum Difficulty { easy, medium, hard }
enum Mapsize { s, m, l }
enum Terrain { grass, sand, water, stone }

export var width := 20
export var height := 20
export(Difficulty) var difficulty = Difficulty.easy
export(Mapsize) var map_size = Mapsize.s
export var map_name: String

var data: Dictionary

var _places := 3

var _terrain: int
var _noise: OpenSimplexNoise

func create(_difficulty: int, _map_name: String, _map_size: int) -> void:
	data = {}
	difficulty = _difficulty
	map_name = _map_name
	map_size = _map_size
	
	match map_size:
		0:
			width = 20 * _places
			height = width
		1:
			width = 50 * _places
			height = width
		2:
			width = 80 * _places
			height = width
	
	_create_new_noise()
	
	for x in width:
		for y in height:
			_terrain = _get_terrain_index(_noise.get_noise_2d(float(x), float(y)))
			data[Vector2(x, y)] = _terrain

func _get_terrain_index(noise_sample) -> int:
	if noise_sample < -0.1:
		return Terrain.water
	if noise_sample < 0.0:
		return Terrain.sand
	if noise_sample < 0.3:
		return Terrain.grass
	
	return Terrain.stone

func _create_new_noise() -> void:
#	randomize()
	_noise = OpenSimplexNoise.new()
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
