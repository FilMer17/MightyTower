tool
extends Node2D
class_name Entity

enum TYPE { stone, wood }

export var level: int = 1
export(TYPE) var type: int = TYPE.stone
export var alias: String = ""
export var cooldown: Dictionary = { "day" : 0, "hour" : 0, "minute" : 1}

onready var popup_mine_menu := preload("res://ui/popup/PopupMineMenu.tscn")
onready var resources := Scene.search("Resources")
onready var cooldown_bar_scene := preload("res://ui/bar/CooldownBar.tscn")

onready var tween := $Tween as Tween
onready var clock := $Clock as Timer
onready var sprite := $Sprite as Sprite
onready var area := $Area as Area2D
onready var collider := $Area/Collider as CollisionPolygon2D
onready var gui_container := $GUIContainer as Node2D
onready var menu_container := $MenuContainer as Node2D

var is_hovered: bool = false
var is_mining: bool = false
var is_mined: bool = false

var cld_bar = null
var progress = null

var cld_temp := {}
var cld_all_min: int = 0
var cld_all_min_temp: int = 0

func _ready() -> void:
	var __
	
	sprite.material = load("res://graphics/shader/BuildingMaterial.tres").duplicate()
	sprite.material.set_shader_param("color", Color("#0000ff"))
	
	area.input_pickable = true
	__ = area.connect("mouse_entered", self, "_on_Mouse_entered")
	__ = area.connect("mouse_exited", self, "_on_Mouse_exited")
	__ = area.connect("input_event", self, "_on_Input_event")

func _on_Input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if is_hovered and event.is_action_pressed("select_option") and !is_mining and !is_mined:
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
	if is_hovered and event.is_action_pressed("select_option") and is_mined:
		_mining_is_done()

func _mine_entity(to_mine: bool) -> void:
	if to_mine and resources.people["idle"] > 0:
		resources.add_resource("people", -1, "idle")
		resources.add_resource("people", 1, "busy")
		
		var cld_bar_scene = cooldown_bar_scene.instance()
		cld_bar_scene.margin_left = (cld_bar_scene.margin_left / 5)
		cld_bar_scene.margin_right = (cld_bar_scene.margin_right / 5)
		cld_bar_scene.margin_top = (cld_bar_scene.margin_top / 7)
		cld_bar_scene.margin_bottom = (cld_bar_scene.margin_bottom / 7)
		
		gui_container.add_child(cld_bar_scene)
		
		cld_bar = gui_container.get_node("CooldownBar")
		progress = cld_bar.get_node("Progress")
		
		var font = cld_bar.get_node("Countdown").get("custom_fonts/font")
		font.size = 4
		
		cld_temp = cooldown.duplicate()
		var __ = clock.connect("timeout", self, "_on_Mine_cooldown")
		clock.start()
		
		for i in range(0, 3):
			match i:
				0:
					cld_all_min += cld_temp["day"] * 60 * 24
				1:
					cld_all_min += cld_temp["hour"] * 60
				2:
					cld_all_min += cld_temp["minute"]
		
		cld_all_min_temp = cld_all_min
		progress.max_value = cld_all_min
		progress.value = cld_all_min
		
		is_mining = true
		
		print("People added to mine the " + alias)
		Scene.search("Console").write("People added to mine the " + alias)
		
	elif to_mine and resources.people["idle"] <= 0:
		print("Not enough idle people")
		Scene.search("Console").write("Not enough idle people")
	
	sprite.material.set_shader_param("is_hovered", false)
	Scene.search("Map").node_in_menu = false
	_clear_menu_container()

func _clear_menu_container() -> void:
	for menu in menu_container.get_children():
		menu.queue_free()

func _on_Mine_cooldown() -> void:
	for key in cld_temp.keys():
		if cld_temp[key] == 0:
			var __ = cld_temp.erase(key)
			if key == "minute":
				_mining_is_done()
				return
	
	cld_temp.minute -= 1
	if cld_temp.minute == 0:
		if cld_temp.keys().size() <= 1:
			_mining_is_done()
			return
		else:
			cld_temp.minute = 59
			cld_temp.hour -= 1
			if cld_temp.keys().has("day") and cld_temp.hour <= 0:
				cld_temp.day -= 1
				cld_temp.hour = 24
	
	var output = []
	var countdown = cld_bar.get_node("Countdown")
	for key in cld_temp.keys():
		if  cld_temp.has(key):
			output.append(String(cld_temp[key]) + key[0])
	for i in range(0, cld_temp.size()):
		if str(output[i]).length() == 1:
			output[i] = "0" + String(output[i])
	countdown.text = PoolStringArray(output).join(":")
	
	cld_all_min_temp -= 1
	_on_cooldown_changed(cld_all_min_temp)

func _mining_is_done() -> void:
	clock.stop()
	resources.add_resource("people", -1, "busy")
	resources.add_resource("people", 1, "idle")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rnum = rng.randi_range(5, 11)
	
	if not resources.check_with_max_amount("material", rnum):
		progress.visible = false
		cld_bar.get_node("Countdown").text = "Pick up"
		is_mined = true
		print("no space")
		return
	
	print(alias, " was mined. Added " + str(rnum))
	Scene.search("Console").write(alias + " was mined. Added " + str(rnum))
	resources.add_resource("material", rnum, TYPE.keys()[type])
	var grid := IsoGrid.new()
	var __ = Scene.search("Entities").data.erase(grid.world_to_map(position))
	Scene.search("Terrain").data[grid.world_to_map(position)]["placed"] = ""
	
	queue_free()

func _on_cooldown_changed(value: int) -> void:
	var __
	__ = tween.stop(progress, "value")
	__ = tween.interpolate_property(progress, "value", cld_all_min_temp, value, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = tween.start()

func _on_Mouse_entered() -> void:
	if not Scene.search("Map").in_builder and !Scene.search("Map").node_in_menu:
		sprite.material.set_shader_param("is_hovered", true)
		is_hovered = true

func _on_Mouse_exited() -> void:
	if !Scene.search("Map").node_in_menu:
		sprite.material.set_shader_param("is_hovered", false)
		is_hovered = false

func _enter_tree():
	if not $Tween:
		tween = Tween.new()
		tween.name = "Tween"
		add_child(tween)
		tween.owner = get_tree().edited_scene_root
		print("Node added: %s" % tween.name)
	
	if not $Clock:
		clock = Timer.new()
		clock.name = "Clock"
		add_child(clock)
		clock.owner = get_tree().edited_scene_root
		print("Node added: %s" % clock.name)
		clock.wait_time = 0.3
	
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
