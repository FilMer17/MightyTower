extends Node2D

onready var popup_place_menu := preload("res://ui/popup/PopupPlaceMenu.tscn")

onready var sprite := $Sprite
onready var grid := IsoGrid.new()
onready var buildings := get_parent().get_node("Buildings")

var in_menu: bool = false
var building: Building = null

func build(b_name: String) -> void:
	sprite.visible = true
	building = GlobalData.buildings[b_name].instance()
	sprite.texture = building.get_node("Sprite").texture

func _physics_process(_delta):
	if sprite.visible and !in_menu:
		sprite.position = grid.map_to_world(grid.world_to_map(get_global_mouse_position()))

func _input(event):
	if event.is_action_pressed("place_building") and sprite.visible:
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
		sprite.visible = false
#		buildings.place_building(building.name)
		building = null

	_clear_menu_container()
	in_menu = false

func _clear_menu_container() -> void:
	for menu in $MenuContainer.get_children():
		menu.queue_free()
