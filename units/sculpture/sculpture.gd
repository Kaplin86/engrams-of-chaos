extends BaseUnit
func castSpell(target : BaseUnit):
	super(target)
	target.onHit(damage * 5,self,trueDamagePercentage)
	damage -= 2
