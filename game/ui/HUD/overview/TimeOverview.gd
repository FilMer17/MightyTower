extends Control

onready var time_label := $PanelContainer/VBoxContainer/Time

onready var time := Scene.search("Time")

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
