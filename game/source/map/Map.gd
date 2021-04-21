extends Node2D

onready var terrain := $Terrain
onready var buildings := $EntBuild/Buildings
onready var entities := $EntBuild/Entities
onready var builder := $Builder

onready var resources := Scene.search("Resources")

var in_builder: bool = false
var node_in_menu: bool = false
var detected_areas: Array = []

func create_data(diffic: String) -> void:
	terrain.create_terrain(diffic)
	entities.create_entities(diffic)
	builder.build("Residence")

func load_data() -> void:
	terrain.load_terrain(GlobalData.terrain_data)
	entities.load_entities(GlobalData.entities_data, GlobalData.states_data.entities_state)
	buildings.load_buildings(GlobalData.buildings_data, GlobalData.states_data.buildings_state)
