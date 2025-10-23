extends BaseUnit
func preTick():
	var UnitPosDictionary = {}
	for E in gameManagerObject.units:
		UnitPosDictionary[E.board_position] = E
	
	
	if UnitPosDictionary.has(board_position + Vector2i(-1,0)):
		gameManagerObject.spawnUnit(UnitPosDictionary[board_position + Vector2i(-1,0)].type,board_position,team,UnitPosDictionary[board_position + Vector2i(-1,0)].isBoss)
		die()
		
