extends BaseUnit
func castSpell(target):
	for E in gameManagerObject.units:
		if E.board_position.y == board_position.y:
			if E.team == team:
				E.damage += 1
				E.defense += 1
