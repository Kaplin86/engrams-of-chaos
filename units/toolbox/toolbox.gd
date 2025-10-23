extends BaseUnit
func preTick():
	for E in gameManagerObject.units:
		if E.board_position.y == board_position.y:
			if E.team == team:
				E.speed += 0.05
