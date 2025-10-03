extends BaseSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	print("THE BITTER LEVEL IS", level)
	for unit in manager.units:
		if unit.team == team:
			
			if level >= 2:
				unit.jumpToEnemy = true
