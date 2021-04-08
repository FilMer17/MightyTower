extends Node

onready var resources_overview := Scene.search("ResourcesOverview")

export var food := 0
export var people := {
	"idle" : 0,
	"busy" : 0,
	"employed" : 0
}
export var material := {
	"stone" : 0,
	"wood" : 0,
	"coal" : 0,
	"iron" : 0,
	"gold" : 0
}
export var max_amount := {
	"food" : 0,
	"people" : 0,
	"material" : 0
}

var all_people: int = 0
var hungry_people: bool = false

func add_resource(group: String, number: int, resource: String = "") -> void:
	match group:
		"food":
			food += number
			_check_max_amount("food")
			resources_overview.update_info("food")
			return
		"people":
			if not resource == "":
				people[resource] += number
				_check_max_amount("people", resource)
				resources_overview.update_info("people", resource)
				return
		"material":
			if not resource == "":
				material[resource] += number
				_check_max_amount("material", resource)
				resources_overview.update_info("material", resource)
				return
		"max_amount":
			if not resource == "":
				max_amount[resource] += number
				resources_overview.update_info("max_amount", resource)
				return
	
	print(group + " or " + resource + " is wrong!")

func check_with_max_amount(group: String, number: int) -> bool:
	var temp = 0
	match group:
		"food":
			temp = food + number
			if temp > max_amount.food:
				return false
		"material":
			for amount in material.values():
				temp += amount
			temp += number
			if temp > max_amount.material:
				return false
	return true

func get_all_people() -> int:
	all_people = 0
	for key in people.keys():
		all_people += people[key]
	
	return all_people

func save_data() -> Dictionary:
	var data := {}
	data["food"] = food
	data["people"] = people
	data["material"] = material
	data["max_amount"] = max_amount
	data["hungry_people"] = hungry_people
	data["all_people"] = all_people
	return data

func load_data(data: Dictionary) -> void:
	food = data["food"]
	people = data["people"]
	material = data["material"]
	max_amount = data["max_amount"]
	hungry_people = data["hungry_people"]
	all_people = data["all_people"]

func create_data(_diffic: String) -> void:
	pass

func _check_max_amount(group: String, resource: String = "") -> void:
	match group:
		"food":
			if food > max_amount.food:
				food = max_amount.food
		"people":
			var __ = get_all_people()
			if all_people > max_amount.people:
				people[resource] -= (all_people - max_amount.people)
		"material":
			var all_material := 0
			for key in material.keys():
				all_material += material[key]
			if all_material > max_amount.material:
				material[resource] -= (all_material - max_amount.material)
