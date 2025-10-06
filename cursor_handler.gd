extends Node2D
class_name CursorHandlerObject
var CurrentState = "StartPause"
var boardPosition : Vector2i
var unitTarget : BaseUnit
var synergyPoint = 0
var buttonPoint = "start"
var craftingSelected = 0

@export var main : gameManager
@export var ui : uiManager

var disabledInputs = []

signal FightButtonPressed
signal CraftingButtonSelected
signal CraftingButtonPressed

func checkInputJustPressed(inputName):
	if Input.is_action_just_pressed(inputName):
		if disabledInputs.has(inputName):
			return false
		else:
			return true
	else:
		return false

func _process(delta: float) -> void:
	if !main:
		return
	
	if main.engramInventory.size() != 0:
		ui.modulateCraft(Color(1,1,1,1))
	else:
		ui.modulateCraft(Color(0.1,0.1,0.1,1))
	
	if CurrentState == "BoardUnit":
		var NewUnitList = getunitsSortedToX()
		
		if unitTarget == null:
			unitTarget = NewUnitList[0]
		else:
			ui.viewUnit(unitTarget)
		if checkInputJustPressed("ui_left"):
			changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) - 1])
		if checkInputJustPressed("ui_right"):
			if NewUnitList.find(unitTarget) + 1 >= NewUnitList.size():
				changeUnitSelect(NewUnitList[0])
			else:
				changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) + 1])
		unitTarget.modulate = Color(3,3,3)
		if checkInputJustPressed("ui_down"):
			CurrentState = "SynergyView"
			synergyPoint = 0
			unitTarget.modulate = Color(1,1,1)
		if checkInputJustPressed("ui_up"):
			CurrentState = "StartPause"
			buttonPoint = "start"
			unitTarget.modulate = Color(1,1,1)
		if checkInputJustPressed("confirm") and unitTarget.team == 2:
			CurrentState = "PickingUpUnit"
			boardPosition = unitTarget.board_position
	
	elif CurrentState == "PickingUpUnit":
		boardPosition.x = clamp(boardPosition.x,2,12)
		boardPosition.y = clamp(boardPosition.y,12,15)
		print(boardPosition.y)
		unitTarget.board_position = boardPosition
		unitTarget.visualPosition = main.board.map_to_local(boardPosition)
		if checkInputJustPressed("ui_up"):
			boardPosition -= Vector2i(0,1)
		if checkInputJustPressed("ui_left"):
			boardPosition -= Vector2i(1,0)
		if checkInputJustPressed("ui_down"):
			boardPosition -= Vector2i(0,-1)
		if checkInputJustPressed("ui_right"):
			boardPosition -= Vector2i(-1,0)
		if checkInputJustPressed("confirm"):
			var ValidSpace = true
			for E in main.units:
				if E.board_position == boardPosition and E != unitTarget:
					ValidSpace = false
					break
			if ValidSpace:
				CurrentState = "BoardUnit"
	
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
			ui.highlightSynergy("")
			return
		elif checkInputJustPressed("ui_down"):
			CurrentState = "StartPause"
			buttonPoint = "start"
			
			ui.highlightSynergy("")
			return
		
		var selectedSynergy = synergyList[synergyPoint]
		ui.highlightSynergy(selectedSynergy)
	
	
	
	elif CurrentState == "StartPause":
		
		ui.showTutorial(main.currentWave)
		if buttonPoint == "start":
			ui.highlightStartPause(false)
		elif buttonPoint == "craft":
			ui.highlightStartPause(true)
		
		
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
			unitTarget = null
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
		ui.highlightCrafting(main.engramInventory.keys()[craftingSelected])
		if checkInputJustPressed("ui_left"):
			craftingSelected -= 1
			craftingSelected = wrap(craftingSelected,0,main.engramInventory.size())
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("ui_right"):
			craftingSelected += 1
			craftingSelected = wrap(craftingSelected,0,main.engramInventory.size())
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("confirm"):
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
				
				await ui.craftAnimDone
				CurrentState = "Crafting"
				ui.updateCraftingUi(currentCrafting)
			
		elif checkInputJustPressed("deny"):
			currentCrafting.pop_back()
			ui.updateCraftingUi(currentCrafting)
		elif checkInputJustPressed("ui_down"):
			ui.hideCraftingUI()
			CurrentState = "StartPause"
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
