extends Node

var file: File

func save_dict_data(path: String, value: Dictionary) -> void:
	file = File.new()
#	file.open_encrypted_with_pass(path, File.WRITE, "") # change string to password
	var error = file.open(path, File.WRITE)
	if error == OK:
		file.store_var(value)
		file.close()

func load_dict_data(path: String) -> Dictionary:
	file = File.new()
#	file.open_encrypted_with_pass(path, File.READ, "") # change string to password
	var error = file.open(path, File.READ)
	if error == OK:
		var data = file.get_var()
		file.close()
		return data
	
	return {}
