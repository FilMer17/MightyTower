extends Node

export var screen_size := Vector2()
export var volume := 100

var data: Dictionary = {}

func create() -> void:
	data = {
		"screen_size" : screen_size,
		"volume" : volume
	}
	# save data to .save file
