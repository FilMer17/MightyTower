extends TileMap

const MAP_SIZE := { "S" : 90, "M" : 120, "L" : 150}
enum TERRAINS { grass, sand, stone, water }

export(MAP_SIZE) var map_size: int = MAP_SIZE["S"]

export var data: Dictionary = {}

func create_terrain(size: String) -> void:
	map_size = MAP_SIZE[size]
	
	var noise = _create_noise()
	
	for x in map_size:
		for y in map_size:
			data[Vector2(x, y)] = _get_new_terrain_data(noise.get_noise_2d(float(x), float(y)))
	
	draw_terrain()

func draw_terrain() -> void:
	for pos in data.keys():
		set_cellv(pos, data[pos])

func _create_noise() -> OpenSimplexNoise:
#	randomize()
	var _noise := OpenSimplexNoise.new()
	
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
	
	return _noise

func _get_new_terrain_data(noise_sample: float) -> int:
	if noise_sample < -0.1:
		return TERRAINS.water
	if noise_sample < -0.02:
		return TERRAINS.sand
	if noise_sample < 0.3:
		return TERRAINS.grass
	
	return TERRAINS.stone
