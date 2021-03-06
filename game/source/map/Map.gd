extends Node2D

onready var terrain := $Terrain
onready var buildings := $Buildings
onready var entities := $Entities
onready var builder := $Builder

var in_builder: bool = false

func load_data(data: Dictionary) -> void:
	terrain.data = data["terrain"]
	terrain.draw_terrain()

func save_data() -> Dictionary:
	var data := {}
	data["terrain"] = terrain.data
	data["buildings"] = buildings.save_data()
	data["entities"] = entities.data
	
	return data

func create_data(diffic: String) -> void:
	terrain.create_terrain(diffic)
	builder.build("Residence")
	entities.create_entities(diffic)

func _input(event):
	if event.is_action_pressed("ui_home") and !builder.sprite.visible:
		builder.build("Residence")
	if event.is_action_pressed("ui_page_down") and !builder.sprite.visible:
		builder.build("SmallHouse")
