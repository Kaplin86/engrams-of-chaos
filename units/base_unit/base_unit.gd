extends Node2D
class_name BaseUnit

## A base unit that can move across the board, attack, and cast spells

@export var board : HexagonTileMapLayer = null ## Defines the board that the unit is playing on
@export var team : int = 0 ## Defines the team that the unit is on
@export var board_position : Vector2i = Vector2i(0,0) ## Defines the point on the board that the unit is at
@export var animPlayer : AnimationPlayer ## The animation player node that controls all animations for the unit
@export var description : String = ""

@export_category("Battle Stats")

@export var maxHP : int = 100 ## The units current maxHP
@export var range : int = 1 ## The range of the attacks that a unit has. Will stop 'range' tiles away from an enemy.
@export var damage : int = 15 ## The damage the unit attepts to do every attack
@export var speed : float = 1 ## Refers to the amount of attacks it will do per tick. This is also used to decide which unit moves first
@export var maxMana : int = 0 ## Determines the max mana of the user. If its 0, this unit is unable to cast spells
@export var defense : int = 1 ## When taking a hit, subtract this amount from the attack

var gameManagerObject : gameManager ## The game manager (wow)

@export var type = "base_unit" ## This string refers to the filename of the unit, and is to be overwritten.
var Target : BaseUnit ## Current Targeted unit

var CritChance : float = 0.1 ## The crit chance of the unit (1 being 100%)
var CritStrength : float = 2 ## The multiplier applied to an attack that crits

var directions := [TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE,TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,TileSet.CELL_NEIGHBOR_LEFT_SIDE] ## A array that contains all hexagonal directions
var visualPosition : Vector2 = Vector2(0,0) ## This defines where the visuals for the unit are. Updated every frame
var timePerTick : float = 0.5 ## The amount of time between ticks. This value gets updated every tick
var hp : int = maxHP ##The current hp of the unit
var mana : int = maxMana ##The current mana of the unit

var attackCharge : float = 0 ## The units attack charge serves as a way to know how many times the unit attacks during their tick. Every attack decreases it by 1.
var trueDamagePercentage : float = 0 ## The percentage of true damage this unit afflicts at the current moment.

var jumpToEnemy := false ## When this is enabled, all movements will attempt to jump to the target rather than walk

var _hideNextTick = false
var _is_dying = false
var isBoss = false ## This decides if this is or isnt a boss. gets set in real time
var Frozen := false ## When this is active, the unit will not attack or move. Gets disabled after the action is denied.
var _sprite = null # This is for bosses!

var healthAtTickStart := 0.0 ## Indicates HP of unit at the start of the tick. gets set to its value at pretick

func _ready() -> void:
	if !board:
		return
	visualPosition = board.map_to_local(board_position)
	if team == 1:
		$VisualHolder/HealthBar.tint_progress = Color(0,0,0,1)
	
	$VisualHolder/HealthBar.max_value = maxHP
	$VisualHolder/ManaBar.max_value = maxMana
	
	Texture2D.new()
	
	if maxMana == 0:
		$VisualHolder/ManaBar.visible = false
	
	
	mana = maxMana
	hp = maxHP

func tick(time_per_tick : float): ## This is ran every ingame tick.
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	if Frozen:
		Frozen = false
		return
	
	if gameManagerObject:
		Target = NearestEnemy()
	
	
	
	
	if Target:
		if Target.hp <= 0:
			Target = NearestEnemy()
			
		if Target and Target.hp > 0:
			var dist = board.cube_distance(Vector3i(board_position.x,board_position.y,0),Vector3i(Target.board_position.x,Target.board_position.y,0))
			if dist <= range: 
				# ATTACK STATE

				if mana >= maxMana and maxMana != 0:
					# Spell Cast
					castSpell(Target)
					mana = 0
				else:
					# Normal attack
					var hitcount = calculateAttackHits()
					animPlayer.speed_scale = 1 / timePerTick * hitcount
					attack(Target, hitcount)
				
				$VisualHolder/ManaBar.value = mana
			else:
				# MOVE STATE
				if jumpToEnemy:
					var jumpAttempt = attemptToJump(Target.board_position)
					if jumpAttempt:
						jump(jumpAttempt)
				else:
					pathfind_and_move(Target.board_position)
	
	visualPosition = board.map_to_local(board_position)

func abilityVisual(): ## This runs when the unit tries to animate its ability
	animPlayer.stop()
	animPlayer.play("ability")

