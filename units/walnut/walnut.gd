extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1): ## Runs when the unit tries to attack a target
	super(target,HitCount)
	print("WALNUT DEALS BONUS", damage * trueDamagePercentage)
	target.onHit(damage * trueDamagePercentage,null,1)
