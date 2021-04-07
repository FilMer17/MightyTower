extends Node

func load_dir(path: String, extentions: Array, load_resource := true) -> Array:
	return _get_directory_data(path, [], extentions, load_resource)


func save_world(data, file_name: String, full_obj: bool = false) -> void:
	var file = File.new()
	file.open("user://worlds/" + GlobalData.world_data.world_name + \
			  "/" + file_name + ".save", File.WRITE)
	file.store_var(data, full_obj)
	file.close()

func get_world_data(world_name: String) -> WorldData:
	var file = File.new()
	file.open("user://worlds/" + world_name + "/worlddata.save", File.READ)
	var world_data = file.get_var(true)
	var world = WorldData.new()
	
	world.world_name = world_data.world_name
	world.world_size = world_data.world_size
	world.world_difficulty = world_data.world_difficulty
	world.settings = world_data.settings
	world.time = world_data.time
	world.resources = world_data.resources
	
	return world

func get_terrain(world_name: String) -> Dictionary:
	var file = File.new()
	file.open("user://worlds/" + world_name + "/terrain.save", File.READ)
	var terrain_data = file.get_var()
	
	return terrain_data

func get_entities(world_name: String) -> Dictionary:
	var file = File.new()
	file.open("user://worlds/" + world_name + "/entities.save", File.READ)
	var entities_data = file.get_var()
	
	return entities_data

func get_buildings(world_name: String) -> Dictionary:
	var file = File.new()
	file.open("user://worlds/" + world_name + "/buildings.save", File.READ)
	var buildings_data = file.get_var()
	
	return buildings_data

func get_states_data(world_name: String) -> StatesData:
	var file = File.new()
	file.open("user://worlds/" + world_name + "/states.save", File.READ)
	var states_data = file.get_var(true)
	var states = StatesData.new()
	
	states.entities_state = states_data.entities_state
	states.buildings_state = states_data.buildings_state
	
	return states

func delete_world(world_name) -> void:
	var __
	
	var dir = Directory.new()
	dir.open("user://worlds/" + world_name)
	__ = dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			dir.remove(file)
	
	dir.remove("user://worlds/" + world_name)

func _get_directory_data(path: String, directory_data: Array, extentions: Array, load_resource: bool) -> Array:
	var directory := Directory.new()

	if not directory.open(path) == OK:
		print("FileSystem: failed to load ", path, ", return [] (open)")
		return []

	if not directory.list_dir_begin(true, true) == OK:
		print("FileSystem: failed to load ", path, ", return [] (list_dir_begin)")
		return []

	var sub_path := ""

	while true:
		sub_path = directory.get_next()

		if sub_path == "." or sub_path == ".." or sub_path.begins_with("_"):
			continue

		elif sub_path == "":
			break

		elif directory.current_is_dir():
			directory_data = _get_directory_data(directory.get_current_dir() + "/" + sub_path, directory_data, extentions, load_resource)
		else:
			if not extentions.has(sub_path.get_extension()):
				continue

			var file_data: Dictionary = _get_file_data(directory.get_current_dir() + "/" + sub_path, load_resource)
			directory_data.append(file_data)

	directory.list_dir_end()

	return directory_data

func _get_file_data(path: String, load_resource: bool) -> Dictionary:
	var temp_data
	if not (load_resource):
		var file = File.new()
		file.open(path, File.READ)
		temp_data = file.get_var(true)
		file.close()
	
	var file_data := {
		id = path.get_file().get_basename(), # Filename, no extension
		path = path, # Full path to file (includes extension)
		data = load(path) if load_resource else temp_data
	}

	if load_resource and file_data.data == null:
		print("Loader: could not load file: ", path)

	return file_data
