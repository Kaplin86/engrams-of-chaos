extends BaseUnit
var tickCount = 0
var statNumber = 0
func preTick():
	super()
	tickCount += 1
	if tickCount == 1:
		for E in gameManagerObject.units:
			if E.team == team:
				statNumber += E.maxHP + E.damage + E.defense + E.speed
	elif tickCount == 2:
		var oldStatNum = statNumber
		for E in gameManagerObject.units:
			if E.team == team:
				statNumber += E.maxHP + E.damage + E.defense + E.speed
		if statNumber > oldStatNum:
			maxHP += 30
			heal(30)
