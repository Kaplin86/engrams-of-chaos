extends BaseSynergy
class_name GameSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	if level > 1 and team == 2:
		if manager.engramInventory.size() > 0:
			var selectedThing = manager.engramInventory.keys().pick_random()
			manager.engramInventory[selectedThing] -= 1
			if manager.engramInventory[selectedThing] <= 0:
				manager.engramInventory.erase(selectedThing)
			
			for E in manager.units:
				if E is BaseUnit:
					if E.team == team:
						if level >= 6:
							E.defense += randi_range(0,3)
						elif level >= 4:
							E.defense += randi_range(0,2)
						else:
							E.defense += randi_range(0,1)
