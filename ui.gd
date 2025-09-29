extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer

var synergyRectScene = preload("res://ui/synergy_rect.tscn")

func viewUnit(unit : BaseUnit):
	$UnitUI.visible = true
	$SynergyUI.visible = false
	
	$UnitUI/Damage.text = str(unit.damage)
	$UnitUI/Defense.text = str(unit.defense)
	$UnitUI/Health.text = str(unit.hp)
	$UnitUI/UnitSelectedImage.texture = load("res://units/"+unit.type+"/" +unit.type+ ".svg")
	$UnitUI/Description.text = unit.description
	
	if unit.team != 2:
		$Name.text = "ENEMY " + unit.type.replace("_"," ")
	else:
		$Name.text = unit.type.replace("_"," ")
	
	for E in $UnitUI/Synergies.get_children():
		E.queue_free()
	
	for E in DatastoreHolder.synergyUnitJson[unit.type]:
		var NewImage = TextureRect.new()
		NewImage.texture = load("res://ui/elements/"+E+".svg")
		$UnitUI/Synergies.add_child(NewImage)
	
	



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
	if synergyname == "":
		for E in $SynergyHolder.get_children():
			E.modulate = Color(1,1,1)
	else:
		for E in $SynergyHolder.get_children():
			E.modulate = Color(1,1,1)
			if E.name == synergyname:
				E.modulate = Color(3,3,3)
		var NewObject : BaseSynergy = load("res://synergyScripts/"+synergyname+".gd").new()
		var Description = NewObject.get_description($"../..".calculatesynergies(2)[synergyname])
		$UnitUI.visible = false
		$SynergyUI.visible = true
		$SynergyUI/Description.text = Description
		$Name.text = synergyname + " SYNERGY"
		$SynergyUI/SynergyIcon.texture = load("res://ui/elements/"+synergyname+".svg")

func highlightStartPause(disable = false):
	if !disable:
		$GameManagingButtons/Pause_Resume.color =  Color("b2b2b2")
	else:
		$GameManagingButtons/Pause_Resume.color = Color("636363")

func textUpdateStartButton(newtext : String):
	$GameManagingButtons/Pause_Resume/Label.text = newtext

func currentControlState(currentstate : String):
	if currentstate == "BoardUnit":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
↑ - Button Selection
←/→ - Choose Unit
↓ - Synergy Selection
Z to select
"
	elif currentstate == "SynergyView":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
↑ - Unit Selection
←/→ - Choose synergy
↓ - Button Selection
"
	elif currentstate == "StartPause":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
↑ - Synergy Selection
←/→ - Choose Button
↓ - Unit Selection
Z to select
"
