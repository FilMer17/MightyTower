tool
extends Building
class_name Maker

# warning-ignore:unused_signal
signal make_entity

enum MAKETYPE { Rock, Tree, Coal, Gold, Iron, Food}

export(MAKETYPE) var maketype := MAKETYPE.Rock

onready var grid := IsoGrid.new()
onready var entities := Scene.search("Entities")
onready var terrain := Scene.search("Terrain")

var free_pos: Array = [0, 1, 2, 3, 4, 5, 6, 7]

func _ready() -> void:
	var __
	if maketype == MAKETYPE.Food:
		__  = connect("make_entity", self, "_on_Add_food")
	else:
		__ = connect("make_entity", self, "_on_Make_entity")
		
		if is_loaded and is_built:
			free_pos = buildings.data[position].free_pos
		else:
			buildings.data[position]["free_pos"] = free_pos

func add_free_pos(f_pos: int) -> void:
	free_pos.append(f_pos)

func _change_building_overview() -> void:
	var infos := {
		"title" : alias,
		"Make type" : MAKETYPE.keys()[maketype]
	}
	building_overview.update_info(infos)

func _on_Make_entity() -> void:
	if not is_built:
		return
	
	if free_pos.empty():
		return
	
	var neigh_num = free_pos[0]
	
	var ent_pos = grid.world_to_map(position + Vector2(0, 24)) + grid.NEIGHBOR_TABLE[neigh_num]
	free_pos.erase(neigh_num)
	buildings.data[position].free_pos.erase(neigh_num)
	var entity = GlobalData.entities[MAKETYPE.keys()[maketype]].instance()
	entity.maker_help = { "path" : get_path(), "num" : neigh_num }
	entity.position = grid.map_to_world(ent_pos)
	entities.add_child(entity)
	entities.data[ent_pos] = { "type" : MAKETYPE.keys()[maketype], "sprite" : MAKETYPE.keys()[maketype].to_lower() + str(1) }
	entities.data[ent_pos]["path"] = entity.get_path()
	entities.data[ent_pos]["maker_help"] = { "path" : get_path(), "num" : neigh_num }
	terrain.data[ent_pos]["placed"] = entity.name
	Scene.search("Console").write(MAKETYPE.keys()[maketype] + " was made")

func _on_Add_food() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	
	Scene.search("Resources").add_resource("food", rng.randi_range(5, 12))
