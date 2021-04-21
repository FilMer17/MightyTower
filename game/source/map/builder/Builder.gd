extends Node2D

# warning-ignore:unused_signal
signal entered_build_area
# warning-ignore:unused_signal
signal exited_build_area

export(Color, RGBA) var right_color := Color.white
export(Color, RGBA) var wrong_color := Color.black

onready var popup_place_menu := preload("res://ui/popup/PopupPlaceMenu.tscn")

onready var sprite := $Sprite
onready var area := $Area
onready var area_zone := $Area/Zone

onready var grid := IsoGrid.new()
onready var map := Scene.search("Map")
onready var buildings := Scene.search("Buildings")
onready var terrain := Scene.search("Terrain")

var in_menu: bool = false
var is_right_color: bool = false
var building: Building = null
var det_areas: Array = []
var const_zone_pos: Array
var move_pos := 0

func _ready() -> void:
	var __
	__ = connect("entered_build_area", self, "_in_Area")
	__ = connect("exited_build_area", self, "_out_Area")
	
	const_zone_pos = area_zone.polygon

func build(b_name: String) -> void:
	building = GlobalData.buildings[b_name].instance()
	var building_sprite = building.get_node("BuildingContainer").get_node("Sprite")
	sprite.texture = building_sprite.texture
	sprite.position = building_sprite.position
	sprite.scale = building_sprite.scale
	
	for i in range(0, 4):
		area_zone.polygon[i] = const_zone_pos[i] * building.size
	
	map.in_builder = true
	sprite.visible = true
	area_zone.disabled = false

func _physics_process(_delta):
	if sprite.visible and !in_menu:
		if building.size.y < 3:
			move_pos = 0
		else:
			move_pos = -int((building.size.y - (building.size.y / 2)))
		
		position = grid.map_to_world(grid.world_to_map(get_global_mouse_position()) + Vector2(move_pos, move_pos))
		var map_pos := grid.world_to_map(get_global_mouse_position())
		if _check_placeable(map_pos + Vector2(move_pos, move_pos)):
			is_right_color = true
			sprite.material.set_shader_param("current_color", right_color)
		else:
			is_right_color = false
			sprite.material.set_shader_param("current_color", wrong_color)

func _input(event):
	if event.is_action_pressed("select_option") and sprite.visible and is_right_color:
		if $MenuContainer.get_child_count() > 0:
			_clear_menu_container()
			in_menu = false
		else:
			in_menu = true
			var menu = popup_place_menu.instance()
			menu.rect_position = position + Vector2(-36, -36)
			$MenuContainer.add_child(menu)
	
	if event.is_action_pressed("cancel_action") and sprite.visible:
		if not buildings.get_child_count() <= 0:
			_clear_menu_container()
			map.in_builder = false
			in_menu = false
			sprite.visible = false
			area_zone.disabled = true
			building.queue_free()
			building = null

func _place_building(to_build: bool) -> void:
	if to_build:
		var pos = grid.map_to_world(grid.world_to_map(position))
		if buildings.place_building(building, pos):
			var b_pos = grid.world_to_map(position)
			var terrains := []
			for x in range(0, building.size.x):
				for y in range(0, building.size.y):
					terrains.append(b_pos + Vector2(x, y))
			
			for terr in terrains:
				terrain.data[terr]["placed"] = building.name
			
			map.in_builder = false
			area_zone.disabled = true
			sprite.visible = false
			building = null

	_clear_menu_container()
	in_menu = false

func _clear_menu_container() -> void:
	for menu in $MenuContainer.get_children():
		menu.queue_free()

func _check_placeable(pos: Vector2) -> bool:
	var terrains := []
	for x in range(0, building.size.x):
		for y in range(0, building.size.y):
			terrains.append(pos + Vector2(x, y))
	
	for terr in terrains:
		if terrain.data.has(terr):
			if not terrain.data[terr]["terrain"] == building.build_terrain:
				return false
			elif not terrain.data[terr]["placed"] == "":
				return false
			elif det_areas.empty():
				if not buildings.get_child_count() <= 0:
					return false
		else:
			return false
	
	return true

func _in_Area() -> void:
	det_areas.append("area")

func _out_Area() -> void:
	det_areas.pop_back()
