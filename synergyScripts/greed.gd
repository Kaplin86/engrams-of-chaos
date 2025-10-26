extends BaseSynergy
class_name GreedSynergy
func firstTick(team : int, level):
	if level > 1:
		var Allies = []
		for E in manager.units:
			if E is BaseUnit:
				if E.team == team:
					Allies.append(E)
		var Sacrifice : BaseUnit = Allies.pick_random()
		Allies.erase(Sacrifice)
		Sacrifice.die()
		for E in Allies:
			if level >= 6:
				E.damage += 4
			elif level >= 4:
				E.damage += 2
			elif level > 1:
				E.damage += 1
