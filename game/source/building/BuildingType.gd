extends StaticBody2D
class_name BuildingType

enum GROUP { storage } # add more later

export var alias: String = ""

export var size := Vector2()
export var cost: Dictionary = {}
export var level: int = 1

export var levelup_cost: Dictionary = {}

export(GROUP) var group: int

onready var sprite := $Sprite
