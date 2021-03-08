extends CanvasLayer

onready var text_output := $MarginContainer/VBoxContainer/RichTextLabel as RichTextLabel

var lines: Array = []

func _process(_delta):
	if text_output.rect_size.y >= 300:
		text_output.rect_min_size.y = 300
		text_output.fit_content_height = false

func write(text: String) -> void:
	$MarginContainer.visible = true
	lines.append(text)
	text_output.add_text("\n" + text)
	text_output.scroll_to_line(text_output.get_line_count() - 1)
	yield(get_tree().create_timer(3.0), "timeout")
	$MarginContainer.visible = false
