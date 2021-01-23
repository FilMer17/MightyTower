extends Resource
class_name WorldData

enum DIFFICULTY { easy, medium, hard }

export var alias: String = ""
export var settings: Dictionary = {}
export var resources: Dictionary = {}
export var map: Dictionary = {}
export var buildings: Dictionary = {}

var settings_data: SettingsData = null
var resources_data: ResourcesData = null
var map_data: MapData = null
#var building_data: BuildingData = null

export(DIFFICULTY) var difficulty = DIFFICULTY.easy

func _init(diffic: int, als: String, mp_sz: int) -> void:
	alias = als
	difficulty = diffic
	
	settings_data = SettingsData.new()
	resources_data = ResourcesData.new()
	map_data = MapData.new(mp_sz)
#	building_data = BuildingData.new()
