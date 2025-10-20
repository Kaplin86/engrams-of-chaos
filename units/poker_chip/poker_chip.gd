extends BaseUnit
func castSpell(target : BaseUnit):
	super(target)
	if randi_range(0,1) == 1:
		damage *= 2
	else:
		defense /= 2
