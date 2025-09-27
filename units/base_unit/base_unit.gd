extends Node2D
class_name BaseUnit

## A base unit that can move across the board

@export var board : HexagonTileMapLayer = null ## Defines the board that the unit is playing on
@export var team : int = 0 ## Defines the team that the unit is on
@export var board_position : Vector2i = Vector2i(0,0) ## Defines the point on the board that the unit is at

@export_category("Battle Stats")

@export var hp : int = 100
@export var range : int = 1 ## The range of the attacks that a unit has. Will stop 'range' tiles away from an enemy.
@export var damage : int = 15


var gameManagerObject : gameManager ## The game manager (wow)

var type = "base_unit" ## This string refers to the filename of the unit, and is to be overwritten.
var Target : BaseUnit ## Current Targeted unit


var directions = [TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE,TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,TileSet.CELL_NEIGHBOR_LEFT_SIDE]
var visualPosition : Vector2 = Vector2(0,0) ## This defines where the visuals for the unit are. Updated every frame
var timePerTick : float = 0.5 ## The amount of time between ticks. This value gets updated every tick
var maxHP : int = hp ##The max HP of a unit

func _ready() -> void:
	visualPosition = board.map_to_local(board_position)
	if team == 1:
		modulate = Color(1,0,0)
	
	$VisualHolder/TextureProgressBar.max_value = maxHP
	

func tick(time_per_tick : float): ## This is ran every ingame tick.
	timePerTick = time_per_tick
	
	if hp <= 0:
		die()
	
	
	if gameManagerObject and !Target:
		Target = NearestEnemy()
	
	
	if Target:
		var dist = board.cube_distance(Vector3i(board_position.x,board_position.y,0),Vector3i(Target.board_position.x,Target.board_position.y,0))
		if dist <= range: 
			# ATTACK STATE
			attack(Target)
		else:
			# MOVE STATE
			pathfind_and_move(Target.board_position)
	
	visualPosition = board.map_to_local(board_position)

func attack(target : BaseUnit): ## Runs when the unit tries to attack a target
	onHit(damage,self)
	attackAnim()
	

func onHit(damageToTake,attacker : BaseUnit = null): ## Runs when the unit gets hit
	hp -= damageToTake

func attackAnim(): ## Plays for the attack animation
	$anim.stop()
	$anim.speed_scale = 1 / timePerTick
	$anim.play("attack")

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
	gameManagerObject.units.erase(self)
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
