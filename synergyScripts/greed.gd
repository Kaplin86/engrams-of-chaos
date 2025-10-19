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

func get_description(level) -> String:
	if level >= 6:
		return "A random unit is sacrificed, the rest of the team gets buffs.

2 Units - 1 Attack

4 Units - 2 Attack

[b]6 Units - 4 Attack[/b]"


	elif level >= 4:
		return "A random unit is sacrificed, the rest of the team gets buffs.

2 Units - 1 Attack

[b]4 Units - 2 Attack[/b]

6 Units - 4 Attack"
	elif level > 1:
		return "A random unit is sacrificed, the rest of the team gets buffs.

[b]2 Units - 1 Attack[/b]

4 Units - 2 Attack

6 Units - 4 Attack"
	else:
		return "A random unit is sacrificed, the rest of the team gets buffs.

2 Units - 1 Attack

4 Units - 2 Attack

6 Units - 4 Attack"
