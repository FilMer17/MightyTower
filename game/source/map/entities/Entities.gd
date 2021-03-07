extends Node2D

const MAP_SIZE := { "S" : 90, "M" : 120, "L" : 150 }

onready var terrain := Scene.search("Terrain")

var data: Dictionary = {}
var in_menu: bool = false

func create_entities(diffic: String) -> void:
	var grid = IsoGrid.new()
	var map_size = MAP_SIZE[diffic]
	var temp_data: Dictionary = {}
	
	var noise = _create_noise()
	
	for x in map_size:
		for y in map_size:
			temp_data[Vector2(x, y)] = _get_entity_data(terrain.data[Vector2(x, y)]["terrain"], noise.get_noise_2d(float(x), float(y)))
			if not temp_data[Vector2(x, y)] == null:
				data[Vector2(x, y)] = temp_data[Vector2(x, y)]
	
	_place_entities(grid)

func place_on_stone(pos: Vector2) -> void:
	data[pos] = GlobalData.entities["Stone"]

func _create_noise() -> OpenSimplexNoise:
#	randomize()
	var _noise := OpenSimplexNoise.new()
	
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
	
	return _noise

func _place_entities(grid: IsoGrid) -> void:
	for file_data in data:
		var entity = data[file_data].instance()
		entity.position = grid.map_to_world(file_data) + Vector2(0, 8)
		terrain.data[file_data]["placed"] = entity.name
		add_child(entity)

func _get_entity_data(_terrain: int, noise_sample: float) -> Entity:
	# grass = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(1, 3)
	
#	if noise_sample > -0.2 and noise_sample < -0.1:
#		if not rnum == 1 and _terrain == 0:
#			return GlobalData.entities["Stone"]
	if noise_sample > 0 and noise_sample < 0.2:
		if not rnum == 1 and _terrain == 0:
			return GlobalData.entities["Tree"]
	
	return null
