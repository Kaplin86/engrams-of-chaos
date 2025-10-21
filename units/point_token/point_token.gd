extends BaseUnit
func castSpell(target : BaseUnit):
	var power = 0
	for E in gameManagerObject.units:
		if E.team == team:
			if E.type == type:
				power += 1
	target.onHit(damage * power,null,trueDamagePercentage)
