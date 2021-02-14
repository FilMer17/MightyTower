tool
extends StaticBody2D
class_name Entity

enum TYPE { stone, tree }

export var level: int = 1
export(TYPE) var type: int = TYPE.stone

onready var sprite := $Sprite
onready var collider := $Collider

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