func attemptToJump(targetPos : Vector2i): ## Tries to find a place to jump (aka any open neighboring cells of the target). If theres none it returns false.
	var takenpositionArray = []
	for unit in gameManagerObject.units:
		if unit != self:
			takenpositionArray.append(unit.board_position)
	var NewDirections = directions.duplicate()
	NewDirections.shuffle()
	for E in NewDirections:
		var NeighborCell = board.get_neighbor_cell(targetPos,E)
		if !takenpositionArray.has(NeighborCell):
			return NeighborCell
	return false

func jump(target): ## This fires when the unit jumps to a target.
	movePosition(target)

func calculateAttackHits() -> int: ## Calculates how many attack hits the unit does this tick
	attackCharge += speed
	var Hits = 0
	while attackCharge >= 1:
		attackCharge -= 1
		Hits += 1
	return Hits

func castSpell(target : BaseUnit): ## When the unit reaches max mana, it casts this spell instead of attacking.
	pass

func getCritMultiplier() -> float: ## Gives Crit Multiplier. Could end up being 1. For the strength of the crit, see critStrength
	if randf() <= CritChance:
		return CritStrength
	else:
		return 1.0

func calculateAttackDamage() -> float: ## Calculates the crit for the function
	return damage * getCritMultiplier()

func attack(target : BaseUnit, HitCount : int = 1): ## Runs when the unit tries to attack a target
	if HitCount == 0:
		return
	target.onHit(calculateAttackDamage(),self, trueDamagePercentage)
	attackAnim(HitCount)
	if maxMana != 0:
		mana += 20
	
	gameManagerObject.unitAttack(self)
	
	if HitCount > 1:
		if !animPlayer.animation_finished.is_connected(Callable(self, "_on_attack_anim_finished")):
			animPlayer.animation_finished.connect(
				Callable(self, "_on_attack_anim_finished").bind(target, HitCount - 1),CONNECT_ONE_SHOT)

func _on_attack_anim_finished(animname,target, remainingHits):
	if target and target.hp > 0:
		attack(target, remainingHits)

func onHit(damageToTake,attacker : BaseUnit = null, truedamagePercent : float = 0): ## Runs when the unit gets hit
	var trueDamage = damageToTake * truedamagePercent
	var normalDamage = damageToTake * (1.0 - truedamagePercent)
	
	var damageWithDefense = normalDamage - defense
	if damageWithDefense <= 0:
		damageWithDefense = 1
	
	var totaldamage = trueDamage + damageWithDefense
	gameManagerObject.unitOnHit(self)
	hp -= totaldamage
	if hp <= 0:
		die()
	
	



func attackAnim(hitcount : int = 1): ## Plays for the attack animation
	animPlayer.stop()
	animPlayer.play("attack")

func pathfind_and_move(targetPosition : Vector2i): ## This function attempts to pathfind towards the enemy, then moves accordingly. 
	if targetPosition == null:
		print("Pathfind Failed, no target pos")
		return
	
	var PositionOfEnemy = board.map_to_local(targetPosition)
	var MyPosition = board.map_to_local(board_position)
	var dist = board.cube_distance(Vector3i(board_position.x,board_position.y,0),Vector3i(Target.board_position.x,Target.board_position.y,0))
	if dist <= range:
		print("Pathfind 'Failed', in range of wanted pos")
		return
	
	
	#disable other units positions in the astar
	for unit in gameManagerObject.units:
		if unit != self:
			var point_id = board.pathfinding_get_point_id(unit.board_position)
			if point_id == -1:
				
				var takenPositions = []
				for t in gameManagerObject.units:
					takenPositions.append(unit.board_position)
					if t != self:
						var point_ide = board.astar.get_closest_point(board.map_to_local(t.board_position),true)
						board.astar.set_point_disabled(point_ide,false)
				var newdirections = directions.duplicate()
				newdirections.shuffle()
				for E in newdirections:
					if not board.get_neighbor_cell(board_position,E) in newdirections:
						movePosition(board.get_neighbor_cell(board_position,E))
						return
						
			else:
				board.astar.set_point_disabled(point_id)
	
	# Use it with AStar2D methods
	var start_id = board.pathfinding_get_point_id(board_position)
	var end_id = board.pathfinding_get_point_id(targetPosition)
	if start_id == -1 or end_id == -1:
		if start_id == -1:
			modulate = Color(0,1,0)
			print("Cant get id")
			var NewDirections = directions.duplicate()
			NewDirections.shuffle()
			var DistanceAlready = board.map_to_local(board_position).distance_to(board.map_to_local(targetPosition))
			for E in NewDirections:
				var PositionOfNeighbor=board.map_to_local(board.get_neighbor_cell(board_position,E))
				
				if board.map_to_local(PositionOfNeighbor).distance_to(board.map_to_local(targetPosition)) < DistanceAlready:
					movePosition(board.get_neighbor_cell(board_position,E))
					return
				
		elif start_id == -1:
			print("Cant get id")
		return
	var path = board.astar.get_id_path(start_id, end_id)
	if path.size() < 2:
		
		#enable other units positions in the astar
		var takenPositions = []
		for unit in gameManagerObject.units:
			takenPositions.append(unit.board_position)
			if unit != self:
				var point_id = board.astar.get_closest_point(board.map_to_local(unit.board_position),true)
				board.astar.set_point_disabled(point_id,false)
		var newdirections = directions.duplicate()
		newdirections.shuffle()
		for E in newdirections:
			if not board.get_neighbor_cell(board_position,E) in newdirections:
				movePosition(board.get_neighbor_cell(board_position,E))
				return
		
	
	
	var FoundPosition = board.cube_to_map(board.get_closest_cell_from_local(board.astar.get_point_position(path[1])))
	
	movePosition(Vector2i(FoundPosition.x,FoundPosition.y))
	
	#enable other units positions in the astar
	for unit in gameManagerObject.units:
		if unit != self:
			var point_id = board.astar.get_closest_point(board.map_to_local(unit.board_position),true)
			board.astar.set_point_disabled(point_id,false)
	

