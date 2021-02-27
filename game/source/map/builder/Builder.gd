extends Node2D

export(Color, RGBA) var right_color := Color.white
export(Color, RGBA) var wrong_color := Color.black

onready var popup_place_menu := preload("res://ui/popup/PopupPlaceMenu.tscn")

onready var sprite := $Sprite
onready var grid := IsoGrid.new()
onready var buildings := get_parent().get_node("Buildings")
onready var terrain := get_parent().get_node("Terrain")

var in_menu: bool = false
var is_right_color: bool = false
var building: Building = null

func build(b_name: String) -> void:
	building = GlobalData.buildings[b_name].instance()
	sprite.texture = building.get_node("Sprite").texture
	sprite.visible = true

func _physics_process(_delta):
	if sprite.visible and !in_menu:
		sprite.position = grid.map_to_world(grid.world_to_map(get_global_mouse_position()))
		var map_pos := grid.world_to_map(get_global_mouse_position())
		if _check_placeable(map_pos):
			is_right_color = true
			sprite.material.set_shader_param("current_color", right_color)
		else:
			is_right_color = false
			sprite.material.set_shader_param("current_color", wrong_color)

func _input(event):
	if event.is_action_pressed("place_building") and sprite.visible and is_right_color:
		if $MenuContainer.get_child_count() > 0:
			_clear_menu_container()
			in_menu = false
		else:
			in_menu = true
			var menu = popup_place_menu.instance()
			menu.rect_position = sprite.position + Vector2(30, -30)
			$MenuContainer.add_child(menu)

func _place_building(to_build: bool) -> void:
	if to_build:
		var pos = grid.map_to_world(grid.world_to_map(sprite.position))
		if buildings.place_building(building.name, pos):
			var terrdir = IsoGrid.NEIGHBOR_TABLE
			var b_pos = grid.world_to_map(sprite.position)
			var terrains := [b_pos]
			for i in range(1, building.size.x):
				for j in range(3, 6):
					terrains.append(b_pos + terrdir[j] * i)
			
			for terr in terrains:
				terrain.data[terr]["placed"] = building.name
			
			sprite.visible = false
			building = null

	_clear_menu_container()
	in_menu = false

func _clear_menu_container() -> void:
	for menu in $MenuContainer.get_children():
		menu.queue_free()

func _check_placeable(pos: Vector2) -> bool:
	var terrdir = IsoGrid.NEIGHBOR_TABLE
	var terrains := [pos]
	for i in range(1, building.size.x):
		for j in range(3, 6):
			terrains.append(pos + terrdir[j] * i)
	
	for terr in terrains:
		if terrain.data.has(terr):
			if not terrain.data[terr]["terrain"] == terrain.TERRAINS.grass:
				return false
			elif not terrain.data[terr]["placed"] == "":
				return false
		else:
			return false
	
	return true
