extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1):
	super(target,HitCount)
	speed += speed * 0.02
