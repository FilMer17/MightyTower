tool
extends StaticBody2D
class_name Entity

enum TYPE { stone, tree }

export var level: int = 1
export(TYPE) var type: int = TYPE.stone

onready var sprite := $Sprite
onready var collider := $Collider

var is_hovered: bool = false

func _ready() -> void:
	var __
	
	sprite.material = load("res://graphics/shader/BuildingMaterial.tres").duplicate()
	sprite.material.set_shader_param("color", Color("#0000ff"))
	
	input_pickable = true
	__ = connect("mouse_entered", self, "_on_Mouse_entered")
	__ = connect("mouse_exited", self, "_on_Mouse_exited")

func _input(event) -> void:
	if is_hovered and event.is_action_pressed("ui_end"):
		print("Open mine option")

func _on_Mouse_entered() -> void:
	sprite.material.set_shader_param("is_hovered", true)
	is_hovered = true

func _on_Mouse_exited() -> void:
	sprite.material.set_shader_param("is_hovered", false)
	is_hovered = false

func _enter_tree():
	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)
	
	if not $Collider:
		collider = CollisionPolygon2D.new()
		collider.name = "Collider"
		add_child(collider)
		collider.owner = get_tree().edited_scene_root
		print("Node added: %s" % collider.name)
