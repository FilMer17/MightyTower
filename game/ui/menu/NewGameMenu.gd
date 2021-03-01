extends Control

func _on_Play_pressed():
	GlobalData.selected_world = {
		"is_new" : true,
		"name" : $CenterContainer/HBoxContainer/Name.text,
		"size" : $CenterContainer/HBoxContainer/Size.text,
		"difficulty" : $CenterContainer/HBoxContainer/Difficulty.text
	}
	Scene.change("Game")
