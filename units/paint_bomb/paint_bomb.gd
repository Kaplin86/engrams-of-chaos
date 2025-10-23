extends BaseUnit
func castSpell(target):
	super(target)
	target.onHit(damage,self,trueDamagePercentage)
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryHit(Vector2i(-1,-1),positionDictionary, target.board_position)
	tryHit(Vector2i(-1,0),positionDictionary, target.board_position)
	tryHit(Vector2i(-1,1),positionDictionary, target.board_position)
	tryHit(Vector2i(0,1),positionDictionary, target.board_position)
	tryHit(Vector2i(1,0),positionDictionary, target.board_position)
	tryHit(Vector2i(0,-1),positionDictionary, target.board_position)

func tryHit(offset : Vector2i, positionDictionary, baseBoardPos):
	if positionDictionary.has(offset + baseBoardPos):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.onHit(damage,self,trueDamagePercentage)
		
