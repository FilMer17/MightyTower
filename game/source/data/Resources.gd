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

func save_data() -> Dictionary:
	var data := {}
	data["food"] = food
	data["people"] = people
	data["material"] = material
	data["ore"] = ore
	data["max_amount"] = max_amount
	return data

func load_data(data: Dictionary) -> void:
	food = data["food"]
	people = data["people"]
	material = data["material"]
	ore = data["ore"]
	max_amount = data["max_amount"]
