tool
extends Node2D
class_name Entity

enum TYPE { stone, tree }

export var level: int = 1
export(TYPE) var type: int = TYPE.stone

onready var popup_mine_menu := preload("res://ui/popup/PopupMineMenu.tscn")
onready var resources := Scene.search("Resources")
onready var cooldown_bar_scene := preload("res://ui/bar/CooldownBar.tscn")

onready var sprite := $Sprite as Sprite
onready var area := $Area as Area2D
onready var collider := $Area/Collider as CollisionPolygon2D
onready var gui_container := $GUIContainer as Node2D
onready var menu_container := $MenuContainer as Node2D

var is_hovered: bool = false
var is_mining: bool = false

var cld_bar = null
var progress = null

func _ready() -> void:
	var __
	
	sprite.material = load("res://graphics/shader/BuildingMaterial.tres").duplicate()
	sprite.material.set_shader_param("color", Color("#0000ff"))
	
	area.input_pickable = true
	__ = area.connect("mouse_entered", self, "_on_Mouse_entered")
	__ = area.connect("mouse_exited", self, "_on_Mouse_exited")
	__ = area.connect("input_event", self, "_on_Input_event")

func _on_Input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_hovered and event.is_action_pressed("select_option") and !is_mining:
		for building in get_tree().get_nodes_in_group("residence"):
			if area.overlaps_area(building.area):
				if $MenuContainer.get_child_count() > 0:
					_clear_menu_container()
					Scene.search("Map").node_in_menu = false
				else:
					Scene.search("Map").node_in_menu = true
					sprite.material.set_shader_param("is_hovered", true)
					var menu = popup_mine_menu.instance()
					menu.rect_position = position + Vector2(0, -10)
					menu_container.add_child(menu)
					return

func _mine_entity(to_mine: bool) -> void:
	if to_mine and resources.people["idle"] > 0:
		resources.add_resource("people", -1, "idle")
		resources.add_resource("people", 1, "busy")
		
		var cld_bar_scene = cooldown_bar_scene.instance()
		cld_bar_scene.margin_left = (cld_bar_scene.margin_left / 5)
		cld_bar_scene.margin_right = (cld_bar_scene.margin_right / 5)
		cld_bar_scene.margin_top = (cld_bar_scene.margin_top / 7)
		cld_bar_scene.margin_bottom = (cld_bar_scene.margin_bottom / 7)
		cld_bar_scene.rect_position += Vector2(0, -15)
		
		gui_container.add_child(cld_bar_scene)
		
		cld_bar = gui_container.get_node("CooldownBar")
		progress = cld_bar.get_node("Progress")
		
		var font = cld_bar.get_node("Countdown").get("custom_fonts/font")
		font.size = 4
		
		is_mining = true
		
		print("People added to cut the tree")
		Scene.search("Console").write("People added to cut the tree")
		
	elif to_mine and resources.people["idle"] <= 0:
		print("Not enough idle people")
		Scene.search("Console").write("Not enough idle people")
	
	sprite.material.set_shader_param("is_hovered", false)
	Scene.search("Map").node_in_menu = false
	_clear_menu_container()

func _clear_menu_container() -> void:
	for menu in menu_container.get_children():
		menu.queue_free()

func _on_Mouse_entered() -> void:
	if not Scene.search("Map").in_builder and !Scene.search("Map").node_in_menu:
		sprite.material.set_shader_param("is_hovered", true)
		is_hovered = true

func _on_Mouse_exited() -> void:
	if !Scene.search("Map").node_in_menu:
		sprite.material.set_shader_param("is_hovered", false)
		is_hovered = false

func _enter_tree():
	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)
	
	if not $MenuContainer:
		menu_container = Node2D.new()
		menu_container.name = "MenuContainer"
		add_child(menu_container)
		menu_container.owner = get_tree().edited_scene_root
		print("Node added: %s" % menu_container.name)
	
	if not $GUIContainer:
		gui_container = Node2D.new()
		gui_container.name = "GUIContainer"
		add_child(gui_container)
		gui_container.owner = get_tree().edited_scene_root
		print("Node added: %s" % gui_container.name)	
	
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
