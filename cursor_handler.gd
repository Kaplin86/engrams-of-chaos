extends Node2D
var CurrentState = "BoardUnit"
var boardPosition : Vector2i
var unitTarget : BaseUnit

@export var main : gameManager
@export var ui : Node2D

func _process(delta: float) -> void:
	if !main:
		return
	if CurrentState == "BoardUnit":
		if unitTarget == null:
			unitTarget = main.units[0]
		if Input.is_action_just_pressed("ui_left"):
			changeUnitSelect(main.units[main.units.find(unitTarget) - 1])
		if Input.is_action_just_pressed("ui_right"):
			if main.units.find(unitTarget) + 1 >= main.units.size():
				changeUnitSelect(main.units[0])
			else:
				changeUnitSelect(main.units[main.units.find(unitTarget) + 1])
		unitTarget.modulate = Color(2,2,2)


func changeUnitSelect(newUnit : BaseUnit):
	unitTarget.modulate = Color(1,1,1)
	unitTarget = newUnit
	if unitTarget and ui:
		ui.viewUnit(unitTarget)
