extends Control

onready var validator := $Validator
onready var play_button := $HBoxContainer/Play

var world_names: Array = []

func _ready() -> void:
	change_validator_data("default")
	
	for world_name in GlobalData.worlds:
		world_names.append(world_name)

func change_validator_data(option: String):
	match option:
		"valid":
			validator.set("self_modulate", Color("#00ff00"))
			validator.text = "Valid name"
			play_button.disabled = false
		"duplicate":
			validator.set("self_modulate", Color("#ff0000"))
			validator.text = "Already used name"
			play_button.disabled = true
		"default":
			validator.set("self_modulate", Color("#ffff00"))
			validator.text = "Default name"
			play_button.disabled = false

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
	
	GlobalData.world_is_new = true
	Scene.change("Game")

func _on_Back_pressed():
	Scene.change("TitleScreen")

func _on_Name_text_changed(new_text):
	if new_text == "":
		change_validator_data("default")
		return
	
	if world_names.empty():
		change_validator_data("valid")
		return
	
	for w_name in world_names:
		if new_text == w_name:
			change_validator_data("duplicate")
			return
		else:
			change_validator_data("valid")
