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
