extends Node2D
class_name gameManager
## It manages the game (shocker)

@export var tickTimer : Timer ## The timer that runs ticks
@export var secondsPerTick := 0.5 ## The amount of seconds inbetween each tick
@export var units : Array[BaseUnit] = [] ## The units on the board currently
@export var board : HexagonTileMapLayer ## The board the game is happening on
@export var currentWave = 1
@export var defenseTuning = -1


var currentSynergyObjects : Array[BaseSynergy] = [] ## The current synergy resources that are inplay
var teamSynergyStore : Dictionary = {}
var doneFirstTick := false ## This gives wether the game has had its first tick yet

var battleState := "preround" ## This string reports what state the game is in. If its 'preround', the user is able to move units around and craft new units. If its 'round', then ticks will be happening (or pausable)
var gameFinished := false ## When this is true, next tick will restart the board
var battleLoadout : Array = [] ## A duplication of units made at the start of each round

var currentAvailableEngrams : Array[String] = ["bitter","salty","sour","spicy","sweet","umami"] ## The current engrams you can obtain
var currentlyAvailableBosses : Array[String] = ["rolling_pin","cutlery","whisk"] ## The current bosses you can fight
var currentlyAvailableSuperbosses : Array[String] = ["oven","fridge","blender","plate_pile"] ## The current super bosses that appear on wave 7
var engramInventory : Dictionary = {} ## The current engrams the player has. Formatted like {"sweet":3,"salty":9}

var gameOverText : Array[String] = ["TRY AGAIN","TRY AGAIN","TRY AGAIN", "Make sure to place your units strategically!","Make sure to use synergy buffs to their fullest!","In life, we are always learning.","The cycle of losses should not be interpreted as a treadmill, but as a wheel. You move forward with each repetition.","YOUR LOSS HERE IS ALL BUT GUARANTEED","Try again and make burnt toast proud!!"] ## A large array filled with strings of various death texts

var ticksThisRound := 0 ## This variable is set to how many ticks have happened so far this round.
var lastScreenshot : ViewportTexture ## This texture is taken of the board last time a tick was started

signal TickEnd
signal AttackHit
signal RoundEnd
signal _confirmpress

func _ready() -> void:
	tickTimer.wait_time = secondsPerTick
	tickTimer.timeout.connect(tick)
	#tickTimer.start()
	
	#seed(currentWave)
	
	generateEnemyTeam()
	
	$CanvasLayer2/Control.modulate = Color(1,1,1,0)
	$CanvasLayer2/Control.visible = true
	
	if DatastoreHolder.difficulty == "TurnedTables":
		#spawnUnit(currentlyAvailableBosses.pick_random(),Vector2i(7,14),2,true)
		spawnUnit("trash_can",Vector2i(7,14),2,true)
	else:
		if !DatastoreHolder.tutorial:
			spawnUnit( DatastoreHolder.synergyUnitJson.keys().pick_random(),Vector2i(7,14),2)
			spawnUnit( DatastoreHolder.synergyUnitJson.keys().pick_random(),Vector2i(7,13),2)
		else:
			spawnUnit("chicken_wing",Vector2i(7,14),2)
	
	$CanvasLayer/UI.visualizeSynergy(calculatesynergies(2))
	#startFight()
	
	$CursorHandler.unitTarget = units[1]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("confirm"):
		_confirmpress.emit()

func pauseTicks(unpause = false):
	tickTimer.paused = !unpause

func getBoardScreenshot():
	for E in $Death.get_children():
		E.queue_free()
	for E in get_children():
		if E is Node2D:
			if not E is Camera2D:
				var NewGuy = E.duplicate()
				NewGuy.process_mode =Node.PROCESS_MODE_DISABLED
				if NewGuy.get_script():
					NewGuy.set_script(null)
				$Death.add_child(NewGuy)
	$Death.render_target_update_mode = $Death.UPDATE_ONCE
	return $Death.get_texture()

func printstatblock():
	for E in DatastoreHolder.craftingUnitJson:
		var GetStatBlock : BaseUnit = load("res://units/"+E+"/"+E+".tscn").instantiate()
		print("UNIT NAME: ", E)
		print("ATTACK:", GetStatBlock.damage)
		print("HP:", GetStatBlock.maxHP)
		print("DEFENSE:", GetStatBlock.defense)
		print("RANGE:", GetStatBlock.range)
		print("ATTACK SPEED:", GetStatBlock.speed)
		print("MAX MANA:", GetStatBlock.maxMana)
		print("ABILITY/FUNCTION:", GetStatBlock.description)
		print()

