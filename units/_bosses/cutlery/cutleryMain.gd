extends BaseUnit
class_name CutleryBoss
var charge = 0
func _ready():
	super()
	gameManagerObject.spawnUnit("fork",Vector2(5,1),1,true)
	gameManagerObject.spawnUnit("spoon",Vector2(9,1),1,true)
	
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
