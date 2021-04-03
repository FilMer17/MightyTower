extends Panel

export var item: String = ""
export var number: int = 0

func _ready() -> void:
	$Item.text = item
	$Number.text = str(number)

func _on_Number_item_rect_changed():
	if $Number.rect_size.x > 38:
		$Number.rect_size.x = 38
		$Number.get("custom_fonts/font").size = 7
