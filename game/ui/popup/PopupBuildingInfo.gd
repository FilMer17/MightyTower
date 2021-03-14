extends PopupPanel

onready var info_item := preload("res://ui/game/item/InfoItem.tscn")

func _ready():
	visible = true

func add_item(item: String, number: int) -> void:
	var info = info_item.instance()
	info.get_node("Item").text = item
	info.get_node("Number").text = str(number)
	$VContainer.add_child(info)