func movePosition(newPos : Vector2i):  ## moves to board location
	
	print(self," is moving from", board_position, " to ", newPos)
	
	
	
	if board.get_used_cells().has(newPos):
		board.astar.set_point_disabled(board.pathfinding_get_point_id(board_position),false)
		board_position = newPos
	

func moveAngle(angle : int): ## This function defines moving to a neighboring tile on the board. Goes clockwise, 0 being top-left side and 5 being left side
	board_position = board.get_neighbor_cell(board_position,angle)

func die(): ## This function is called when the unit dies
	if _is_dying:
		return
	_is_dying = true
	if gameManagerObject:
		gameManagerObject.units.erase(self)
	visible = false
	gameManagerObject.unitDeath(duplicate(15))
	queue_free()

func heal(amount):
	hp += amount
	hp = clamp(hp,-999,maxHP)

func NearestEnemy() -> BaseUnit: ## Returns the nearest Enemy Unit
	var Units = gameManagerObject.units
	var TargetDistance = 99999
	var TargetOfThinking = null 
	for E in Units:
		if E.team != team:
			var Dist =  board.cube_distance(Vector3i(board_position.x,board_position.y,0),Vector3i(E.board_position.x,E.board_position.y,0))
			if Dist < TargetDistance:
				TargetDistance = Dist
				TargetOfThinking = E
	
	
	if TargetOfThinking:
		return TargetOfThinking
	else:
		return null

func preTick(): ## Calls before a tick
	healthAtTickStart = hp

func postTick(): ## Calls after a tick
	var change = hp - healthAtTickStart
	if int(change) != 0:
		var CoolText : Label = $VisualHolder/BaseLabel.duplicate()
		$VisualHolder/GridContainer/Control.add_sibling(CoolText)
		var NewTween = create_tween()
		NewTween.tween_interval(timePerTick)
		NewTween.tween_property(CoolText, "modulate", Color(1,1,1,0), timePerTick)
		NewTween.bind_node(CoolText)
		

		CoolText.text = str(int(change))
		CoolText.visible = true
		if change > 0:
			CoolText.add_theme_color_override("font_color",Color.from_string("10a500",Color(4,4,4)))

func deathOnBoard(unitData : BaseUnit): ##Calls when a unit is dying. wont run if the unit dying is itself
	if hp <= 0:
		return
	pass


func _process(delta: float) -> void:
	$VisualHolder.global_position.x += (visualPosition.x - $VisualHolder.global_position.x) * 0.5 * 0.3 * ((1 / 0.016) * delta)
	$VisualHolder.global_position.y += (visualPosition.y - $VisualHolder.global_position.y) * 0.5 * 0.3 * ((1 / 0.016) * delta)
	$VisualHolder/HealthBar.value = hp
	$VisualHolder/HealthBar.max_value = maxHP
