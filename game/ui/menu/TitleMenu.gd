extends Control

func _on_NewGame_pressed():
	Scene.change("Game")

func _on_Quit_pressed():
	get_tree().quit()
