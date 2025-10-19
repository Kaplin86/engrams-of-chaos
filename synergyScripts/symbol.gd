extends BaseSynergy
class_name SymbolSynergy
func firstTick(team : int, level):
	var uniqueTypes = []
	for E in manager.units:
		if E is BaseUnit:
			if E.team == team:
				if E.type not in uniqueTypes:
					uniqueTypes.append(E.type)
	
	for E in manager.units:
		if E is BaseUnit:
			if E.team == team:
				if DatastoreHolder.synergyUnitJson.has(E.type):
					var UnitsSynergy = DatastoreHolder.synergyUnitJson[E.type]
					if UnitsSynergy.has("symbol"):
						if level >= 6:
							E.speed += 0.15 * team 
						elif level >= 4:
							E.speed += 0.1 * team 
						elif level > 1:
							E.speed += 0.05 * team 

func get_description(level) -> String:
	if level >= 6:
		return "Units of this synergy have increased attack speed based on how many unit types are in play

2 Units - +0.15 per

4 Units - +0.1 per

[b]6 Units - +0.05 per[/b]"


	elif level >= 4:
		return  "Units of this synergy have increased attack speed based on how many unit types are in play

2 Units - +0.15 per

[b]4 Units - +0.1 per[/b]

6 Units - +0.05 per"
	elif level > 1:
		return  "Units of this synergy have increased attack speed based on how many unit types are in play

[b]2 Units - +0.15 per[/b]

4 Units - +0.1 per

6 Units - +0.05 per"
	else:
		return "Units of this synergy have increased attack speed based on how many unit types are in play

2 Units - +0.15 per

4 Units - +0.1 per

6 Units - +0.05 per"
