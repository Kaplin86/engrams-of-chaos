extends Node

var synergyTypes = ["spicy","umami"]

var synergyUnitJson : Dictionary = {}

func _ready() -> void:
	var file = FileAccess.open("res://datastore/synergyUnits.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	synergyUnitJson = JSON.new().parse_string(content)
