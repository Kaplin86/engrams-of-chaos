extends BaseUnit
func castSpell(target):
	var BoardPositions = board.get_used_cells()
	for E in gameManagerObject.units:
		BoardPositions.erase(E.board_position)
	if  BoardPositions.size() > 0:
		gameManagerObject.spawnUnit("scribble",BoardPositions.pick_random(),team)
