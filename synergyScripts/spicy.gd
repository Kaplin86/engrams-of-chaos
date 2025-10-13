extends BaseSynergy
class_name SpicySynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	print("First spicy tick for team ", team, " with a power of ", level)
	for E in manager.units:
		if E is BaseUnit:
			if E.team == team:
				if !DatastoreHolder.synergyUnitJson.has(E.type):
					return
				var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
				if UnitsSynergy.has("spicy"):
					#now we do level based stuff
					if level >= 6:
						E.damage += ceil(E.damage * 0.15)
					elif level >= 4:
						E.damage += ceil(E.damage * 0.10)
					elif level > 1:
						E.damage += ceil(E.damage * 0.05)



func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy get an attack increase at the start of the round.

2 Units -  5% Increase

4 Units -  10% Increase

[b]6 Units -  15% Increase[/b]"


	elif level >= 4:
		return "Units of this synergy get an attack increase at the start of the round.

2 Units -  5% Increase

[b]4 Units -  10% Increase[/b]

6 Units -  15% Increase"
	elif level > 1:
		return "Units of this synergy get an attack increase at the start of the round.

[b]2 Units -  5% Increase[/b]

4 Units -  10% Increase

6 Units -  15% Increase"
	else:
		return "Units of this synergy get an attack increase at the start of the round.

2 Units -  5% Increase

4 Units -  10% Increase

6 Units -  15% Increase"
