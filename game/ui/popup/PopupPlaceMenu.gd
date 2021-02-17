extends PopupPanel

func _ready() -> void:
	visible = true
	var __
	__ = $HContainer/Yes.connect("pressed", get_parent().get_parent(), "_place_building", [true])
	__ = $HContainer/No.connect("pressed", get_parent().get_parent(), "_place_building", [false])
