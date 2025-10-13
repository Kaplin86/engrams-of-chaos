extends Node2D
class_name CursorHandlerObject
var CurrentState = "StartPause"
var boardPosition : Vector2i
var unitTarget : BaseUnit
var synergyPoint = 0
var buttonPoint = "start"
var craftingSelected = 0

var PointerPos : Vector2
var PointerSize : Vector2

@export var main : gameManager
@export var ui : uiManager

var disabledInputs = []

signal FightButtonPressed
signal CraftingButtonSelected
signal CraftingButtonPressed
signal CraftingAnimFinished
signal ReturnFromCrafting
signal WentToBoard
signal PickUpUnit
signal DroppedUnit
signal SynergyView
signal ButtonPanelTargeted

func checkInputJustPressed(inputName):
	if Input.is_action_just_pressed(inputName):
		if disabledInputs.has(inputName):
			return false
		else:
			return true
	else:
		return false

var deltatimer = 0

var OutlineTexture1 = preload("res://ui/Outline.png")
var OutlineTexture2 = preload("res://ui/Outline2.png")
var LastPointerPos

func playuiSound():
	$Switch1.pitch_scale = 1 + randf_range(-0.1,0.1)
	$Switch1.play()
func _process(delta: float) -> void:
	deltatimer += delta
	if !main:
		return
	
	if LastPointerPos != PointerPos:
		LastPointerPos = PointerPos
		$PointerLayer/AnimationPlayer.stop()
		#$PointerLayer/AnimationPlayer.play("play")
	
	if main.engramInventory.size() != 0:
		ui.modulateCraft(Color(1,1,1,1))
	else:
		ui.modulateCraft(Color(0.1,0.1,0.1,1))
	
	if PointerPos:
		$PointerLayer/Holder/NinePatchRect.global_position -= ($PointerLayer/Holder/NinePatchRect.global_position - PointerPos + Vector2(0,0)) * 0.2
	if PointerSize:
		$PointerLayer/Holder/NinePatchRect.size -= ($PointerLayer/Holder/NinePatchRect.size - PointerSize + Vector2(0,0)) * 0.3
	if floor(deltatimer * 2) == round(deltatimer * 2):
		$PointerLayer/Holder/NinePatchRect.texture = OutlineTexture2
	else:
		$PointerLayer/Holder/NinePatchRect.texture = OutlineTexture1
	
	
	
	if CurrentState == "BoardUnit":
		var NewUnitList = getunitsSortedToX()
		
		if unitTarget == null:
			unitTarget = NewUnitList[0]
		else:
			ui.viewUnit(unitTarget)
			var actualPoint : Node2D = unitTarget.get_child(0) 
			PointerPos = actualPoint.get_global_transform_with_canvas().get_origin()
			PointerSize = actualPoint.get_global_transform_with_canvas().get_scale() * 16
			PointerPos -= PointerSize / 2
		if checkInputJustPressed("ui_left"):
			changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) - 1])
			playuiSound()
		if checkInputJustPressed("ui_right"):
			playuiSound()
			if NewUnitList.find(unitTarget) + 1 >= NewUnitList.size():
				changeUnitSelect(NewUnitList[0])
			else:
				changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) + 1])
		unitTarget.modulate = Color(3,3,3)
		if checkInputJustPressed("ui_down"):
			CurrentState = "SynergyView"
			synergyPoint = 0
			unitTarget.modulate = Color(1,1,1)
			SynergyView.emit()
		if checkInputJustPressed("ui_up"):
			CurrentState = "StartPause"
			buttonPoint = "start"
			unitTarget.modulate = Color(1,1,1)
			ButtonPanelTargeted.emit()
		if checkInputJustPressed("confirm") and unitTarget.team == 2:
			CurrentState = "PickingUpUnit"
			$MiscMenu.pitch_scale = 1 + randf_range(-0.05,0.05)
			$MiscMenu.play()
			PickUpUnit.emit()
			boardPosition = unitTarget.board_position
	
	elif CurrentState == "PickingUpUnit":
		boardPosition.x = clamp(boardPosition.x,2,12)
		boardPosition.y = clamp(boardPosition.y,12,14)
		unitTarget.board_position = boardPosition
		unitTarget.visualPosition = main.board.map_to_local(boardPosition)
		if checkInputJustPressed("ui_up"):
			boardPosition -= Vector2i(0,1)
			$Move.play()
		if checkInputJustPressed("ui_left"):
			boardPosition -= Vector2i(1,0)
			$Move.play()
		if checkInputJustPressed("ui_down"):
			boardPosition -= Vector2i(0,-1)
			$Move.play()
		if checkInputJustPressed("ui_right"):
			boardPosition -= Vector2i(-1,0)
			$Move.play()
		if checkInputJustPressed("confirm"):
			var ValidSpace = true
			for E in main.units:
				if E.board_position == boardPosition and E != unitTarget:
					ValidSpace = false
					break
			if ValidSpace:
				CurrentState = "BoardUnit"
				DroppedUnit.emit()
				$MiscMenu2.pitch_scale = 1 + randf_range(-0.05,0.05)
				$MiscMenu2.play()
		var actualPoint = unitTarget.get_child(0) 
		PointerPos = actualPoint.get_global_transform_with_canvas().get_origin()
		PointerSize = actualPoint.get_global_transform_with_canvas().get_scale() * 16
		PointerPos -= PointerSize / 2
	
	elif CurrentState == "SynergyView":
		var synergyList = ui.synergyList
		if checkInputJustPressed("ui_left"):
			synergyPoint -= 1
			synergyPoint = wrap(synergyPoint,0,synergyList.size())
		elif checkInputJustPressed("ui_right"):
			synergyPoint += 1
			synergyPoint = wrap(synergyPoint,0,synergyList.size())
		elif checkInputJustPressed("ui_up"):
			unitTarget = null
			CurrentState = "BoardUnit"
			playuiSound()
			ui.highlightSynergy("")
			return
		elif checkInputJustPressed("ui_down"):
			CurrentState = "StartPause"
			buttonPoint = "start"
			
			ui.highlightSynergy("")
			ButtonPanelTargeted.emit()
			return
		
		var selectedSynergy = synergyList[synergyPoint]
		ui.highlightSynergy(selectedSynergy)
		
		for E : ColorRect in ui.get_node("SynergyHolder").get_children():
			if ui.remove_numbers_from_string(E.name) == selectedSynergy:
				PointerPos = E.get_global_transform_with_canvas().get_origin()
				PointerSize =  E.size
	
	elif CurrentState == "StartPause":
		
		ui.showTutorial(main.currentWave)
		if buttonPoint == "start":
			ui.highlightStartPause(false,false,deltatimer)
			if ui.has_node("GameManagingButtons/Pause_Resume"):
				var ObjectInQuestion = ui.get_node("GameManagingButtons/Pause_Resume")
				PointerPos = ObjectInQuestion.get_global_transform_with_canvas().get_origin()
				PointerSize = ObjectInQuestion.size
		elif buttonPoint == "craft":
			if ui.has_node("GameManagingButtons/Craft"):
				var ObjectInQuestion = ui.get_node("GameManagingButtons/Craft")
				PointerPos = ObjectInQuestion.get_global_transform_with_canvas().get_origin()
				PointerSize = ObjectInQuestion.size
			ui.highlightStartPause(true,false,deltatimer)
		
		
		if checkInputJustPressed("ui_left") or checkInputJustPressed("ui_right"):
			if buttonPoint == "start":
				if main.engramInventory.size() != 0:
					buttonPoint = "craft"
					CraftingButtonSelected.emit()
			elif buttonPoint == "craft":
				buttonPoint = "start"
		
		if checkInputJustPressed("ui_up"):
			ui.highlightStartPause(false,true)
			CurrentState = "SynergyView"
			synergyPoint = 0
		elif checkInputJustPressed("ui_down"):
			ui.highlightStartPause(false,true)
			CurrentState = "BoardUnit"
			playuiSound()
			unitTarget = null
			WentToBoard.emit()
		if checkInputJustPressed("confirm"):
			if buttonPoint == "start":
				main.startButtonHit()
				FightButtonPressed.emit()
			elif buttonPoint == "craft":
				ui.showCraftingUi(main.engramInventory)
				craftingSelected = 0
				currentCrafting = []
				CurrentState = "Crafting"
				ui.updateCraftingUi(currentCrafting)
				CraftingButtonPressed.emit()
	elif CurrentState == "Crafting":
		var EngramsLeft = main.engramInventory.keys().size() != 0
		if EngramsLeft:
			ui.highlightCrafting(main.engramInventory.keys()[craftingSelected])
			for E in ui.get_node("CraftingUI/SynergyHolder").get_children():
				if ui.remove_numbers_from_string(E.name) == main.engramInventory.keys()[craftingSelected]:
					PointerPos = E.get_global_transform_with_canvas().get_origin()
					PointerSize =  E.size
		if checkInputJustPressed("ui_left") and EngramsLeft:
			craftingSelected -= 1
			craftingSelected = wrap(craftingSelected,0,main.engramInventory.size())
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("ui_right") and EngramsLeft:
			craftingSelected += 1
			craftingSelected = wrap(craftingSelected,0,main.engramInventory.size())
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("confirm") and EngramsLeft:
			if currentCrafting.size() != 2:
				if currentCrafting.has(main.engramInventory.keys()[craftingSelected]):
					if main.engramInventory[main.engramInventory.keys()[craftingSelected]] != 1:
						currentCrafting.append(main.engramInventory.keys()[craftingSelected])
				else:
					currentCrafting.append(main.engramInventory.keys()[craftingSelected])
			
				ui.updateCraftingUi(currentCrafting)
			else:
				craftingSelected = 0
				
				
				for E in currentCrafting:
					main.engramInventory[E] -= 1
					if main.engramInventory[E] == 0:
						main.engramInventory.erase(E)
				ui.showCraftingUi(main.engramInventory,true)
				var NewFusion = DatastoreHolder.getFusedUnit(currentCrafting[0],currentCrafting[1])
				currentCrafting = []
				CurrentState = "CraftingAnim"
				ui.runCraftAnim(NewFusion)
				
				if !main.isPlayerBoardFull():
					main.spawnUnit(NewFusion,main.getFirstOpenPlayerBoardPosition(),2)
					ui.visualizeSynergy(main.calculatesynergies(2))
				
				await ui.craftAnimDone
				CurrentState = "Crafting"
				ui.updateCraftingUi(currentCrafting)
				CraftingAnimFinished.emit()
			
		elif checkInputJustPressed("deny") and EngramsLeft:
			currentCrafting.pop_back()
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("ui_down"):
			ui.hideCraftingUI()
			CurrentState = "StartPause"
			ReturnFromCrafting.emit()
			
	elif CurrentState == "CraftingAnim":
		pass
		#print("h")
	
	
	if currentCrafting.size() == 2:
		ui.currentControlState("CraftConfirm")
	else:
		ui.currentControlState(CurrentState)

var currentCrafting = []

func getunitsSortedToX():
	var newUnitsList = main.units.duplicate()
	newUnitsList.sort_custom(sortX)
	return newUnitsList


func sortX(a, b):
	return a.get_child(0).global_position.x < b.get_child(0).global_position.x

func changeUnitSelect(newUnit : BaseUnit):
	unitTarget.modulate = Color(1,1,1)
	unitTarget = newUnit
	if unitTarget and ui:
		ui.viewUnit(unitTarget)
