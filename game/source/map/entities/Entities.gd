extends Node2D

const MAP_SIZE := { "S" : 90, "M" : 120, "L" : 150 }

onready var terrain := Scene.search("Terrain")
onready var tree_sprites := {
	1 : preload("res://graphics/entities/Tree.png"),
	2 : preload("res://graphics/entities/Tree2.png"),
	3 : preload("res://graphics/entities/Tree3.png")
}

onready var rock_sprites := {
	1 : preload("res://graphics/entities/Rock.png")
}

onready var coal_sprites := {
	1 : preload("res://icon.png")
}

onready var gold_sprites := {
	1 : preload("res://icon.png")
}

onready var iron_sprites := {
	1 : preload("res://icon.png")
}

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
			if not temp_data[Vector2(x, y)].empty():
				data[Vector2(x, y)] = temp_data[Vector2(x, y)]
	
	_place_entities(grid)

func place_on_stone(pos: Vector2) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(1, 10)

	if rnum in range(1, 5):
		data[pos] = { "type" : GlobalData.entities["Coal"], "sprite" : coal_sprites[1]}
	elif rnum in range(4, 7):
		data[pos] = { "type" : GlobalData.entities["Iron"], "sprite" : iron_sprites[1]}
	elif rnum == 7:
		data[pos] = { "type" : GlobalData.entities["Gold"], "sprite" : gold_sprites[1]}

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
	for file_data in data.keys():
		var entity = data[file_data]["type"].instance()
		entity.position = grid.map_to_world(file_data)
		entity.get_node("Sprite").texture = data[file_data]["sprite"]
		terrain.data[file_data]["placed"] = entity.name
		add_child(entity)

func _get_entity_data(_terrain: int, noise_sample: float) -> Dictionary:
	# grass = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(1, 3)
	var rsprite_num = rng.randi_range(1, 3)
	
	if noise_sample > -0.2 and noise_sample < -0.1:
		if not rnum == 1 and _terrain == 0:
			return { "type" : GlobalData.entities["Rock"], "sprite" : rock_sprites[1]}
	if noise_sample > 0 and noise_sample < 0.125:
		if not rnum == 1 and _terrain == 0:
			return { "type" : GlobalData.entities["Tree"], "sprite" : tree_sprites[rsprite_num]}
	
	return {}
