extends BaseUnit
func castSpell(target):
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryBuff(Vector2i(-1,-1),positionDictionary)
	tryBuff(Vector2i(-1,0),positionDictionary)
	tryBuff(Vector2i(-1,1),positionDictionary)
	tryBuff(Vector2i(0,1),positionDictionary)
	tryBuff(Vector2i(1,0),positionDictionary)
	tryBuff(Vector2i(0,-1),positionDictionary)

func tryBuff(offset : Vector2i, positionDictionary):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.CritChance += 0.1
