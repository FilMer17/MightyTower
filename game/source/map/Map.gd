extends Node2D

const MAP_SIZE := { "S" : 100, "M" : 150, "L" : 200}
enum TERRAINS { grass, sand, stone, water }

export(MAP_SIZE) var map_size: int = MAP_SIZE["M"]
export var terrain: Dictionary = {}

func create_terrain(size: String) -> void:
	map_size = MAP_SIZE[size]
	
	var noise: OpenSimplexNoise = _create_noise()
	
	for x in map_size:
		for y in map_size:
			terrain[Vector2(x, y)] = _get_terrain_data(noise.get_noise_2d(float(x), float(y)))

func _create_noise() -> OpenSimplexNoise:
#	randomize()

	var _noise := OpenSimplexNoise.new()
	
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
	
	return _noise

func _get_terrain_data(noise_sample: float) -> Dictionary:
	if noise_sample < -0.1:
		return _create_terrain_data(TERRAINS.water)
	if noise_sample < -0.02:
		return _create_terrain_data(TERRAINS.sand)
	if noise_sample < 0.3:
		return _create_terrain_data(TERRAINS.grass)
	
	return _create_terrain_data(TERRAINS.stone)

func _create_terrain_data(_terrain: int, _depth := 0, _is_empty := true) -> Dictionary:
	return {
		"terrain" : _terrain,
		"depth" : _depth,
		"is_empty" : _is_empty
	}
