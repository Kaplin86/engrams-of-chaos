extends BaseUnit
var nearbyUnits = []
func onHit(damage, hitter : BaseUnit = null, truedamagepercent : float = 0):
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	checkPos(Vector2i(-1,-1),positionDictionary)
	checkPos(Vector2i(-1,0),positionDictionary)
	checkPos(Vector2i(-1,1),positionDictionary)
	checkPos(Vector2i(0,1),positionDictionary)
	checkPos(Vector2i(1,0),positionDictionary)
	checkPos(Vector2i(0,-1),positionDictionary)
	
	var dividedamount = damage / (nearbyUnits.size() + 1)
	
	for E : BaseUnit in nearbyUnits:
		E.onHit(dividedamount,hitter,truedamagepercent)
	
	super(dividedamount,hitter,truedamagepercent)

func checkPos(offset : Vector2i, positionDictionary):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			nearbyUnits.append(targetedunit)
			
	
