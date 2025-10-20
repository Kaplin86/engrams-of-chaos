extends BaseUnit
var tickCount = 0
var statNumber = 0
func preTick():
	super()
	var oldStatNum = statNumber
	statNumber = 0
	if tickCount == 1:
		for E in gameManagerObject.units:
			if E.team == team:
				statNumber += E.maxHP + E.damage + E.defense + E.speed
	if statNumber < oldStatNum:
		maxHP += 5
		heal(5)
