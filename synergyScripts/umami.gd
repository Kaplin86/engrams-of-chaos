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
