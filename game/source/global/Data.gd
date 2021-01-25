extends Node

var file: File

func save_dict_data(path: String, value: Dictionary) -> void:
	file = File.new()
	file.open_encrypted_with_pass(path, File.WRITE, "") # change string to password
	
	file.store_var(value)
	
	file.close()

func load_dict_data(path: String) -> Dictionary:
	file = File.new()
	file.open_encrypted_with_pass(path, File.READ, "") # change string to password
	
	var data = file.get_var()
	
	file.close()
	
	return data