func generateEnemyTeam():
	var EnemyCount = randi_range(currentWave,currentWave * currentWave)
	var usedPositions = []
	if currentWave == 1 and $TutorialHandler.tutorialMode: 
		spawnUnit("cake",Vector2i(7,1),1)
	elif currentWave == 5 or currentWave == 7:
		#spawnUnit("cutlery",Vector2(7,1),1,true)
		var bossName = currentlyAvailableBosses.pick_random()
		if currentWave == 7:
			bossName = currentlyAvailableSuperbosses.pick_random()
			#bossName = "fridge"
		spawnUnit(bossName,Vector2(7,1),1,true)
		
		
		$"BossText/Modulate/Boss Name".text = bossName.capitalize().replace("_"," ")
		$BossText/Modulate/Desc.text = '"'+DatastoreHolder.BossesDesc.get(bossName,"") + '"'
		$BossText/Modulate.modulate = Color(1,1,1,0)
		$BossText.visible = true
		var newtween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		newtween.tween_property($BossText/Modulate,"modulate",Color(1,1,1,1),0.5)
		await get_tree().create_timer(2).timeout
		newtween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		newtween.tween_property($BossText/Modulate,"modulate",Color(1,1,1,0),1)
		await get_tree().create_timer(1).timeout
	else:
		for E in EnemyCount:
			var ChosenUnit = DatastoreHolder.synergyUnitJson.keys().pick_random()
			var chosenPos
			if currentWave == 2 and $TutorialHandler.tutorialMode:
				chosenPos = Vector2i(randi_range(3,12),randi_range(1,3))
			else:
				chosenPos = Vector2i(randi_range(2,12),randi_range(1,3))
			if !usedPositions.has(chosenPos):
				usedPositions.append(chosenPos)
				spawnUnit(ChosenUnit,chosenPos,1)
		

func startFight():
	print("starting fightz")
	
	lastScreenshot = getBoardScreenshot()
	
	doneFirstTick = false
	ticksThisRound = 0
	tickTimer.wait_time = secondsPerTick
	tickTimer.start()
	
	
	
	currentSynergyObjects.clear()
	var NeededSynergies = combine_arrays_unique(calculatesynergies(2).keys(),calculatesynergies(1).keys())
	teamSynergyStore = {1:calculatesynergies(1),2:calculatesynergies(2)}
	for E in NeededSynergies:
		var NewSynergyObject : BaseSynergy = load("res://synergyScripts/"+E+".gd").new()
		currentSynergyObjects.append(NewSynergyObject)
		NewSynergyObject.manager = self
	
	$RoundStart.play()
	$RoundStart.pitch_scale = 1 + (randf() - 0.5) * 0.1

func combine_arrays_unique(array1: Array, array2: Array) -> Array:
	var combined_array = array1.duplicate(true) 
	for element in array2:
		if not combined_array.has(element):
			combined_array.append(element)
	return combined_array


func calculatesynergies(team:int)-> Dictionary:
	var synergy = []
	var unitscounted = []
	for E : BaseUnit in units:
		if E.team==team:
			if !unitscounted.has(E.type):
				unitscounted.append(E.type)
				if DatastoreHolder.synergyUnitJson.has(E.type):
					synergy += DatastoreHolder.synergyUnitJson[E.type]
	
	var newsynergyStore := {}
	for C in synergy:
		if newsynergyStore.has(C):
			newsynergyStore[C] += 1
		else:
			newsynergyStore[C] = 1
	
	return newsynergyStore

func isPlayerBoardFull(): ## Checks if the tiles between 2,12 and 12,14 are full
	var PositionDictionary = {}
	for E in units:
		PositionDictionary[E.board_position] = E
	for E in range(11):
		if PositionDictionary.has(Vector2i(E+2,13)) and PositionDictionary.has(Vector2i(E+2,12)) and PositionDictionary.has(Vector2i(E+2,14)):
			pass
		else:
			return false
	return true

