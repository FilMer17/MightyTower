extends Node

export(int, 0, 100) var volume := 100
export var screen_size := Vector2()

func save_data() -> Dictionary:
	var data := {}
	data["volume"] = volume
	data["screen_size"] = screen_size
	return data

func load_data(data: Dictionary) -> void:
	volume = data["volume"]
	screen_size = data["screen_size"]
