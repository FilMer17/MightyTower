extends Panel

export var item: String = ""
export var number: int = 0

func _ready() -> void:
	$Item.text = item
	$Number.text = str(number)
