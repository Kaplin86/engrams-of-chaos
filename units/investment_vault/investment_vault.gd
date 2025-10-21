extends BaseUnit
var ability = false
var storedType
var isboss
func preTick():
	super()
	if !ability:
		ability = true
		var Allies = []
		for E in gameManagerObject.units:
			if E.team == team:
				Allies.append(E)
		
		var Sacrifice = Allies.pick_random()
		storedType = Sacrifice.type
		isboss = Sacrifice.isBoss
		Sacrifice.die()
		

func die():
	super()
	if storedType:
		var NewUnit = gameManagerObject.spawnUnit(storedType,board_position,team,isboss)
		NewUnit.defense *= 1.5
