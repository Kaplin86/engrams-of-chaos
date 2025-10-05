extends BaseSynergy
class_name BitterSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	print("THE BITTER LEVEL IS", level)
	for unit in manager.units:
		if unit.team == team:
			var UnitsSynergy = DatastoreHolder.synergyUnitJson[unit.type]
			if UnitsSynergy.has("bitter"):
				if level >= 2:
					unit.jumpToEnemy = true
				
				if level >= 6:
					unit.CritChance += 0.1
				elif level >= 4:
					unit.CritChance += 0.05

func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy jump to enemies and have increase crit chance.

[b]2 Units - Jump to enemy[/b]

4 Units - 5% Boost

[b]6 Units - 10% Boost[/b]"


	elif level >= 4:
		return "Units of this synergy jump to enemies and have increase crit chance.

[b]2 Units - Jump to enemy[/b]

[b]4 Units - 5% Boost[/b]

6 Units - 10% Boost"
	elif level > 1:
		return "Units of this synergy jump to enemies and have increase crit chance.

[b]2 Units - Jump to enemy[/b]

4 Units - 5% Boost

6 Units - 10% Boost"
	else:
		return "Units of this synergy jump to enemies and have increase crit chance.

2 Units - Jump to enemy

4 Units - 5% Boost

6 Units - 10% Boost"
