extends Resource
class_name WorldData

export var world_name: String = ""
export var world_size: String = ""
export var world_difficulty: String = ""
export var settings: Dictionary = {}
export var time: Dictionary = {}
export var resources: Dictionary = {}

#func set_world_data(nm: String, sz: String, df: String,\
#					st: Dictionary, tm: Dictionary, rs: Dictionary) -> void:
#	world_name = nm
#	world_size = sz
#	world_difficulty = df
#	settings = st
#	time = tm
#	resources = rs
