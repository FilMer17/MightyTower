extends Control


func _on_Continue_pressed():
	visible = false
	Scene.search("Game").pause_exitm = false
	get_tree().paused = false
	mouse_filter = MOUSE_FILTER_IGNORE


func _on_Exit_pressed():
	get_tree().paused = false
	Scene.change("TitleScreen")
