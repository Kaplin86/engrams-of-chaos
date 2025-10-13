extends BaseSynergy
class_name SweetSynergy
func tickTeam(team : int,level): ## This fires every tick. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	for E in manager.units:
		if E.team == team:
			if !DatastoreHolder.synergyUnitJson.has(E.type):
				return
			var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
			if UnitsSynergy.has("sweets"):
				if level >= 6:
					E.heal(round(E.maxHP * 0.1))
				elif level >= 4:
					E.heal(round(E.maxHP * 0.04))
				elif level > 1:
					E.heal(round(E.maxHP * 0.02))

func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy get healed a percentage of max hp every tick.

2 Units -  2% Heal

4 Units -  4% Heal

[b]6 Units -  10% Heal[/b]"


	elif level >= 4:
		return "Units of this synergy get healed a percentage of max hp every tick.

2 Units -  2% Heal

[b]4 Units -  4% Heal[/b]

6 Units -  10% Heal"
	elif level > 1:
		return "Units of this synergy get healed a percentage of max hp every tick.

[b]2 Units -  2% Heal[/b]

4 Units -  4% Heal

6 Units -  10% Heal"
	else:
		return "Units of this synergy get healed a percentage of max hp every tick.

2 Units -  2% Heal

4 Units -  4% Heal

6 Units -  10% Heal"
