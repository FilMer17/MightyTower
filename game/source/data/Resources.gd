extends Node

export var food := 0
export var people := {
	"idle" : 0,
	"busy" : 0
}
export var material := {
	"wood" : 0,
	"stone" : 0,
	"coal" : 0,
	"iron" : 0
}
export var max_amount := {
	"food" : 0,
	"people" : 0,
	"material" : 0,
}

func save_data() -> Dictionary:
	var data := {}
	data["food"] = food
	data["people"] = people
	data["material"] = material
	data["max_amount"] = max_amount
	return data

func load_data(data: Dictionary) -> void:
	food = data["food"]
	people = data["people"]
	material = data["material"]
	max_amount = data["max_amount"]

func create_data(_diffic: String) -> void:
	pass

func add_resource(group: String, number: int, resource: String = "") -> void:
	match group:
		"food":
			food += number
			if food > max_amount["food"]:
				food = max_amount["food"]
				_check_max_amount("food")
				return
		"people":
			if not resource == "":
				people[resource] += number
				_check_max_amount("people", resource)
				return
		"material":
			if not resource == "":
				material[resource] += number
				_check_max_amount("material", resource)
				return
		"max_amount":
			if not resource == "":
				max_amount[resource] += number
				return
	
	print(group + " or " + resource + " is wrong!")

func _check_max_amount(group: String, resource: String = "") -> void:
	match group:
		"food":
			if food > max_amount.food:
				food = max_amount.food
		"people":
			var all_people := 0
			for key in people.keys():
				all_people += people[key]
			if all_people > max_amount.people:
				people[resource] -= (all_people - max_amount.people)
		"material":
			var all_material := 0
			for key in material.keys():
				all_material += material[key]
			if all_material > max_amount.material:
				material[resource] -= (all_material - max_amount.material)
