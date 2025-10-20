extends BaseUnit
func attack(target : BaseUnit, hitCount = 1):
	super(target,hitCount)
	if !target.isBoss:
		target.Frozen = true
