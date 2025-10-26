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
