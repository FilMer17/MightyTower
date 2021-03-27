extends Control

enum TYPE { residence, storage, house, worker, maker, tower }

onready var name_list := $PanelContainer/VBoxContainer/NameList as ItemList
onready var building_list := $PanelContainer/VBoxContainer/BuildingList as ItemList

onready var building_overview := Scene.search("BuildingOverview")
onready var builder := Scene.search("Builder")

var buildings: Dictionary = {}

func _ready() -> void:
	name_list.clear()
	building_list.clear()
	
	name_list.max_columns = TYPE.keys().size()
	for item_name in TYPE.keys():
		name_list.add_item(item_name.to_upper());
	
	hide_data()

func hide_data() -> void:
	visible = not visible
	building_list.unselect_all()
	building_overview.clear_items()

func _on_NameList_item_selected(index):
	building_list.clear()
	buildings.clear()
	
	for file_data in FileSystem.load_dir("res://data/buildings/" + TYPE.keys()[index] + "s", ["tscn", "scn"]):
		var data = file_data.data.instance()
		buildings[data.name] = {
			"texture" : data.get_node("BuildingContainer/Sprite").texture,
			"alias" : data.alias,
			"path" : "res://data/buildings/" + TYPE.keys()[index] + "s/" + data.name + ".tscn"
		}
		data.queue_free()
	
	for build in buildings.keys():
		building_list.add_item(buildings[build].alias, buildings[build].texture)


func _on_BuildingList_item_selected(index):
	var data_name = buildings.keys()[index]
	var file_data = load(buildings[data_name]["path"]).instance()
	file_data.building_overview = building_overview
	file_data._change_building_overview()


func _on_BuildingList_item_activated(index):
	var building_name = buildings.keys()[index]
	builder.build(building_name)
