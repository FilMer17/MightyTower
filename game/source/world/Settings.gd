extends Node

export var screen_size := Vector2()
export var volume := 100

var data: Dictionary = {}

func create() -> void:
	# set all data values
	data = {
		"screen_size" : get_viewport().size,
		"volume" : volume
	}
	# set all data values
	
	save_data()

func save_data() -> Dictionary:
	data = {
		"screen_size" : screen_size,
		"volume" : volume
	}
	
	return data

func load_data(_data: Dictionary) -> void:
	data = _data
	screen_size = _data["screen_size"]
	volume = _data["volume"]

