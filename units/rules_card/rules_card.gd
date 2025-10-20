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
			if UnitPosDictionary.has(board_position + Vector2i(1,0)):
				var UnitToRight : BaseUnit = UnitPosDictionary[board_position + Vector2i(1,0)]
				UnitToRight.maxHP = UnitToLeft.maxHP
				UnitToRight.hp      = UnitToLeft.hp
				UnitToRight.damage  = UnitToLeft.damage
				UnitToRight.speed   = UnitToLeft.speed
				UnitToRight.defense = UnitToLeft.defense
