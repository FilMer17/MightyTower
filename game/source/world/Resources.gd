extends Node

export var food := 0
export var people := {
	"idle" : 5,
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
	data = {
		"food" : food,
		"people" : people,
		"material" : material,
		"ore" : ore,
		"max_amount" : max_amount
	}
	# save data to .save file
