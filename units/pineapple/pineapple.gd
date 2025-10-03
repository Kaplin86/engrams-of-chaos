extends BaseUnit
func onHit(damageToTake,attacker : BaseUnit = null, truedamagePercent : float = 0): ## Runs when the unit gets hit
	super(damageToTake,attacker,truedamagePercent)
	attacker.speed *= 0.95
