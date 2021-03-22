extends Control

enum TYPE { residence, storage, house, worker, maker, tower }

onready var name_list := $PanelContainer/VBoxContainer/NameList as ItemList
onready var building_list := $PanelContainer/VBoxContainer/BuildingList as ItemList

var buildings: Dictionary = {}

func _ready() -> void:
	name_list.clear()
	
	name_list.max_columns = TYPE.keys().size()
	for item_name in TYPE.keys():
		name_list.add_item(item_name.to_upper());


func _on_NameList_item_selected(index):
	building_list.clear()
	
	for file_data in FileSystem.load_dir("res://data/buildings/" + TYPE.keys()[index] + "s", ["tscn", "scn"]):
		var data = file_data.data.instance()
		buildings[data.name] = data.get_node("BuildingContainer/Sprite").texture
		data.queue_free()
	
	for build in buildings.keys():
		building_list.add_item(build, buildings[build])
	
	buildings.clear()
