extends BaseBoss
func attack(target : BaseUnit, HitCount : int = 1):
	super(target,HitCount)
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	attemptToAttack(Vector2i(-1,-1), positionDictionary)
	attemptToAttack(Vector2i(-1,0), positionDictionary)
	attemptToAttack(Vector2i(-1,1),positionDictionary)
	attemptToAttack(Vector2i(0,1),positionDictionary)
	attemptToAttack(Vector2i(1,0),positionDictionary)
	attemptToAttack(Vector2i(0,-1),positionDictionary)

func attemptToAttack(offset : Vector2i, positionDictionary):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team != team:
			targetedunit.onHit(damage,self)
		
