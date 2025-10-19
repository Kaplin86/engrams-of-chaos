extends BaseUnit
var TicksPassed = 0
func tick(time):
	super(time)
	TicksPassed += 1
	if TicksPassed >= 10:
		TicksPassed = 0
		var BoardPositions = board.get_used_cells()
		for E in gameManagerObject.units:
			BoardPositions.erase(E.board_position)
		if  BoardPositions.size() > 0:
			gameManagerObject.spawnUnit("fractal",BoardPositions.pick_random(),team)
