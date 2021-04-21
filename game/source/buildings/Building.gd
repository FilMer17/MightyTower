tool
extends StaticBody2D
class_name Building

onready var cooldown_bar_scene := preload("res://ui/bar/CooldownBar.tscn")
onready var building_info := preload("res://ui/popup/PopupBuildingInfo.gd")

enum TYPE { residence, storage, house, worker, maker, tower }
enum BUILD_TERRAIN { grass, sand, stone, water }

export var alias: String = ""
export var node_name: String = ""
export var size := Vector2(1, 1)
export var cost: Dictionary = {}
export var level: int = 1
export var cooldown: Dictionary = { "day" : 0, "hour" : 0, "minute" : 1 }
export(TYPE) var type: int = TYPE.residence
export(BUILD_TERRAIN) var build_terrain: int = BUILD_TERRAIN.grass

onready var buildings := Scene.search("Buildings")
onready var building_overview := Scene.search("BuildingOverview")

onready var build_cont := $BuildingContainer
onready var sprite := $BuildingContainer/Sprite as Sprite
onready var clock := $BuildingContainer/Clock as Timer
onready var tween := $BuildingContainer/Tween as Tween
onready var gui_container := $BuildingContainer/GUIContainer as Node2D
onready var collider := $Collider as CollisionPolygon2D

var cld_bar = null
var progress = null

var is_built: bool = false
var is_hovered: bool = false
var is_loaded: bool = false

var cld_temp: Dictionary = {}
var cld_all_min: int = 0
var cld_all_min_temp: int = 0

func _ready() -> void:
	var __
	
	sprite.material = load("res://graphics/shader/BuildingMaterial.tres").duplicate()
	
	input_pickable = true
	__ = connect("mouse_entered", self, "_on_Mouse_entered")
	__ = connect("mouse_exited", self, "_on_Mouse_exited")
	
	if buildings.states.has(position):
		_load_building_with_state()
		return
	
	if not is_loaded:
		var cld_bar_scene = cooldown_bar_scene.instance()
		cld_bar_scene.margin_left = (cld_bar_scene.margin_left / 4)
		cld_bar_scene.margin_right = (cld_bar_scene.margin_right / 4)
		cld_bar_scene.margin_top = (cld_bar_scene.margin_top / 6)
		cld_bar_scene.margin_bottom = (cld_bar_scene.margin_bottom / 6)

		gui_container.add_child(cld_bar_scene)
		
		gui_container.position = build_cont.get_node("Sprite").position
		
		cld_bar = gui_container.get_node("CooldownBar")
		progress = cld_bar.get_node("Progress")
		
		var font = cld_bar.get_node("Countdown").get("custom_fonts/font")
		font.size = 10
		cld_bar.get_node("Countdown").text = ""
		
		cld_temp = cooldown.duplicate()
		
		for i in range(0, 3):
			match i:
				0:
					cld_all_min += cld_temp["day"] * 60 * 24
				1:
					cld_all_min += cld_temp["hour"] * 60
				2:
					cld_all_min += cld_temp["minute"]
		
		if Scene.search("Buildings").get_child_count() <= 1:
			cld_all_min = 1
			cld_temp["day"] = 0
			cld_temp["hour"] = 0
			cld_temp["minute"] = 1
		
		cld_all_min_temp = cld_all_min
		
		progress.max_value = cld_all_min
		progress.value = cld_all_min
		
		buildings.states[position] = {
			"type" : type,
			"state" : "building",
			"time" : cld_temp
		}
		
		__ = clock.connect("timeout", self, "_on_build_cooldown")
		clock.start()

