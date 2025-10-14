extends BaseSynergy
class_name UmamiSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	print("First umami tick for team ", team, " with a power of ", level)
	for E in manager.units:
		if E is BaseUnit:
			if E.team == team:
				if DatastoreHolder.synergyUnitJson.has(E.type):
					var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
					if UnitsSynergy.has("umami"):
						#now we do level based stuff
						if level >= 6:
							E.trueDamagePercentage += 0.25
						elif level >= 4:
							E.trueDamagePercentage += 0.2
						elif level > 1:
							E.trueDamagePercentage += 0.1

func get_description(level) -> String:
	if level >= 6:
		return "A percentage of damage dealt by units of this synergy are true damage.

2 Units -  10% True damage

4 Units -  20% True damage

[b]6 Units -  25% True damage[/b]"


	elif level >= 4:
		return "A percentage of damage dealt by units of this synergy are true damage.

2 Units -  10%

[b]4 Units -  20%[/b]

6 Units -  25%"
	elif level > 1:
		return "A percentage of damage dealt by units of this synergy are true damage.

[b]2 Units -  10%[/b]

4 Units -  20%

6 Units -  25%"
	else:
		return "A percentage of damage dealt by units of this synergy are true damage.

2 Units -  10%

4 Units -  20%

6 Units -  25%"
