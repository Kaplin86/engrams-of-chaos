extends Node


var CradleEngrams = ["sweet","spicy","sour","bitter","umami","salty","greed","game","symbol","creativity"]
var CradleBosses = ["rolling_pin","cutlery","whisk","echo"]
#var CradleBosses = ["echo","echo","echo"]

var SelectedCradleEngrams : Array[String] = []

var synergyUnitJson : Dictionary = {}
var craftingUnitJson : Dictionary = {}
var tutorial = false
var enemySynergy = true
var difficulty = "Easy"
var waveOfDeath = 0
var UnitTypesUsed = "All the units!!"
var highestSynergy = ""
var Mode = "kitchen"

var BossesDesc = {
	"cutlery":tr("cutlery_bossDesc"),
"rolling_pin":tr("rolling_ping_bossDesc"),
"whisk":"Get moving, Get groving, its shuffling time!",
"oven":"Don't let the heat cloud your mind, a unit each tick will get burnt alongside those in line.",
"fridge":"Brrr... So chilly! Each tick, half your team will be FROZEN.",
"blender":"The blades spin quickly! When this gets hit, the whole board gets shuffled. Any units near the blender after this gets hit!",
"plate_pile":"A stack of plates to the skies above. When the pile gets hit twice, the pile will crumble a bit and spawn a plate enemy.",
"trash_can":"30% of your team will betray you, when any enemy gets a kill they all benefit! Stop the rottening quick!",
"kettle":"All our food keeps blowing up! Every 5 ticks, a random ally blows up and the kettle heals from it.",

"echo":"Don't be too loud... The boss will turn into a random unit with 3 times stats."
}

func _ready() -> void:
	var file = FileAccess.open("res://datastore/synergyUnits.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	synergyUnitJson = JSON.new().parse_string(content)
	
	craftingUnitJson = JSON.new().parse_string(content) # THIS IS TEMP!! LATER DOWN THE LINE I WILL MAKE ITS OWN INDEPENDENT JSON
	
	print(getFusedUnit("umami","spicy"))
	TranslationServer.set_locale("ja")


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
	return "pepper"
