extends BaseUnit
class_name CutleryBoss
var charge = 0
func _ready():
	super()
	for E in gameManagerObject.units:
		if E.type == "fork":
			if E.team == team:
				return
	gameManagerObject.spawnUnit("fork",Vector2(board_position - Vector2i(2,0)),team,true)
	gameManagerObject.spawnUnit("spoon",Vector2(board_position + Vector2i(2,0)),team,true)
	
func tick(time):
	super(time)
	charge += 1
	if charge > 10:
		charge = 0
		var EnemyUnits = []
		for E in gameManagerObject.units:
			if E.team != team:
				EnemyUnits.append(E)
		
		var SelectedEnemy = EnemyUnits.pick_random()
		SelectedEnemy.hp = -999
