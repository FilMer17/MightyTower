tool
extends StaticBody2D
class_name Building

enum TYPE { residence, storage, house }

export var alias: String = ""
export var size := Vector2()
export var cost: Dictionary = {}
export var level: int = 1
export var cooldown: Dictionary = { "day" : 0, "hour" : 0, "minute" : 0 }
export(TYPE) var type: int = TYPE.residence

onready var sprite := $Sprite
onready var collider := $Collider
onready var clock := $Clock
onready var cld_label := $CooldownLabel

var is_built: bool = false
var cld_temp: Dictionary = {}

func _ready() -> void:
	cld_temp = cooldown.duplicate()
	var __ = clock.connect("timeout", self, "_on_build_cooldown")
	clock.start()

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
	for key in cld_temp.keys():
		if  cld_temp.has(key):
			output.append(String(cld_temp[key]))
	for i in range(0, cld_temp.size()):
		if str(output[i]).length() == 1:
			output[i] = "0" + String(output[i])
	cld_label.text = PoolStringArray(output).join(":")

func _building_is_built() -> void:
	clock.stop()
	print(alias, " was build")
	is_built = true
	cld_label.text = ""


func _set_max_amount() -> void:
	pass

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

	if not $Clock:
		clock = Timer.new()
		clock.name = "Clock"
		add_child(clock)
		clock.owner = get_tree().edited_scene_root
		print("Node added: %s" % clock.name)
		clock.wait_time = 0.3

	if not $CooldownLabel:
		cld_label = Label.new()
		cld_label.name = "CooldownLabel"
		add_child(cld_label)
		cld_label.owner = get_tree().edited_scene_root
		print("Node added: %s" % cld_label.name)
