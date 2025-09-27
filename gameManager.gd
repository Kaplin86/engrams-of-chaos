extends Node2D
class_name gameManager
## It manages the game (shocker)

@export var tickTimer : Timer ## The timer that runs ticks
@export var secondsPerTick := 0.5 ## The amount of seconds inbetween each tick
@export var units : Array[BaseUnit] = [] ## The units on the board currently
@export var board : TileMapLayer ## The board the game is happening on

func _ready() -> void:
	tickTimer.wait_time = secondsPerTick
	tickTimer.timeout.connect(tick)
	tickTimer.start()
	spawnUnit("base_unit",Vector2i(7,1),2)
	spawnUnit("base_unit",Vector2i(7,1),2)
	spawnUnit("base_unit",Vector2i(7,18))
	spawnUnit("base_unit",Vector2i(7,18))
	spawnUnit("base_unit",Vector2i(7,18))
	spawnUnit("base_unit",Vector2i(7,18))

func spawnUnit(unitType : String, pos : Vector2i, team : int = 1): ## Spawns a unit of a particular type at a specific board position
	if board:
		var NewUnit : BaseUnit = load("res://units/" + unitType + "/" + unitType + ".tscn").instantiate()
		NewUnit.board_position = pos
		NewUnit.board = board
		NewUnit.gameManagerObject = self
		NewUnit.team = team
		add_child(NewUnit)
		units.append(NewUnit)
		return OK
	else:
		return FAILED

func tick(): ## Runs whenever the tickTimer reaches its end. Iterates through all units and runs their tick function
	for E in units:
		E.tick(secondsPerTick)
