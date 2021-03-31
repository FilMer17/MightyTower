extends Control

func _on_Play_pressed():
	GlobalData.selected_world = {
		"is_new" : true,
		"name" : $HBoxContainer/Name.text,
		"size" : $HBoxContainer/Size.text,
		"difficulty" : $HBoxContainer/Difficulty.text
	}
	Scene.change("Game")


func _on_Back_pressed():
	Scene.change("TitleScreen")
