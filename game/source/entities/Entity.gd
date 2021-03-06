tool
extends Node2D
class_name Entity

enum TYPE { stone, tree }

export var level: int = 1
export(TYPE) var type: int = TYPE.stone

onready var sprite := $Sprite
onready var area := $Area
onready var collider := $Area/Collider

var is_hovered: bool = false

func _ready() -> void:
	var __
	
	sprite.material = load("res://graphics/shader/BuildingMaterial.tres").duplicate()
	sprite.material.set_shader_param("color", Color("#0000ff"))
	
	area.input_pickable = true
	__ = area.connect("mouse_entered", self, "_on_Mouse_entered")
	__ = area.connect("mouse_exited", self, "_on_Mouse_exited")
	__ = area.connect("input_event", self, "_on_Input_event")

func _on_Input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_hovered and event.is_action_pressed("select_option"):
		for building in get_tree().get_nodes_in_group("residence"):
			if area.overlaps_area(building.area):
				print("mine option")
				return

func _on_Mouse_entered() -> void:
	if not get_parent().get_parent().in_builder:
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
	
	if not $Area:
		area = Area2D.new()
		area.name = "Area"
		add_child(area)
		area.owner = get_tree().edited_scene_root
		print("Node added: %s" % area.name)
	
	if not $Area/Collider:
		collider = CollisionPolygon2D.new()
		collider.name = "Collider"
		area.add_child(collider)
		collider.owner = get_tree().edited_scene_root
		print("Node added: %s" % collider.name)
