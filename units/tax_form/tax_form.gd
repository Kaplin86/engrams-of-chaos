extends BaseUnit
func onHit(damage,attacker : BaseUnit = null, percentage := 0.0):
	super(damage,attacker,percentage)
	attacker.defense -= 1
