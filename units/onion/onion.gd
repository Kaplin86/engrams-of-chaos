extends BaseUnit
func attack(target : BaseUnit, HitCount : int = 1):
	super(target,HitCount)
	heal(round(target.defense * 0.1))
