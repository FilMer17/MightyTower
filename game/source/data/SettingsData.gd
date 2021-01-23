extends Resource
class_name SettingsData

export var screen_size := Vector2()
export var volume := 100

func save() -> Dictionary:
	var data := {}
	
	data["screen_size"] = screen_size
	data["volume"] = volume
	
	return data


func load_data(data: Dictionary) -> void:
	
	
	pass
