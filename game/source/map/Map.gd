extends Node2D

onready var terrain := $Terrain
onready var buildings := $Buildings
onready var entities := $Entities
onready var builder := $Builder

var in_builder: bool = false
var node_in_menu: bool = false
var detected_areas: Array = []

func load_data(data: Dictionary) -> void:
	terrain.data = data["terrain"]
	terrain.draw_terrain()

func save_data(to_save: String) -> Dictionary:
	var data := {}
	match to_save:
		"terrain":
			data["terrain"] = terrain.data
		"buildings":
			data["buildings"] = buildings.save_data()
		"entities":
			data["entities"] = entities.data
	
	return data

func create_data(diffic: String) -> void:
	terrain.create_terrain(diffic)
	builder.build("Residence")
	entities.create_entities(diffic)

func _input(event):
	if event.is_action_pressed("ui_home") and !builder.sprite.visible:
		builder.build("Residence")
	if event.is_action_pressed("ui_page_up") and !builder.sprite.visible:
		builder.build("Lumberjack")
