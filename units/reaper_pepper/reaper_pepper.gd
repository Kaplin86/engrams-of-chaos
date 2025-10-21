extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1):
	super(target,HitCount)
	speed -= 0.1
	damage += 1
