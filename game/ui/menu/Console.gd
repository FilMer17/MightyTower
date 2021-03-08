extends CanvasLayer

onready var timer := $Timer as Timer
onready var container := $Container as MarginContainer
onready var anim_player := $Container/AnimationPlayer as AnimationPlayer
onready var vbox := $Container/VBox as VBoxContainer
onready var text_output := $Container/VBox/TextOutput as RichTextLabel

export var size := 90

var lines: Array = []

func _ready() -> void:
	container.modulate.a = 0.0

func _input(event) -> void:
	if event.is_action_pressed("show_console"):
		if text_output.rect_size.y < size:
			container.mouse_filter = Control.MOUSE_FILTER_STOP
			text_output.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		if text_output.rect_size.y == size:
			container.mouse_filter = Control.MOUSE_FILTER_IGNORE
			text_output.mouse_filter = Control.MOUSE_FILTER_STOP
		
		text_output.scroll_to_line(text_output.get_line_count() - 1)
		timer.stop()
		container.modulate.a = 1.0
		anim_player.stop(true)
	
	if event.is_action_released("show_console"):
		timer.start()

func write(text: String) -> void:
	if text_output.rect_size.y >= size:
		text_output.rect_min_size.y = size
		text_output.fit_content_height = false
	
	if text_output.rect_size.y < size:
		container.mouse_filter = Control.MOUSE_FILTER_STOP
		text_output.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if text_output.rect_size.y == size:
		container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text_output.mouse_filter = Control.MOUSE_FILTER_STOP
	
	container.modulate.a = 1.0
	anim_player.stop(true)
	
	lines.append(text)
	text_output.add_text("\n" + text)
	text_output.scroll_to_line(text_output.get_line_count() - 1)
	
	timer.start()

func _on_Timer_timeout():
	anim_player.play("fading")

func _on_AnimationPlayer_animation_finished(_anim_name):
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_output.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Scene.search("GameCamera").on_console = false

func _on_Container_mouse_entered():
	if text_output.rect_min_size.y < size:
		Scene.search("GameCamera").on_console = true
		timer.stop()
		container.modulate.a = 1.0
		anim_player.stop(true)

func _on_Container_mouse_exited():
	if text_output.rect_min_size.y < size:
		Scene.search("GameCamera").on_console = false
		timer.start()

func _on_TextOutput_mouse_entered():
	if text_output.rect_min_size.y == size:
		Scene.search("GameCamera").on_console = true
		timer.stop()
		container.modulate.a = 1.0
		anim_player.stop(true)

func _on_TextOutput_mouse_exited():
	if text_output.rect_min_size.y == size:
		Scene.search("GameCamera").on_console = false
		timer.start()
