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

func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy have increased defense.

2 Units - 5% Boost

4 Units - 10% Boost

[b]6 Units - 20% Boost[/b]"


	elif level >= 4:
		return "Units of this synergy have increased defense.

2 Units - 5% Boost

[b]4 Units - 10% Boost[/b]

6 Units - 20% Boost"
	elif level > 1:
		return "Units of this synergy have increased defense.

[b]2 Units - 5% Boost[/b]

4 Units - 10% Boost

6 Units - 20% Boost"
	else:
		return "Units of this synergy have increased defense.

2 Units - 5% Boost

4 Units - 10% Boost

6 Units - 20% Boost"
