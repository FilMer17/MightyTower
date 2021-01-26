extends Node

export var year: int = 1
export var month: int = 1
export var day: int = 1
export var hour: int = 0
export var minute: int = 0

var data: Dictionary = {}

onready var clock: Timer = $Clock

func _ready():
#	clock.start()
	var __ = save_data()

func save_data() -> void:
	data = {
		"year" : year,
		"month" : month,
		"day" : day,
		"hour" : hour,
		"minute" : minute
	}

func load_data(_data: Dictionary) -> void:
	data =  _data
	year = _data["year"]
	month = _data["month"]
	day = _data["day"]
	hour = _data["hour"]
	minute = _data["minute"]

func _on_Clock_timeout() -> void:
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
