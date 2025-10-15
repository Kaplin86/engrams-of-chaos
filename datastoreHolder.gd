extends Node


var synergyUnitJson : Dictionary = {}
var craftingUnitJson : Dictionary = {}
var tutorial = false
var enemySynergy = true
var difficulty = "Easy"
var waveOfDeath = 0
var UnitTypesUsed = "All the units!!"
var highestSynergy = ""

var BossesDesc = {"cutlery":"A 3 in 1 combo! Prepare for mass destruction!","rolling_pin":"Half of your team shall return to dough...","whisk":"Get moving, Get groving, its shuffling time!","oven":"Don't let the heat cloud your mind, a unit each tick will get burnt alongside those in line.","fridge":"Brrr... So chilly! Each tick, half your team will be FROZEN.","blender":"The blades spin quickly! When this gets hit, the whole board gets shuffled. Any units near the blender after this gets hit!"}

func _ready() -> void:
	var file = FileAccess.open("res://datastore/synergyUnits.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	synergyUnitJson = JSON.new().parse_string(content)
	
	craftingUnitJson = JSON.new().parse_string(content) # THIS IS TEMP!! LATER DOWN THE LINE I WILL MAKE ITS OWN INDEPENDENT JSON
	
	print(getFusedUnit("umami","spicy"))


func getFusedUnit(element1,element2):
	for unit in craftingUnitJson:
		print("Attempting craft of ", element1, element2, " checking ", unit)
		var parseJson = craftingUnitJson.get(unit,[]).duplicate()
		if parseJson.has(element1):
			print(unit, " has element ", element1)
			parseJson.erase(element1)
			print("checking if unit has ", element2, " in ", parseJson)
			if parseJson.has(element2):
				return unit
