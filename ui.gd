extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer

var synergyRectScene = preload("res://ui/synergy_rect.tscn")

func viewUnit(unit : BaseUnit):
	$Damage.text = str(unit.damage)
	$Defense.text = str(unit.defense)
	$Health.text = str(unit.maxHP)
	$UnitSelectedImage.texture = load("res://units/"+unit.type+"/" +unit.type+ ".svg")
	$Description.text = unit.description
	
	if unit.team != 2:
		$Name.text = "ENEMY " + unit.type.replace("_"," ")
	else:
		$Name.text = unit.type.replace("_"," ")
	
	for E in $Synergies.get_children():
		E.queue_free()
	
	for E in DatastoreHolder.synergyUnitJson[unit.type]:
		var NewImage = TextureRect.new()
		NewImage.texture = load("res://ui/elements/"+E+".svg")
		$Synergies.add_child(NewImage)


var visualizesynergyholder
var synergyList
func visualizeSynergy(synergyDictionary : Dictionary):
	var SynergyNames = synergyDictionary.keys()
	visualizesynergyholder = synergyDictionary
	SynergyNames.sort_custom(sortSynergy)
	
	
	
	
	for E in SynergyNames:
		var NewRect =synergyRectScene.instantiate()
		NewRect.find_child("Image").texture = load("res://ui/elements/"+E+".svg")
		NewRect.find_child("Label").text = "x " + str(synergyDictionary[E])
		$SynergyHolder.add_child(NewRect)
		NewRect.name = E
	synergyList = SynergyNames

func sortSynergy(a, b):
	return visualizesynergyholder[a] > visualizesynergyholder[b]

func highlightSynergy(synergyname : String):
	for E in $SynergyHolder.get_children():
		E.modulate = Color(1,1,1)
		if E.name == synergyname:
			E.modulate = Color(3,3,3)
