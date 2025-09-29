extends Node2D
var CurrentState = "BoardUnit"
var boardPosition : Vector2i
var unitTarget : BaseUnit
var synergyPoint = 0

@export var main : gameManager
@export var ui : Node2D

func _process(delta: float) -> void:
	if !main:
		return
	
	
	if CurrentState == "BoardUnit":
		var NewUnitList = getunitsSortedToX()
		
		if unitTarget == null:
			unitTarget = NewUnitList[0]
		else:
			ui.viewUnit(unitTarget)
		if Input.is_action_just_pressed("ui_left"):
			changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) - 1])
		if Input.is_action_just_pressed("ui_right"):
			if NewUnitList.find(unitTarget) + 1 >= NewUnitList.size():
				changeUnitSelect(NewUnitList[0])
			else:
				changeUnitSelect(NewUnitList[NewUnitList.find(unitTarget) + 1])
		unitTarget.modulate = Color(3,3,3)
		if Input.is_action_just_pressed("ui_down"):
			CurrentState = "SynergyView"
			synergyPoint = 0
			unitTarget.modulate = Color(1,1,1)
		if Input.is_action_just_pressed("ui_up"):
			CurrentState = "StartPause"
			unitTarget.modulate = Color(1,1,1)
	
	
	elif CurrentState == "SynergyView":
		var synergyList = ui.synergyList
		
		if Input.is_action_just_pressed("ui_left"):
			synergyPoint -= 1
			synergyPoint = wrap(synergyPoint,0,synergyList.size())
		elif Input.is_action_just_pressed("ui_right"):
			synergyPoint += 1
			synergyPoint = wrap(synergyPoint,0,synergyList.size())
		elif Input.is_action_just_pressed("ui_up"):
			unitTarget = null
			CurrentState = "BoardUnit"
			ui.highlightSynergy("")
			return
		elif Input.is_action_just_pressed("ui_down"):
			CurrentState = "StartPause"
			ui.highlightSynergy("")
			return
		
		var selectedSynergy = synergyList[synergyPoint]
		ui.highlightSynergy(selectedSynergy)
	
	
	
	elif CurrentState == "StartPause":
		
		ui.highlightStartPause()
		if Input.is_action_just_pressed("ui_up"):
			ui.highlightStartPause(true)
			CurrentState = "SynergyView"
			synergyPoint = 0
		elif Input.is_action_just_pressed("ui_down"):
			ui.highlightStartPause(true)
			CurrentState = "BoardUnit"
			unitTarget = null
		if Input.is_action_just_pressed("confirm"):
			main.startButtonHit()
	
	ui.currentControlState(CurrentState)

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
