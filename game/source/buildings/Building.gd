tool
extends StaticBody2D
class_name Building

enum TYPE { residence, storage, house }

export var alias: String = ""
export var size := Vector2()
export var cost: Dictionary = {}
export var level: int = 1
export var build_cld: Dictionary = { "day" : 0, "hour" : 0, "minute" : 0 }
export(TYPE) var type: int = TYPE.residence

onready var sprite := $Sprite
onready var collider := $Collider
onready var clock := $Clock
onready var cld_label := $CooldownLabel

var is_built: bool = false

func _ready() -> void:
	var __ = clock.connect("timeout", self, "_on_build_cooldown")
	clock.start()

func _on_build_cooldown() -> void:
	for key in build_cld.keys():
		if build_cld[key] == 0:
			var __ = build_cld.erase(key)
			if key == "minute":
				_building_is_built()
				return

	build_cld.minute -= 1
	if build_cld.minute == 0:
		if build_cld.keys().size() <= 1:
			_building_is_built()
			return
		else:
			build_cld.minute = 59
			build_cld.hour -= 1
			if build_cld.keys().has("day") and build_cld.hour <= 0:
				build_cld.day -= 1
				build_cld.hour = 24

	var output = []
	for key in build_cld.keys():
		if  build_cld.has(key):
			output.append(String(build_cld[key]))
	for i in range(0, build_cld.size()):
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
