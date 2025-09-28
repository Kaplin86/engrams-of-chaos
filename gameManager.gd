extends Node2D
class_name gameManager
## It manages the game (shocker)

@export var tickTimer : Timer ## The timer that runs ticks
@export var secondsPerTick := 0.5 ## The amount of seconds inbetween each tick
@export var units : Array[BaseUnit] = [] ## The units on the board currently
@export var board : HexagonTileMapLayer ## The board the game is happening on

var currentSynergyObjects : Array[BaseSynergy] = [] ## The current synergy resources that are inplay
var teamSynergyStore : Dictionary = {}
var doneFirstTick = false ## This gives wether the game has had its first tick yet

func _ready() -> void:
	tickTimer.wait_time = secondsPerTick
	tickTimer.timeout.connect(tick)
	#tickTimer.start()
	
	seed(2)
	
	for E in range(3):
		spawnUnit("pepper",Vector2i(E * 2 + 2,1), 1)
	spawnUnit("chicken_wing",Vector2i(1 * 2 + 2,2), 1)
	
	for E in range(5):
		spawnUnit("chicken_wing",Vector2i(E * 2 + 2,14),2)
	spawnUnit("pepper",Vector2i(1 * 2 + 2,13),2)
	
	$CanvasLayer/UI.visualizeSynergy(calculatesynergies(2))
	#startFight()

func startFight():
	tickTimer.start()
	
	currentSynergyObjects.clear()
	var NeededSynergies = combine_arrays_unique(calculatesynergies(2).keys(),calculatesynergies(1).keys())
	teamSynergyStore = {1:calculatesynergies(1),2:calculatesynergies(2)}
	for E in NeededSynergies:
		var NewSynergyObject : BaseSynergy = load("res://synergyScripts/"+E+".gd").new()
		currentSynergyObjects.append(NewSynergyObject)
		NewSynergyObject.manager = self
	
	

func combine_arrays_unique(array1: Array, array2: Array) -> Array:
	var combined_array = array1.duplicate(true) 
	for element in array2:
		if not combined_array.has(element):
			combined_array.append(element)
	return combined_array


func calculatesynergies(team:int):
	var synergy = []
	var unitscounted = []
	for E : BaseUnit in units:
		if E.team==team:
			if !unitscounted.has(E.type):
				unitscounted.append(E.type)
				synergy += DatastoreHolder.synergyUnitJson[E.type]
	
	var newsynergyStore := {}
	for C in synergy:
		if newsynergyStore.has(C):
			newsynergyStore[C] += 1
		else:
			newsynergyStore[C] = 1
	
	return newsynergyStore




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
var beat = 3 ## The current metronome beat we are on

func tick(): ## Runs whenever the tickTimer reaches its end. Iterates through all units and runs their tick function
	print()
	print("TICK             ")
	
	
	
	if doneFirstTick == false:
		doneFirstTick = true
		for E in currentSynergyObjects:
			
			if teamSynergyStore[1].has(E.get_filename()):
				E.firstTick(1,teamSynergyStore[1][E.get_filename()])
			
			if teamSynergyStore[2].has(E.get_filename()):
				E.firstTick(2,teamSynergyStore[2][E.get_filename()])
	
	for E in currentSynergyObjects:
		if teamSynergyStore[1].has(E.get_filename()):
			E.tickTeam(1,teamSynergyStore[1][E.get_filename()])
		
		if teamSynergyStore[2].has(E.get_filename()):
			E.tickTeam(2,teamSynergyStore[2][E.get_filename()])
	
	
	$AudioStreamPlayer.play()
	beat += 1
	if beat ==4:
		beat = 0
		$AudioStreamPlayer.pitch_scale = 1.2 + (randf() * 0.05)
	else:
		$AudioStreamPlayer.pitch_scale = 1 + (randf() * 0.01)
	
	units.shuffle()
	var UnitsBySpeed = []
	for E in units:
		UnitsBySpeed.append({"unit":E,"speed":E.speed})
	
	UnitsBySpeed.sort_custom(sortSpeed)
	
	for E in UnitsBySpeed:
		var unit : BaseUnit = E["unit"]
		
		if not is_instance_valid(unit):
			continue
		if unit.hp <= 0:
			unit.die()
			continue
		
		
		
		unit.tick(secondsPerTick)

func sortSpeed(a, b):
	return a.get("speed",0) < b.get("speed",0)
