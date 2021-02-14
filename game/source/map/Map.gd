extends Node2D

onready var grid := $IsoGrid
onready var terrain := $Terrain
onready var buildings := $Buildings
onready var entities := $Entities

func load_data(data: Dictionary) -> void:
	terrain.data = data["terrain"]
	terrain.draw_terrain()

func save_data() -> Dictionary:
	var data := {}
	data["terrain"] = terrain.data
#	data["buildings"] = buildings.data
#	data["entities"] = entities.data
	
	return data

func create_data(diffic: String) -> void:
	terrain.create_terrain(diffic)
#	buildings.create_residence()
	entities.create_entities(terrain.data, diffic)
