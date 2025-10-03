extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1): ## Runs when the unit tries to attack a target
	super(target,HitCount)
	target.onHit(damage * trueDamagePercentage,null, 100)
