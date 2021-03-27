extends Control


onready var time_label := $PanelContainer/VBoxContainer/Time
onready var tween := $PanelContainer/VBoxContainer/HBoxContainer/Tween
onready var progress := $PanelContainer/VBoxContainer/HBoxContainer/Progress

onready var time := Scene.search("Time")

var change: int = 0

func _ready() -> void:
	progress.max_value = 100
	change = progress.max_value
	progress.value = progress.max_value

func _process(_delta):
	var day_data = [str(time.day), str(time.month), str(time.year)]
	var time_data = [str(time.hour), str(time.minute)]

	for i in range(0, day_data.size()):
		if str(day_data[i]).length() <= 1:
			day_data[i] = "0" + String(day_data[i])

	for i in range(0, time_data.size()):
		if str(time_data[i]).length() <= 1:
			time_data[i] = "0" + String(time_data[i])

	time_label.text = PoolStringArray(day_data).join(".") + " | " + PoolStringArray(time_data).join(":") 

func happiness_change(value: int) -> void:
	var change_temp = change
	change = change + value
	
	if change >= 100:
		return
	elif change <= 0:
		print("game over")
	
	var __
	__ = tween.stop(progress, "value")
	__ = tween.interpolate_property(progress, "value", change_temp, change, 1, Tween.TRANS_EXPO, Tween.EASE_OUT)
	__ = tween.start()
