extends BaseUnit
var healAmount = 15
func castSpell(target : BaseUnit):
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryHeal(Vector2i(-1,-1),positionDictionary,healAmount)
	tryHeal(Vector2i(-1,0),positionDictionary,healAmount)
	tryHeal(Vector2i(-1,1),positionDictionary,healAmount)
	tryHeal(Vector2i(0,1),positionDictionary,healAmount)
	tryHeal(Vector2i(1,0),positionDictionary,healAmount)
	tryHeal(Vector2i(0,-1),positionDictionary,healAmount)

func tryHeal(offset : Vector2i, positionDictionary, amount):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.heal(amount)
		
