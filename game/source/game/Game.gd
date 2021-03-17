extends Node2D

onready var game_ui := $GameUI
onready var game_cam := $GameCamera
onready var pause_label := $GameUI/Pause
onready var exit_menu := $GameUI/ExitMenu

var pause_pause: bool = false
var pause_exitm: bool = false
var cam_unlock: bool = false

func _input(event) -> void:
	if event.is_action_pressed("pause") and not pause_exitm:
		pause_pause = not pause_pause
		get_tree().paused = not get_tree().paused
		pause_label.visible = not pause_label.visible
		cam_unlock = not cam_unlock
		if cam_unlock:
			game_cam.pause_mode = Node.PAUSE_MODE_PROCESS
		else:
			game_cam.pause_mode = Node.PAUSE_MODE_STOP
	if event.is_action_pressed("exit_menu") and not pause_pause:
		pause_exitm = not pause_exitm
		get_tree().paused = not get_tree().paused
		exit_menu.visible = not exit_menu.visible
		if exit_menu.visible:
			exit_menu.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			exit_menu.mouse_filter = Control.MOUSE_FILTER_IGNORE