extends BaseSynergy
class_name SaltySynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	for E in manager.units:
		if E is BaseUnit:
			if E.team == team:
				if DatastoreHolder.synergyUnitJson.has(E.type):
					var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
					if UnitsSynergy.has("salty"):
						if level >= 6:
							E.defense += round(0.2 * E.defense)
						elif level >= 4:
							E.defense += round(0.1 * E.defense)
						elif level > 1:
							E.defense += round(0.05 * E.defense)
