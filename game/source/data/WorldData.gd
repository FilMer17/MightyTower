extends Resource
class_name WorldData

enum DIFFICULTY { easy, medium, hard }

export var alias: String = ""
export var settings: Resource = null
export var resources: Resource = null
export var map: Resource = null

export(DIFFICULTY) var difficulty = DIFFICULTY.easy
