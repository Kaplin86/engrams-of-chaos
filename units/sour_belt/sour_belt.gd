extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1):
	super(target,HitCount)
	if target.maxMana != 0:
		target.mana -= 3
