extends BaseUnit
func castSpell(target):
	super(target)
	Frozen = true
	var allies = []
	for E in gameManagerObject.units:
		if E.team == team:
			allies.append(E)
	
	allies.pick_random().tick(timePerTick)
