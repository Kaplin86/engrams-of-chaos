extends BaseUnit
func castSpell(target):
	target.onHit(damage * 3,self, trueDamagePercentage)
