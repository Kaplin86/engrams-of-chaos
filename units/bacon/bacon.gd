extends BaseUnit
func spellCast():
	for E in gameManagerObject.units:
		if E.team == team:
			E.heal(E.damage + E.defense)
