extends BaseSynergy
class_name CreativitySynergy

func firstTick(team : int, level):
	if level > 1:
		var buff = 0
		if level >= 6:
			buff = manager.calculatesynergies(team).size() * 4
		elif level >= 4:
			buff = manager.calculatesynergies(team).size() * 2
		elif level >= 2:
			buff = manager.calculatesynergies(team).size() * 1
		
		
		for E in manager.units:
			if E is BaseUnit:
				if E.team == team:
					if DatastoreHolder.synergyUnitJson.has(E.type):
						var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
						if UnitsSynergy.has("salty"):
							E.maxHP += buff
							E.heal(buff)

func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy gain max HP times however many unique synergies are on board.

2 Units - 1 Max HP

4 Units - 2 Max HP

[b]6 Units - 4 Max HP[/b]"


	elif level >= 4:
		return "Units of this synergy gain max HP times however many unique synergies are on board.

2 Units - 1 Max HP

[b]4 Units - 2 Max HP[/b]

6 Units - 4 Max HP"
	elif level > 1:
		return "Units of this synergy gain max HP times however many unique synergies are on board.

[b]2 Units - 1 Max HP[/b]

4 Units - 2 Max HP

6 Units - 4 Max HP"
	else:
		return "Units of this synergy gain max HP times however many unique synergies are on board.

2 Units - 1 Max HP

4 Units - 2 Max HP

6 Units - 4 Max HP"
