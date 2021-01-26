extends Node

export var year: int = 0
export var month: int = 0
export var day: int = 0
export var hour: int = 0
export var minute: int = 0
export var paused: bool = false

var wait_time: int = 1.0
var time: Timer = null

func _ready():
	time = _set_timer(wait_time)
	time.start()


func _set_timer(_wait_time: float) -> Timer:
	var _timer = Timer.new()
	add_child(_timer)
	var __ = _timer.connect("timeout", self, "_on_Time_timeout")
	_timer.set_wait_time(_wait_time)
	_timer.set_one_shot(false) # Make sure it loops
	
	return _timer

func _on_Time_timeout() -> void:
	pass
