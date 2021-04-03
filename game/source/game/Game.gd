extends Node2D

onready var game_ui := $GameUI
onready var game_cam := $GameCamera
onready var game_shader := $GameShader
onready var pause_label := $GameUI/Pause
onready var exit_menu := $GameUI/ExitMenu
onready var end_label := $GameUI/End
onready var builder_overview := $GameUI/HUD/BuilderOverview

var pause_pause: bool = false
var pause_exitm: bool = false
var cam_unlock: bool = false

func _ready() -> void:
	end_label.visible = false
	end_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	game_cam.position = Vector2(0, (Scene.search("Terrain").\
		MAP_SIZE[GlobalData.world_data.world_size] / 2) * 16)
	
	game_shader .visible = false

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
	if event.is_action_pressed("build_menu") and not get_tree().paused and Scene.search("Buildings").get_child_count() > 0:
		builder_overview.hide_data()

func end_game(win: bool) -> void:
	if win:
		end_label.text = "Win"
	else:
		end_label.text = "Game over"
	
	end_label.visible = true
	end_label.mouse_filter = Control.MOUSE_FILTER_STOP
	get_tree().paused = true

func _on_End_gui_input(event: InputEvent):
	if end_label.visible and event.is_action_pressed("select_option"):
		get_tree().paused = false
		Scene.change("TitleScreen")
