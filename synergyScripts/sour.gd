extends BaseSynergy
class_name SourSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	var EnemyUnits = []
	for E in manager.units:
		if E is BaseUnit:
			if E.team != team:
				EnemyUnits.append(E)
	
	if manager.currentWave == 5 or manager.currentWave == 10:
		return
	var unitToTarget : BaseUnit = EnemyUnits.pick_random()
	if level >= 6:
		unitToTarget.hp *= 0.5
		unitToTarget.speed *= 0.5
	elif level >= 4:
		unitToTarget.hp *= 0.5
	elif level > 1:
		unitToTarget.hp *= 0.25

func get_description(level) -> String:
	if level >= 6:
		return "A random enemy has their HP reduced.

2 Units - 25% decrease

4 Units - 50% decrease

[b]6 Units - 50% decrease and half attack speed[/b]"


	elif level >= 4:
		return "A random enemy has their HP reduced.

2 Units - 25% decrease

[b]4 Units - 50% decrease[/b]

6 Units - 50% decrease and half attack speed"
	elif level > 1:
		return "A random enemy has their HP reduced.

[b]2 Units - 25% decrease[/b]

4 Units - 50% decrease

6 Units - 50% decrease and half attack speed"
	else:
		return "A random enemy has their HP reduced.

2 Units - 25% decrease

4 Units - 50% decrease

6 Units - 50% decrease and half attack speed"
