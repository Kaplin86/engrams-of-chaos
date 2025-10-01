extends Node

var synergyTypes = ["spicy","umami"]

var synergyUnitJson : Dictionary = {}
var craftingUnitJson : Dictionary = {}

func _ready() -> void:
	var file = FileAccess.open("res://datastore/synergyUnits.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	synergyUnitJson = JSON.new().parse_string(content)
	
	craftingUnitJson = JSON.new().parse_string(content) # THIS IS TEMP!! LATER DOWN THE LINE I WILL MAKE ITS OWN INDEPENDENT JSON
	
	print(getFusedUnit("umami","spicy"))


func getFusedUnit(element1,element2):
	for unit in craftingUnitJson:
		if craftingUnitJson.get(unit,[]).has(element1):
			if craftingUnitJson.get(unit,[]).has(element2):
				return unit