func getFirstOpenPlayerBoardPosition(): ## Gives the first open tile between 2,12 and 12,14. Meant to be used after a isPlayerBoardFull check
	var PositionDictionary = {}
	for E in units:
		PositionDictionary[E.board_position] = E
	for E in range(11):
		if !PositionDictionary.has(Vector2i(E+2,12)):
			return Vector2i(E+2,12)
		elif !PositionDictionary.has(Vector2i(E+2,13)):
			return Vector2i(E+2,13)
		elif !PositionDictionary.has(Vector2i(E+2,14)):
			return Vector2i(E+2,14)
func spawnUnit(unitType : String, pos : Vector2i, team : int = 1, boss = false): ## Spawns a unit of a particular type at a specific board position
	if board:
		
		var NewUnit : BaseUnit
		if boss:
			NewUnit = load("res://units/_bosses/" + unitType + "/" + unitType + ".tscn").instantiate()
		else:
			NewUnit = load("res://units/" + unitType + "/" + unitType + ".tscn").instantiate()
		NewUnit.board_position = pos
		NewUnit.board = board
		NewUnit.gameManagerObject = self
		NewUnit.team = team
		NewUnit.defense += defenseTuning
		NewUnit.y_sort_enabled = true
		NewUnit.z_index = 1
		add_child(NewUnit)
		units.append(NewUnit)
		NewUnit.isBoss = boss
		if randi_range(0,100) == 86:
			NewUnit.scale = Vector2(-1,-1)
		return OK
	else:
		return FAILED
	
var beat = 3 ## The current metronome beat we are on

func tick(): ## Runs whenever the tickTimer reaches its end. Iterates through all units and runs their tick function
	print()
	print("TICK             ")
	ticksThisRound += 1
	tickTimer.wait_time = max(secondsPerTick - (0.02 * ticksThisRound),0.1)
	tickTimer.start()
	
	if gameFinished:
		gameFinished = false
		endRound()
		return
	
	if doneFirstTick == false:
		doneFirstTick = true
		callTeamSynergies("firstTick")
	
	callTeamSynergies("tickTeam")
	
	
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
	
	# PRE TICK FIRST
	for E in UnitsBySpeed:
		var unit : BaseUnit = E["unit"]
		
		if not is_instance_valid(unit):
			continue
		if unit.hp <= 0:
			unit.die()
			continue
		
		
		unit.preTick()
	
	# ACTUAL TICK
	for E in UnitsBySpeed:
		var unit : BaseUnit = E["unit"]
		
		if not is_instance_valid(unit):
			continue
		if unit.hp <= 0:
			unit.die()
			continue
		
		
		if ticksThisRound >= 100:
			unit.hp -= ticksThisRound - 100
		unit.tick(secondsPerTick)
		
	
	# POST TICK LAST
	for E in UnitsBySpeed:
		var unit : BaseUnit = E["unit"]
		
		if not is_instance_valid(unit):
			continue
		if unit.hp <= 0:
			unit.die()
			continue
		
		
		unit.postTick()
	
	TickEnd.emit()

