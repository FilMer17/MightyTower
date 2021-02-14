tool
extends Building
class_name Storage

enum USAGE { food, material, ore }

export var capacity: int = 0
export(USAGE) var usage: int = USAGE.food
