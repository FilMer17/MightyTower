extends PopupPanel

func _ready() -> void:
	visible = true
	var __
	__ = $HContainer/Mine.connect("pressed", get_parent().get_parent(), "_mine_entity", [true])
	__ = $HContainer/No.connect("pressed", get_parent().get_parent(), "_mine_entity", [false])
