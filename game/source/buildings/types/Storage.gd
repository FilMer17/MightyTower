tool
extends StaticBody2D
class_name Storage

export var data: Resource = null

onready var sprite := $Sprite
onready var collision := $Collision

func _enter_tree():
	if not Engine.editor_hint:
		return
	
	if not $Sprite:
		sprite = Sprite.new()
		sprite.name = "Sprite"
		add_child(sprite)
		sprite.owner = get_tree().edited_scene_root
		print("Node added: %s" % sprite.name)
	
	if not $Collision:
		collision = CollisionPolygon2D.new()
		collision.name = "Collision"
		add_child(collision)
		collision.owner = get_tree().edited_scene_root
		print("Node added: %s" % collision.name)
