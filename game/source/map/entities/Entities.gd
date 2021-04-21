extends Node2D

const MAP_SIZE := { "S" : 90, "M" : 120, "L" : 150 }

onready var terrain := Scene.search("Terrain")
onready var sprites := {
	"tree1" : preload("res://graphics/entities/Tree.png"),
	"tree2" : preload("res://graphics/entities/Tree2.png"),
	"tree3" : preload("res://graphics/entities/Tree3.png"),
	"rock1" : preload("res://graphics/entities/Rock.png"),
	"rock2" : preload("res://graphics/entities/Rock2.png"),
	"rock3" : preload("res://graphics/entities/Rock3.png"),
	"coal1" : preload("res://graphics/entities/Coal.png"),
	"gold1" : preload("res://graphics/entities/Gold.png"),
	"iron1" : preload("res://graphics/entities/Iron.png")
}

var data: Dictionary = {}
var states: Dictionary = {}

var in_menu: bool = false
var grid = IsoGrid.new()

func create_entities(diffic: String) -> void:
	var map_size = MAP_SIZE[diffic]
	var temp_data: Dictionary = {}
	
	var noise = _create_noise()
	
	for x in map_size:
		for y in map_size:
			temp_data[Vector2(x, y)] = _get_entity_data(terrain.data[Vector2(x, y)]["terrain"], noise.get_noise_2d(float(x), float(y)))
			if not temp_data[Vector2(x, y)].empty():
				data[Vector2(x, y)] = temp_data[Vector2(x, y)]
	
	_place_entities()

func load_entities(e_data: Dictionary, entities_state: Dictionary) -> void:
	data = e_data
	states = entities_state
	_place_entities()

func place_on_stone(pos: Vector2) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(1, 12)

	if rnum in range(1, 5):
		data[pos] = { "type" : "Coal", "sprite" : "coal" + str(1)}
	elif rnum in range(4, 7):
		data[pos] = { "type" : "Iron", "sprite" : "iron" + str(1)}
	elif rnum == 7:
		data[pos] = { "type" : "Gold", "sprite" : "gold" + str(1)}

func _create_noise() -> OpenSimplexNoise:
	randomize()
	var _noise := OpenSimplexNoise.new()
	
	_noise.seed = randi()
	_noise.octaves = 3
	_noise.period = 40
	_noise.persistence = 0.5
	_noise.lacunarity = 2
	
	return _noise

func _place_entities() -> void:
	for file_data in data.keys():
		var entity = GlobalData.entities[data[file_data]["type"]].instance()
		entity.position = grid.map_to_world(file_data)
		entity.get_node("Sprite").texture = sprites[data[file_data]["sprite"]]
		terrain.data[file_data]["placed"] = entity.name
		if data[grid.world_to_map(entity.position)].keys().has("maker_help"):
			entity.maker_help = data[grid.world_to_map(entity.position)].maker_help
		
		if states.has(grid.world_to_map(entity.position)):
			entity.is_mined = states[grid.world_to_map(entity.position)].is_mined
			if not entity.is_mined:
				entity.cld_temp = states[grid.world_to_map(entity.position)].time
		
		add_child(entity)
		data[file_data]["path"] = entity.get_path()

func _get_entity_data(_terrain: int, noise_sample: float) -> Dictionary:
	# grass = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(1, 3)
	var rsprite_num = rng.randi_range(1, 3)
	
	if noise_sample > -0.2 and noise_sample < -0.1:
		if not rnum == 1 and _terrain == 0:
			return { "type" : "Rock", "sprite" : "rock" + str(rsprite_num) }
	if noise_sample > 0 and noise_sample < 0.125:
		if not rnum == 1 and _terrain == 0:
			return { "type" : "Tree", "sprite" : "tree" + str(rsprite_num) }
	
	return {}
