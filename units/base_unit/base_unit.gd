extends Node2D
class_name BaseUnit

## A base unit that can move across the board

@export var board : TileMapLayer = null ## Defines the board that the unit is playing on
@export var team : int = 0 ## Defines the team that the unit is on
@export var board_position : Vector2i = Vector2i(0,0) ## Defines the point on the board that the unit is at

func _tick():
	pass
