extends BaseUnit
func preTick():
	for E in gameManagerObject.units:
		if E.board_position.x == board_position.x:
			if E.team == team:
				E.speed += 0.1
