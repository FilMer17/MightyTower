extends Resource
class_name BuildingTData

enum TYPE { storage, residence, house }

export var position := Vector2()
export var size := Vector2()
export var alias: String = ""
export var level: int = 1
export var cost: Dictionary = {}
export(TYPE) var type: int = 0
