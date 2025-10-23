extends BaseUnit
func getCritMultiplier():
	if randf() <= CritChance:
		CritChance = 0.1
		return CritStrength
	else:
		CritChance += 0.1
		return 1.0
