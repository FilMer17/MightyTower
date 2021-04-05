extends Control

onready var world_list := $HBoxContainer/WorldList as ItemList

var worlds: Array = []
var selected_world: String = ""

func _ready() -> void:
	refresh_world_list()

func refresh_world_list() -> void:
	world_list.clear()
	worlds.clear()
	selected_world = ""
	GlobalData.load_worlds()
	
	for world_name in GlobalData.worlds:
		world_list.add_item(world_name)
		worlds.append(world_name)

func _on_WorldList_item_selected(index):
	selected_world = worlds[index]

func _on_Start_pressed():
	if world_list.is_anything_selected():
		GlobalData.world_is_new = false
		GlobalData.world_data.world_name = selected_world
		GlobalData.world_data = FileSystem.get_world(GlobalData.world_data.world_name)
		
		GlobalData.terrain_data = FileSystem.get_terrain(GlobalData.world_data.world_name)
		GlobalData.entities_data = FileSystem.get_entities(GlobalData.world_data.world_name)
		
		Scene.change("Game")


func _on_Delete_pressed():
	if world_list.is_anything_selected():
		FileSystem.delete_world(selected_world)
		refresh_world_list()


func _on_Back_pressed():
	Scene.change("TitleScreen")
