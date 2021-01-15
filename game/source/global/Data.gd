extends Node

var games := {}
var buildings := {}

func _ready() -> void:
	scan()

func scan() -> void:
	_load_games()
	_load_buildings()

func _load_games() -> void:
	games.clear()
	
	for file_data in Loader.load_dir("res://data/games/", ["tres", "res"]):
		games[file_data.data.id] = file_data.data
	
	print(games)

func _load_buildings() -> void:
	buildings.clear()
	
	for file_data in Loader.load_dir("res://data/buildings/", ["tscn", "scn"]):
		buildings[file_data.data.instance().name] = file_data.data
	
	print(buildings)
