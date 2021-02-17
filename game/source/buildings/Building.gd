tool
extends StaticBody2D
class_name Building

enum TYPE { residence, storage, house }

export var alias: String = ""
export var size := Vector2()
export var cost: Dictionary = {}
export var level: int = 1
export var cooldown: Dictionary = { "day" : 0, "hour" : 0, "minute" : 0}
export(TYPE) var type: int = TYPE.residence

onready var sprite := $Sprite
onready var collider := $Collider

var is_placed: bool = false

func _enter_tree():
	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)
	
	if not $Collider:
		collider = CollisionPolygon2D.new()
		collider.name = "Collider"
		add_child(collider)
		collider.owner = get_tree().edited_scene_root
		print("Node added: %s" % collider.name)
