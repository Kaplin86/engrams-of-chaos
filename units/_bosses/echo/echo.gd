extends BaseBoss
func preTick():
	super()
	var Enemies : Array[BaseUnit] = []
	for E in gameManagerObject.units:
		if E.team != team:
			Enemies.append(E)
	
	var RandomEnemy : BaseUnit = Enemies.pick_random()
	var NewUnit = gameManagerObject.spawnUnit(RandomEnemy.type,board_position,team,RandomEnemy.isBoss)
	NewUnit.maxHP *= 3
	NewUnit.hp = maxHP
	NewUnit.damage *= 3
	hp = -999
	
