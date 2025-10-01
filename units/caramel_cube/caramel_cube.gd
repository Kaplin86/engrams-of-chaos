extends BaseUnit
#ORIGINAL EFFECT : HEAL NEIGHBORING ALLIES BY 5% AND INCREASE DEFENSE BY 10%
func castSpell(target):
	var positionDictionary = {}
	for E in gameManagerObject.units:
		positionDictionary[E.board_position] = E
	
	tryHeal(Vector2i(-1,-1),positionDictionary)
	tryHeal(Vector2i(-1,0),positionDictionary)
	tryHeal(Vector2i(-1,1),positionDictionary)
	tryHeal(Vector2i(0,1),positionDictionary)
	tryHeal(Vector2i(1,0),positionDictionary)
	tryHeal(Vector2i(0,-1),positionDictionary)

func tryHeal(offset : Vector2i, positionDictionary):
	if positionDictionary.has(offset + board_position):
		var targetedunit : BaseUnit = positionDictionary[offset + board_position]
		if targetedunit.team == team:
			targetedunit.heal(round(targetedunit.defense * 2))
			#targetedunit.heal(round(targetedunit.maxHP * 0.05))
			#targetedunit.defense += round(targetedunit.defense * 0.10)
