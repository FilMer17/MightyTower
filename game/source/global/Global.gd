extends Node

var selected_world: WorldData = null

# helping function (remove in future)
func _ready() -> void:
	selected_world = WorldData.new(WorldData.DIFFICULTY.easy, "game1", MapData.MAP_SIZE.m)
