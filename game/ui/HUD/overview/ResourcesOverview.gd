extends Control

onready var food_container := $PanelContainer/Container/FoodContainer
onready var people_container := $PanelContainer/Container/PeopleContainer
onready var material_container := $PanelContainer/Container/MaterialContainer
onready var storage_container := $PanelContainer/Container/StorageContainer

onready var resources := Scene.search("Resources")

func _ready() -> void:
	update_info("food")
	for child in people_container.get_children():
		update_info("people", child.name)
	for child in material_container.get_children():
		update_info("material", child.name)
	for child in storage_container.get_children():
		update_info("max_amount", child.name)

func update_info(group: String, resource: String = "") -> void:
	match group:
		"food":
			food_container.get_node("food").get_node("Number").text = str(resources.food)
		"people":
			people_container.get_node(resource).get_node("Number").text = str(resources.people[resource])
		"material":
			material_container.get_node(resource).get_node("Number").text = str(resources.material[resource])
		"max_amount":
			storage_container.get_node(resource).get_node("Number").text = str(resources.max_amount[resource])
