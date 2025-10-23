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
				doAverage("maxHP",UnitToLeft,UnitToRight)
				doAverage("hp",UnitToLeft,UnitToRight)
				doAverage("damage",UnitToLeft,UnitToRight)
				doAverage("speed",UnitToLeft,UnitToRight)
				doAverage("defense",UnitToLeft,UnitToRight)
				doAverage("maxMana",UnitToLeft,UnitToRight)

func doAverage(property : String,leftunit : BaseUnit,rightunit : BaseUnit):
	var Average = leftunit.get(property) + rightunit.get(property)
	if leftunit.get(property) != 0 and rightunit.get(property) != 0:
		leftunit.set(property,Average/2)
		rightunit.set(property,Average/2)
