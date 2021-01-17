extends Control

func _on_NewGame_pressed():
	Scene.change("NewGameMenu")

func _on_LoadGame_pressed():
	pass # Replace with function body.

func _on_Settings_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	pass # Replace with function body.

#var mouse_pos
#var nm = Vector2(0,0)
#func _process(_delta):
#	mouse_pos = get_global_mouse_position()
#	if nm == mouse_pos:
#		return
#	else:
#		print(IsoGrid.world_to_map(mouse_pos, Vector2(3, 3)))
#		print(IsoGrid.get_area_around(IsoGrid.world_to_map(mouse_pos, Vector2(3, 3)), 2))
#
#	nm = mouse_pos
