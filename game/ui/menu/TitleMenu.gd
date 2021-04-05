extends Control

func _on_NewGame_pressed():
	Scene.change("NewGameMenu")

func _on_LoadGame_pressed():
	Scene.change("LoadGameMenu")

func _on_Quit_pressed():
	get_tree().quit()
