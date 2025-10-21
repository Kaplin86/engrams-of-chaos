extends BaseUnit
var firstPos

func tick(time):
	if !firstPos:
		firstPos = board_position
	super(time)
func onHit(damage,Hitter : BaseUnit = null, trueDamagePercent = 0.0):
	super(damage,Hitter,trueDamagePercent)
	var UnitPosDictionary = {}
	for E in gameManagerObject.units:
		UnitPosDictionary[E.board_position]
	if !UnitPosDictionary.keys().has(firstPos):
		if firstPos:
			board_position = firstPos
			defense += 1
