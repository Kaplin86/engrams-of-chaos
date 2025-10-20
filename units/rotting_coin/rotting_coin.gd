extends BaseUnit
func castSpell(target : BaseUnit):
	super(target)
	var SynergyLevel = gameManagerObject.calculatesynergies(team)["greed"]
	target.onHit(damage * SynergyLevel,self,trueDamagePercentage)
