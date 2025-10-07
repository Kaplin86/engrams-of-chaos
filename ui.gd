extends Node2D
class_name uiManager
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer
	
	$CraftingUI.modulate = Color(1,1,1,0)
	$CraftingUI.visible = true
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
	
	
	for E in $SynergyHolder.get_children():
		E.queue_free()
	
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
			if remove_numbers_from_string(E.name) == synergyname:
				E.modulate = Color(3,3,3)
		var NewObject : BaseSynergy = load("res://synergyScripts/"+synergyname+".gd").new()
		var Description = NewObject.get_description($"../..".calculatesynergies(2).get(synergyname,0))
		$UnitUI.visible = false
		$SynergyUI.visible = true
		$Tutorial.visible = false
		$SynergyUI/Description.text = Description
		$Name.text = synergyname + " SYNERGY"
		$SynergyUI/SynergyIcon.texture = load("res://ui/elements/"+synergyname+".svg")

func modulateCraft(modulating):
	$GameManagingButtons/Craft.modulate = modulating

func highlightCrafting(synergyname : String):
	for E in $CraftingUI/SynergyHolder.get_children():
		E.modulate = Color(1,1,1)
		if remove_numbers_from_string(E.name) == synergyname:
			E.modulate = Color(3,3,3)


func highlightStartPause(craft = false, disable = false, deltatimer = 0):
	if !disable:
		if !craft:
			print(floor(deltatimer)," vs ",round(deltatimer))
			if floor(deltatimer * 2) == round(deltatimer * 2):
				$GameManagingButtons/Pause_Resume.color =  Color("b2b2b2")
			else:
				$GameManagingButtons/Pause_Resume.color =  Color("a9a9a9")
			$GameManagingButtons/Craft.color =  Color("636363")
		else:
			if floor(deltatimer * 2) == round(deltatimer * 2):
				$GameManagingButtons/Craft.color =  Color("b2b2b2")
			else:
				$GameManagingButtons/Craft.color =  Color("a9a9a9")
			$GameManagingButtons/Pause_Resume.color =  Color("636363")
	else:
		$GameManagingButtons/Pause_Resume.color = Color("636363")
		$GameManagingButtons/Craft.color = Color("636363")

func showCraftingUi(inventory : Dictionary,skiptween = false):
	if !skiptween:
		var coolTween = create_tween()
		
		coolTween.tween_property($CraftingUI,"modulate",Color(1,1,1,1),0.3)
		$AnimationPlayer.speed_scale = 1
	for E in $CraftingUI/SynergyHolder.get_children():
		E.queue_free()
	
	for E in inventory.keys():
		var NewRect =synergyRectScene.instantiate()
		NewRect.find_child("Image").texture = load("res://ui/elements/"+E+".svg")
		NewRect.find_child("Label").text = "x " + str(inventory[E])
		$CraftingUI/SynergyHolder.add_child(NewRect)
		NewRect.name = E
	
	$CraftingUI/LeftElement.position = Vector2(145,176)
	$CraftingUI/RightElement.position = Vector2(611,234)

func hideCraftingUI():
	var coolTween = create_tween()
	
	coolTween.tween_property($CraftingUI,"modulate",Color(1,1,1,0),0.3)

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
	elif currentstate == "Crafting":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
A/D - Choose synergy
S - Go Back
Z - Add Synergy
X - Remove Synergy
"
	elif currentstate == "CraftConfirm":
		$GameManagingButtons/RichTextLabel.text = "[b]Controls[/b]
A/D - Choose synergy
S - Go Back
Z - Confirm Fusion
X - Remove Synergy
"

func getColorOfImage(texture : Texture2D):
	var color := Vector3.ZERO
	var texture_size := texture.get_size()
	var image := texture.get_image()
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			var pixel := image.get_pixel(x, y)
			color += Vector3(pixel.r, pixel.g, pixel.b)
			
	color /= texture_size.x * texture_size.y

	return Color(color.x, color.y, color.z)



func updateCraftingUi(crafting : Array):
	
	var newTween = get_tree().create_tween()
	
	if crafting.size() == 0:
		$CraftingUI/LeftElement.visible = false
		$CraftingUI/RightElement.visible = false
		
		var tex : GradientTexture2D = $CraftingUI.texture
		var getGradient : Gradient = tex.gradient
		var newarray : PackedColorArray = PackedColorArray([Color(0,0,0),Color(0,0,0)])
		newTween.tween_property(getGradient,"colors",newarray,0.5)
		
	elif crafting.size() == 1:
		$CraftingUI/LeftElement.texture = load("res://ui/elements/"+crafting[0]+".svg")
		$CraftingUI/LeftElement.visible = true
		$CraftingUI/RightElement.visible = false
		
		var tex : GradientTexture2D = $CraftingUI.texture
		var getGradient : Gradient = tex.gradient
		
		var newarray : PackedColorArray = PackedColorArray([getColorOfImage($CraftingUI/LeftElement.texture),Color(0,0,0)])
		newTween.tween_property(getGradient,"colors",newarray,0.5)
		
		
	elif crafting.size() == 2:
		$CraftingUI/LeftElement.texture = load("res://ui/elements/"+crafting[0]+".svg")
		$CraftingUI/RightElement.texture = load("res://ui/elements/"+crafting[1]+".svg")
		$CraftingUI/LeftElement.visible = true
		$CraftingUI/RightElement.visible = true
		
		var tex : GradientTexture2D = $CraftingUI.texture
		var getGradient : Gradient = tex.gradient
		
		var newarray : PackedColorArray = PackedColorArray([getColorOfImage($CraftingUI/LeftElement.texture),getColorOfImage($CraftingUI/RightElement.texture)])
		newTween.tween_property(getGradient,"colors",newarray,0.5)

func showTutorial(roundnumber):
	$Tutorial.visible = true
	$UnitUI.visible = false
	$SynergyUI.visible = false
	$Name.text = "Current Wave: "+  str(roundnumber)

func runCraftAnim(NewFusion):
	$AnimationPlayer.play("craft")
	$CraftingUI/CraftedUnit.texture = load("res://units/"+NewFusion+"/"+NewFusion+".svg")
	await $AnimationPlayer.animation_finished
	craftAnimDone.emit()
	$CraftingUI/LeftElement.position = Vector2(145,176)
	$CraftingUI/RightElement.position = Vector2(611,234)
	$AnimationPlayer.speed_scale += 0.1

signal craftAnimDone

func remove_numbers_from_string(input_string: String) -> String:
	var result_string = ""
	for char in input_string:
		if not char.is_valid_int():
			result_string += char
	return result_string
