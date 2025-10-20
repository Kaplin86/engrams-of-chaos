extends BaseUnit
var increase = 0.05
func tick(time):
	super(time)
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryEffect(Vector2i(-1,-1),positionDictionary,increase)
	tryEffect(Vector2i(-1,0),positionDictionary,increase)
	tryEffect(Vector2i(-1,1),positionDictionary,increase)
	tryEffect(Vector2i(0,1),positionDictionary,increase)
	tryEffect(Vector2i(1,0),positionDictionary,increase)
	tryEffect(Vector2i(0,-1),positionDictionary,increase)

func tryEffect(offset : Vector2i, positionDictionary, amount):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.CritChance += increase
