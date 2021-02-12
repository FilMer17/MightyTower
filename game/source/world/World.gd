extends Node2D

export var data: Resource = null

func _ready():
	GlobalData.scan()
