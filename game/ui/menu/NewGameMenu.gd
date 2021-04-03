extends Control

func _on_Play_pressed():
	var w_data = GlobalData.world_data
	w_data.world_name = $HBoxContainer/Name.text
	w_data.world_size = $HBoxContainer/Size.text
	w_data.world_difficulty = $HBoxContainer/Difficulty.text
	
	var dir = Directory.new()
	dir.open("user://worlds")
	
	if w_data.world_name == "":
		var files_count = 1
		var __ = dir.list_dir_begin()
		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files_count += 1
		w_data.world_name = "world" + str(files_count)
		dir.make_dir(w_data.world_name)
	
	Scene.change("Game")


func _on_Back_pressed():
	Scene.change("TitleScreen")
