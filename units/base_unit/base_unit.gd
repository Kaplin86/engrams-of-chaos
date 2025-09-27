extends Node2D
class_name BaseUnit

## A base unit that can move across the board

@export var board : HexagonTileMapLayer = null ## Defines the board that the unit is playing on
@export var team : int = 0 ## Defines the team that the unit is on
@export var board_position : Vector2i = Vector2i(0,0) ## Defines the point on the board that the unit is at
@export var animPlayer : AnimationPlayer ## The animation player node that controls all animations for the unit

@export_category("Battle Stats")

@export var hp : int = 100 ## The units current hp, maxhp is set to this at runtime.
@export var range : int = 1 ## The range of the attacks that a unit has. Will stop 'range' tiles away from an enemy.
@export var damage : int = 15 ## The damage the unit attepts to do every attack
@export var speed : float = 1 ## Refers to the amount of attacks it will do per tick. This is also used to decide which unit moves first
@export var mana : int = 0 ## Determines the max mana of the user. If its 0, this unit is unable to cast spells
@export var defense : int = 1 ## When taking a hit, subtract this amount from the attack

var gameManagerObject : gameManager ## The game manager (wow)

var type = "base_unit" ## This string refers to the filename of the unit, and is to be overwritten.
var Target : BaseUnit ## Current Targeted unit


var directions := [TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE,TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,TileSet.CELL_NEIGHBOR_LEFT_SIDE] ## A array that contains all hexagonal directions
var visualPosition : Vector2 = Vector2(0,0) ## This defines where the visuals for the unit are. Updated every frame
var timePerTick : float = 0.5 ## The amount of time between ticks. This value gets updated every tick
var maxHP : int = hp ##The max HP of a unit
var maxMana : int = mana ##The max HP of a unit

var attackCharge : float = 0 ## The units attack charge serves as a way to know how many times the unit attacks during their tick. Every attack decreases it by 1.

var _hideNextTick = false
var _is_dying = false

func _ready() -> void:
	visualPosition = board.map_to_local(board_position)
	if team == 1:
		modulate = Color(1,0,0)
	
	$VisualHolder/TextureProgressBar.max_value = maxHP
	

func tick(time_per_tick : float): ## This is ran every ingame tick.
	timePerTick = time_per_tick
	
	if hp <= 0:
		die()
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
				else:
					# Normal attack
					var hitcount = calculateAttackHits()
					attack(Target, hitcount)
					print("i attack with hitcounts of ", hitcount)
			else:
				# MOVE STATE
				pathfind_and_move(Target.board_position)
				print("i move")
	
	visualPosition = board.map_to_local(board_position)

func calculateAttackHits() -> int: ## Calculates how many attack hits the unit does this tick
	attackCharge += speed
	var Hits = 0
	while attackCharge >= 1:
		attackCharge -= 1
		Hits += 1
	return Hits

func castSpell(target):
	pass

func attack(target : BaseUnit, HitCount : int = 1): ## Runs when the unit tries to attack a target
	if HitCount == 0:
		return
	target.onHit(damage,self)
	attackAnim(HitCount)
	
	if HitCount > 1:
		animPlayer.animation_finished.connect(
			Callable(self, "_on_attack_anim_finished").bind(target, HitCount - 1),CONNECT_ONE_SHOT)

func _on_attack_anim_finished(animname,target, remainingHits):
	if target and target.hp > 0:
		attack(target, remainingHits)

func onHit(damageToTake,attacker : BaseUnit = null): ## Runs when the unit gets hit
	var damageWithDefense = damageToTake - defense
	if damageWithDefense <= 0:
		damageWithDefense = 1
	hp -= damageWithDefense
	if hp <= 0:
		die()

func attackAnim(hitcount : int = 1): ## Plays for the attack animation
	animPlayer.stop()
	animPlayer.speed_scale = 1 / timePerTick * hitcount
	animPlayer.play("attack")

func pathfind_and_move(targetPosition : Vector2i): ## This function attempts to pathfind towards the enemy, then moves accordingly. 
	if targetPosition == null:
		return
	
	var PositionOfEnemy = board.map_to_local(targetPosition)
	var MyPosition = board.map_to_local(board_position)
	if MyPosition.distance_to(PositionOfEnemy) <= range * board.tile_set.tile_size.x:
		return
	
	
	#disable other units positions in the astar
	for unit in gameManagerObject.units:
		if unit != self:
			var point_id = board.pathfinding_get_point_id(unit.board_position)
			if point_id == -1:
				print("Point id was -1 for ", unit.board_position)
			else:
				board.astar.set_point_disabled(point_id)
	
	# Use it with AStar2D methods
	var start_id = board.pathfinding_get_point_id(board_position)
	var end_id = board.pathfinding_get_point_id(targetPosition)
	if start_id == -1 or end_id == -1:
		if start_id == -1:
			modulate = Color(0,1,0)
		return
	var path = board.astar.get_id_path(start_id, end_id)
	
	if path.size() < 2:
		#enable other units positions in the astar
		for unit in gameManagerObject.units:
			if unit != self:
				var point_id = board.astar.get_closest_point(board.map_to_local(unit.board_position),true)
				board.astar.set_point_disabled(point_id,false)
		return
	
	
	var FoundPosition = board.cube_to_map(board.get_closest_cell_from_local(board.astar.get_point_position(path[1])))
	
	movePosition(Vector2i(FoundPosition.x,FoundPosition.y))
	
	#enable other units positions in the astar
	for unit in gameManagerObject.units:
		if unit != self:
			var point_id = board.astar.get_closest_point(board.map_to_local(unit.board_position),true)
			board.astar.set_point_disabled(point_id,false)
	

func movePosition(newPos : Vector2i):  ## moves to board location
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
	queue_free()

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

func _process(delta: float) -> void:
	$VisualHolder.global_position.x += (visualPosition.x - $VisualHolder.global_position.x) * 0.5 * 0.3 * ((1 / 0.016) * delta)
	$VisualHolder.global_position.y += (visualPosition.y - $VisualHolder.global_position.y) * 0.5 * 0.3 * ((1 / 0.016) * delta)
	$VisualHolder/TextureProgressBar.value = hp
