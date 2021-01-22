extends Resource
class_name MapData

enum MAP_SIZE { s, m, l }

export(MAP_SIZE) var map_size := MAP_SIZE.s
export var width := 0
export var height := 0

export var terrain := {}

func _init(mp_sz: int) -> void:
	create_terrain(mp_sz)


func create_terrain(_map_size: int) -> void:
	map_size = _map_size
	match map_size:
		0:
			width = 30 * 3
			height = width
		1:
			width = 50 * 3
			height = width
		2:
			width = 70 * 3
			height = width
	
	var noise: OpenSimplexNoise = _create_noise()
	
	for x in width:
		for y in height:
			terrain[Vector2(x, y)] = _get_terrain_data(noise.get_noise_2d(float(x), float(y)))
			pass


func _create_noise() -> OpenSimplexNoise:
#	randomize()
	var _noise = OpenSimplexNoise.new()
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
	
	return _noise


func _get_terrain_data(noise_sample) -> TerrainData:
	var terr = TerrainData.TERRAIN
	
	if noise_sample < -0.1:
		return TerrainData.new(terr.water)
	if noise_sample < -0.02:
		return TerrainData.new(terr.sand)
	if noise_sample < 0.3:
		return TerrainData.new(terr.grass)
	
	return TerrainData.new(terr.stone)
