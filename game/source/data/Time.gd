extends Node

export var year: int = 1
export var month: int = 1
export var day: int = 1
export var hour: int = 0
export var minute: int = 0

export var speed: float = 0.3
export var is_paused := true

onready var clock: Timer = $Clock

func save_data() -> Dictionary:
	var data := {}
	data["year"] = year
	data["month"] = month
	data["day"] = day
	data["hour"] = hour
	data["minute"] = minute
	return data

func load_data(data: Dictionary) -> void:
	year = data["year"]
	month = data["month"]
	day = data["day"]
	hour = data["hour"]
	minute = data["minute"]

func change_clock_state() -> void:
	is_paused = !is_paused
	if not is_paused:
		clock.start()
	else:
		clock.stop()

func change_clock_speed(_speed: int) -> void:
	speed = _speed
	clock.wait_time = speed

func _on_Clock_timeout():
	minute += 1
	if minute >= 60:
		minute = 0
		hour += 1
		# call hour changes -> building time
		if hour >= 24:
			hour = 0
			day += 1
			# call day changed -> get resources
			if day >= 31:
				day = 1
				month += 1
				# call month changed -> new month 
				if month >= 13:
					month = 1
					year += 1
					# call year changes -> new year
