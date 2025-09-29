extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer
	
	await get_tree().create_timer(8).timeout
	$DEARPLAYTESTERS.visible = false

var synergyRectScene = preload("res://ui/synergy_rect.tscn")

func viewUnit(unit : BaseUnit):
	$UnitUI.visible = true
	$SynergyUI.visible = false
	$Tutorial.visible = false
	
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
		$Tutorial.visible = false
		$SynergyUI/Description.text = Description
		$Name.text = synergyname + " SYNERGY"
		$SynergyUI/SynergyIcon.texture = load("res://ui/elements/"+synergyname+".svg")

func highlightStartPause(craft = false, disable = false):
	
	if !disable:
		if !craft:
			$GameManagingButtons/Pause_Resume.color =  Color("b2b2b2")
			$GameManagingButtons/Craft.color =  Color("636363")
		else:
			$GameManagingButtons/Craft.color =  Color("b2b2b2")
			$GameManagingButtons/Pause_Resume.color =  Color("636363")
	else:
		$GameManagingButtons/Pause_Resume.color = Color("636363")
		$GameManagingButtons/Craft.color = Color("636363")

func showCraftingUi():
	var coolTween = create_tween()
	coolTween.tween_property($CraftingUI,"modulate",Color(1,1,1,1),0.3)
	

func textUpdateStartButton(newtext : String):
	$GameManagingButtons/Pause_Resume/Label.text = newtext

func currentControlState(currentstate : String):
	if currentstate == "BoardUnit":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
W - Button Selection
A/D - Choose Unit
S - Synergy Selection
Z to select
"
	elif currentstate == "SynergyView":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
W - Unit Selection
A/D - Choose synergy
S - Button Selection
"
	elif currentstate == "StartPause":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
W - Synergy Selection
A/D - Choose Button
S - Unit Selection
Z to select
"

func showTutorial(roundnumber):
	$Tutorial.visible = true
	$UnitUI.visible = false
	$SynergyUI.visible = false
	$Name.text = "Current Wave: "+  str(roundnumber)
