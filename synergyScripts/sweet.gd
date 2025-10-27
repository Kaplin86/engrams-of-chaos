extends BaseSynergy
class_name SweetSynergy
func tickTeam(team : int,level): ## This fires every tick. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	for E in manager.units:
		if E.team == team:
			if DatastoreHolder.synergyUnitJson.has(E.type):
				var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
				if UnitsSynergy.has("sweets"):
					if level >= 6:
						E.heal(round(E.maxHP * 0.1))
					elif level >= 4:
						E.heal(round(E.maxHP * 0.04))
					elif level > 1:
						E.heal(round(E.maxHP * 0.02))
