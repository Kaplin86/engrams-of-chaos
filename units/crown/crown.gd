extends BaseUnit
var ability = false
func preTick():
	super()
	if !ability:
		ability = true
		var UnitPosDictionary = {}
		for E in gameManagerObject.units:
			UnitPosDictionary[E.board_position]
		
		
		if UnitPosDictionary.has(board_position + Vector2i(-1,0)):
			var UnitToLeft : BaseUnit = UnitPosDictionary[board_position + Vector2i(-1,0)]
			UnitToLeft.damage += damage
			UnitToLeft.maxHP += maxHP
			UnitToLeft.heal(hp)
			UnitToLeft.defense += defense
			UnitToLeft.maxHP += maxHP
			UnitToLeft.CritChance += CritChance
			UnitToLeft.speed += speed
			die()
