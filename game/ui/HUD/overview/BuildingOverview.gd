extends Control

onready var title := $PanelContainer/Container/Title
onready var items_container := $PanelContainer/Container/ItemsContainer

onready var info_item := preload("res://ui/game/item/InfoItem.tscn")

func _ready() -> void:
	clear_items()

func update_info(infos: Dictionary) -> void:
	clear_items()
	
	title.text = infos["title"]
	var __ = infos.erase("title")
	for key in infos.keys():
		var info = info_item.instance()
		items_container.add_child(info)
		info.get_node("Item").text = key
		info.get_node("Number").text = str(infos[key])

func clear_items() -> void:
	for child in items_container.get_children():
		child.queue_free()
