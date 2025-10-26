extends BaseSynergy
class_name BitterSynergy
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	print("First bitter tick for team ",team, " with a power of ", level)
	for unit in manager.units:
		if unit.team == team:
			if DatastoreHolder.synergyUnitJson.has(unit.type):
				var UnitsSynergy = DatastoreHolder.synergyUnitJson[unit.type]
				if UnitsSynergy.has("bitter"):
					if level >= 2:
						unit.jumpToEnemy = true
					
					if level >= 6:
						unit.CritChance += 0.1
					elif level >= 4:
						unit.CritChance += 0.05

func get_description(level) -> String:
	var StringWow = tr("bitterSynergyDesc")
	StringWow += "\n\n"
	if level >= 6:
		StringWow += tr("NumberOfUnits").format({"NUMBER":2}) + " - "
		StringWow += "[b]" + tr("bitterSynergyTier2") + "[/b]"
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":4}) + " - "
		StringWow += tr("bitterSynergyTier4")
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":6}) + " - "
		StringWow += "[b]" + tr("bitterSynergyTier6") + "[/b]"
		return StringWow


	elif level >= 4:
		StringWow += tr("NumberOfUnits").format({"NUMBER":2}) + " - "
		StringWow += "[b]" + tr("bitterSynergyTier2") + "[/b]"
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":4}) + " - "
		StringWow += "[b]" + tr("bitterSynergyTier4") + "[/b]"
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":6}) + " - "
		StringWow += tr("bitterSynergyTier6")
		return StringWow
	elif level > 1:
		StringWow += tr("NumberOfUnits").format({"NUMBER":2}) + " - "
		StringWow += "[b]" + tr("bitterSynergyTier2") + "[/b]"
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":4}) + " - "
		StringWow += tr("bitterSynergyTier4")
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":6}) + " - "
		StringWow += tr("bitterSynergyTier6")
		return StringWow
	else:
		StringWow += tr("NumberOfUnits").format({"NUMBER":2}) + " - "
		StringWow += tr("bitterSynergyTier2")
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":4}) + " - "
		StringWow += tr("bitterSynergyTier4")
		StringWow += "\n\n"
		StringWow += tr("NumberOfUnits").format({"NUMBER":6}) + " - "
		StringWow += tr("bitterSynergyTier6")
		return StringWow
