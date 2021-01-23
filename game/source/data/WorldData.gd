extends Resource
class_name WorldData

enum DIFFICULTY { easy, medium, hard }

export var settings: Dictionary = {}
export var resources: Dictionary = {}
export var map: Dictionary = {}

export var alias: String = ""

var settings_data: SettingsData = null
var resources_data: ResourcesData = null
var map_data: MapData = null

export(DIFFICULTY) var difficulty = DIFFICULTY.easy

func _init(diffic: int, als: String, mp_sz: int) -> void:
	alias = als
	difficulty = diffic
	
	settings_data = SettingsData.new()
	resources_data = ResourcesData.new()
	map_data = MapData.new(mp_sz)


func save() -> void:
	settings = settings_data.save()
	resources = resources_data.save()
	map = map_data.save()
	var data := {
		"settings" : settings,
		"resources" : resources,
		"map" : map
	}
	
	var file = File.new()
	file.open("user://game1.dat", File.WRITE)
	file.store_var(data)
	file.close()


#func load_data(data: Dictionary) -> WorldData:
#	return WorldData.new()
