extends BaseUnit
var increaseAmount = 0.1
func castSpell(target : BaseUnit):
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryBuff(Vector2i(-1,-1),positionDictionary,increaseAmount)
	tryBuff(Vector2i(-1,0),positionDictionary,increaseAmount)
	tryBuff(Vector2i(-1,1),positionDictionary,increaseAmount)
	tryBuff(Vector2i(0,1),positionDictionary,increaseAmount)
	tryBuff(Vector2i(1,0),positionDictionary,increaseAmount)
	tryBuff(Vector2i(0,-1),positionDictionary,increaseAmount)

func tryBuff(offset : Vector2i, positionDictionary, amount):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.CritChance += increaseAmount
		
