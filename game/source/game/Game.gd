extends Node2D

var world: GameWorld = null

onready var world_container := $WorldContainer
onready var world_filter := $WorldFilter/Shader
onready var game_ui := $GameUI
onready var camera := $Camera

onready var world_scene: PackedScene = load("res://source/world/GameWorld.tscn")

func _ready() -> void:
	_load_world()

func _load_world() -> void:
	world = world_scene.instance()
	world_container.add_child(world)
	pass