func endRound(): ## This is called when the round ends
	print("Ending Round")
	tickTimer.stop()
	if units[0].team != 2: # Checks the first unit of the remaining ones. If all the enemy team is dead, this if statement shouldnt run
		$CursorHandler.disabledInputs = ["ui_up","ui_left","ui_down","ui_right","confirm","deny"]
		if lastScreenshot:
			$CanvasLayer2/Control/Board.texture = lastScreenshot
		await get_tree().create_timer(1).timeout
		$CanvasLayer2/Control/DeathText.text = "'"+gameOverText.pick_random() + "'"
		$CanvasLayer2/Control/HighestRound.text = "Final Round: " + str(currentWave)
		if $CanvasLayer/UI.synergyList.size() != 0:
			$CanvasLayer2/Control/StrongestSynergy.text = "Strongest Synergy: " + $CanvasLayer/UI.synergyList.get(0)
		else:
			$CanvasLayer2/Control/StrongestSynergy.text = "Strongest Synergy: NONE."
		$CanvasLayer2/Control/Mode.text = "Gamemode: " + DatastoreHolder.difficulty
		var newtween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		newtween.tween_property($CanvasLayer2/Control,"modulate",Color(1,1,1,1),1)
		await get_tree().create_timer(1).timeout
		await _confirmpress
		DatastoreHolder.waveOfDeath = currentWave
		if $CanvasLayer/UI.synergyList.size() != 0:
			DatastoreHolder.highestSynergy = $CanvasLayer/UI.synergyList[0]
		else:
			DatastoreHolder.highestSynergy = "NONE. "
		DatastoreHolder.UnitTypesUsed = battleLoadout
		Transition.TransitionToScene("res://ui/leaderboard.tscn")
		return
	for E in units:
		E.queue_free()
	units.clear()
	
	for data in battleLoadout:
		spawnUnit(data["type"], data["pos"], data["team"], data["boss"])
	battleLoadout.clear()
	
	battleState = "preround"
	$CanvasLayer/UI.textUpdateStartButton("Start Round")
	currentWave += 1
	generateEnemyTeam()
	
	var newengrams = []
	var EngramsOwed = currentWave * 1.5
	if DatastoreHolder.difficulty == "TurnedTables":
		EngramsOwed /= 4
	for E in round(EngramsOwed):
		newengrams.append(currentAvailableEngrams.pick_random())
		var NewIcon = Sprite2D.new()
		NewIcon.texture = load("res://ui/elements/"+newengrams[-1]+".svg")
		NewIcon.scale = Vector2(0.055,0.055)
		NewIcon.position.x = randi_range(41,160)
		NewIcon.position.y = randi_range(21,175.0)
		NewIcon.z_index = 20
		var newtween = create_tween().bind_node(NewIcon).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		newtween.tween_interval(1)
		newtween.tween_property(NewIcon,"position",Vector2(NewIcon.position.x + 300,NewIcon.position.y),2)
		newtween.tween_callback(NewIcon.queue_free)
		NewIcon.set_visibility_layer_bit(0,false)
		NewIcon.set_visibility_layer_bit(1,true)
		add_child(NewIcon)
	
	for E in newengrams:
		if engramInventory.has(E):
			engramInventory[E] += 1
		else:
			engramInventory[E] = 1
	
	RoundEnd.emit()

func sortSpeed(a, b): ## Function to sort the speed of units
	return a.get("speed",0) < b.get("speed",0)

func unitDeath(unitData : BaseUnit): ## Called when any unit dies. It gets passed a duplicate of the unit that just died.
	callTeamSynergies("unitDeath",unitData)
	
	var team1alive = false
	var team2alive = false
	for e in units:
		if e.team == 1:
			team1alive = true
		if e.team == 2:
			team2alive = true
		e.deathOnBoard(unitData)
	if not (team1alive and team2alive):
		print("gameover")
		gameFinished = true

func unitAttack(unitData : BaseUnit): ## Called when any unit attacks. It gets passed the unit.
	AttackHit.emit()
	callTeamSynergies("unitAttack",unitData)

func unitOnHit(unitData : BaseUnit): ## Caled when any unit gets hit. It gets passed the unit.
	callTeamSynergies("unitGetHit",unitData)

func startButtonHit(): ## When a particular ui button is hit
	if battleState == "preround":
		battleState = "round"
		
		battleLoadout.clear()
		for E in units:
			if E.team == 2:
				battleLoadout.append({
					"type": E.type,
					"pos": E.board_position,
					"team": E.team,
					"boss": E.isBoss
				})
		
		startFight()
		$CanvasLayer/UI.textUpdateStartButton("Pause")
		
		
	elif battleState == "round":
		tickTimer.paused = !tickTimer.paused
		if tickTimer.paused:
			$CanvasLayer/UI.textUpdateStartButton("Resume")
		else:
			$CanvasLayer/UI.textUpdateStartButton("Pause")

func callTeamSynergies(FunctionName : String, extraParam = null):
	for E in currentSynergyObjects:
		if teamSynergyStore[1].has(E.get_filename()):
			if DatastoreHolder.enemySynergy:
				if extraParam:
					E.call(FunctionName,1,teamSynergyStore[1][E.get_filename()],extraParam)
				else:
					E.call(FunctionName,1,teamSynergyStore[1][E.get_filename()])
		
		if teamSynergyStore[2].has(E.get_filename()):
			if extraParam:
				E.call(FunctionName,2,teamSynergyStore[2][E.get_filename()],extraParam)
			else:
				E.call(FunctionName,2,teamSynergyStore[2][E.get_filename()])
