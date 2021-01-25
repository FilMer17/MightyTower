extends Node

export var food := 0
export var people := {
	"idle" : 0,
	"busy" : 0
}
export var material := {
	"wood" : 0,
	"stone" : 0
}
export var ore := {
	"coal" : 0,
	"iron" : 0
}
export var max_amount := {
	"food" : 0,
	"people" : 0,
	"material" : 0,
	"ore" : 0
}

var data: Dictionary = {}

func create() -> void:
	# set all data values
	data = {
		"food" : food,
		"people" : people,
		"material" : material,
		"ore" : ore,
		"max_amount" : max_amount
	}
	# set all data values
	
	save_data()

func save_data() -> Dictionary:
	data = {
		"food" : food,
		"people" : people,
		"material" : material,
		"ore" : ore,
		"max_amount" : max_amount
	}
	
	return data

func load_data(_data: Dictionary) -> void:
	data = _data
	food = _data["food"]
	people = _data["people"]
	material = _data["material"]
	ore = _data["ore"]
	max_amount = _data["max_amount"]
