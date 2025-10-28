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
"rolling_pin":tr("rolling_pin_bossDesc"),
"whisk":tr("whisk_bossDesc"),
"oven":tr("oven_bossDesc"),
"fridge":tr("fridge_bossDesc"),
"blender":tr("blender_bossDesc"),
"plate_pile":tr("plate_pile_bossDesc"),
"trash_can":tr("trash_can_bossDesc"),
"kettle":tr("kettle_bossDesc"),

"echo":tr("echo_bossDesc")
}

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
	return "pepper"
