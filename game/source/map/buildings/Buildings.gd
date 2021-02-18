extends Node2D

func place_building(to_build: String, pos: Vector2) -> void:
	var building = GlobalData.buildings[to_build].instance()
	building.position = pos
	add_child(building)
