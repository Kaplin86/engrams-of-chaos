extends BaseUnit
func castSpell(target):
	for E in gameManagerObject.units:
		if E.team != team:
			E.damage -= min(3,E.damage)