func _load_building_with_state() -> void:
	match buildings.states[position].state:
		"building":
			var cld_bar_scene = cooldown_bar_scene.instance()
			cld_bar_scene.margin_left = (cld_bar_scene.margin_left / 4)
			cld_bar_scene.margin_right = (cld_bar_scene.margin_right / 4)
			cld_bar_scene.margin_top = (cld_bar_scene.margin_top / 6)
			cld_bar_scene.margin_bottom = (cld_bar_scene.margin_bottom / 6)

			gui_container.add_child(cld_bar_scene)
			
			gui_container.position = build_cont.get_node("Sprite").position
			
			cld_bar = gui_container.get_node("CooldownBar")
			progress = cld_bar.get_node("Progress")
			
			var font = cld_bar.get_node("Countdown").get("custom_fonts/font")
			font.size = 10
			cld_bar.get_node("Countdown").text = ""
			
			cld_temp = buildings.states[position].time
			
			cld_all_min = cooldown_to_minutes(cld_temp)
			
			cld_all_min_temp = cld_all_min
			
			progress.max_value = cooldown_to_minutes(cooldown.duplicate())
			progress.value = cld_all_min
			
			var __ = clock.connect("timeout", self, "_on_build_cooldown")
			clock.start()

func cooldown_to_minutes(cldown: Dictionary) -> int:
	var in_mins := 0
	for i in range(0, 3):
		match i:
			0:
				if cldown.has("day"):
					in_mins += cldown["day"] * 60 * 24
			1:
				if cldown.has("hour"):
					in_mins += cldown["hour"] * 60
			2:
				if cldown.has("minute"):
					in_mins += cldown["minute"]
	return in_mins

func _on_build_cooldown() -> void:
	for key in cld_temp.keys():
		if cld_temp[key] == 0:
			var __ = cld_temp.erase(key)
			if key == "minute":
				_building_is_built()
				return

	cld_temp.minute -= 1
	if cld_temp.minute == 0:
		if cld_temp.keys().size() <= 1:
			_building_is_built()
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
		if str(output[i]).length() <= 2:
			output[i] = "0" + String(output[i])
	countdown.text = PoolStringArray(output).join(":")
	
	buildings.states[position].time = cld_temp
	
	cld_all_min_temp -= 1
	_on_cooldown_changed(cld_all_min_temp)

func _building_is_built() -> void:
	clock.stop()
	print(alias, " was build")
	Scene.search("Console").write(alias + " was build")
	is_built = true
	buildings.data[position].is_built = true
	buildings.states.erase(position)
	cld_bar.visible = false

func _on_cooldown_changed(value: int) -> void:
	var __
	__ = tween.stop(progress, "value")
	__ = tween.interpolate_property(progress, "value", cld_all_min_temp, value, 0.3, Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = tween.start()

func _on_Mouse_entered() -> void:
	if not Scene.search("Map").in_builder:
		sprite.material.set_shader_param("is_hovered", true)
		is_hovered = true
		_change_building_overview()

func _on_Mouse_exited() -> void:
	sprite.material.set_shader_param("is_hovered", false)
	is_hovered = false
	building_overview.clear_items()

func _change_building_overview() -> void:
	pass

func _change_buy_option() -> void:
	pass

func _enter_tree():
	if not $BuildingContainer:
		build_cont = Node2D.new()
		build_cont.name = "BuildingContainer"
		add_child(build_cont)
		build_cont.owner = get_tree().edited_scene_root
		print("Node added: %s" % build_cont.name)

	if not $BuildingContainer/Tween:
		tween = Tween.new()
		tween.name = "Tween"
		get_node("BuildingContainer").add_child(tween)
		tween.owner = get_tree().edited_scene_root
		print("Node added: %s" % tween.name)

	if not $BuildingContainer/Clock:
		clock = Timer.new()
		clock.name = "Clock"
		get_node("BuildingContainer").add_child(clock)
		clock.owner = get_tree().edited_scene_root
		print("Node added: %s" % clock.name)
		clock.wait_time = 0.3

	if not $BuildingContainer/Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		get_node("BuildingContainer").add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)

	if not $BuildingContainer/GUIContainer:
		gui_container = Node2D.new()
		gui_container.name = "GUIContainer"
		get_node("BuildingContainer").add_child(gui_container)
		gui_container.owner = get_tree().edited_scene_root
		print("Node added: %s" % gui_container.name)

	if not $Collider:
		collider = CollisionPolygon2D.new()
		collider.name = "Collider"
		add_child(collider)
		collider.owner = get_tree().edited_scene_root
		print("Node added: %s" % collider.name)
