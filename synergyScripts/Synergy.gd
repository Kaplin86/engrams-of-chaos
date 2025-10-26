extends Resource
class_name BaseSynergy

## The base synergy resource. Does nothing except provide functions.

var manager : gameManager ## A variable that assigns the gamemanager which is required by nearly all synergies.

func tickTeam(team : int,level): ## This fires every tick. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	pass
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	pass
func unitAttack(team : int,level,unit : BaseUnit): ## This fires when a unit on a team attacks
	pass
func unitGetHit(team : int,level,unit : BaseUnit): ## This fires when a unit on a team gets hit
	pass
func get_description(level) -> String: ## This function should return the in-text description of what this synergy does. It also gets the current level.
	var SynergyName = get_script().get_path().get_file().replace(".gd","")
	var Text = tr(SynergyName + "SynergyDesc")
	Text += addTextLevel(tr(SynergyName + "SynergyTier2"),[6,4,2],2,level)
	Text += addTextLevel(tr(SynergyName + "SynergyTier4"),[6,4,2],1,level)
	Text += addTextLevel(tr(SynergyName + "SynergyTier6"),[6,4,2],0,level)
	return Text

func addTextLevel(inputText,levelArray,selector,level) -> String:
	var Prefix = tr("NumberOfUnits").format({"NUMBER":levelArray[selector]})
	for E in levelArray:
		if level >= E:
			if E == levelArray[selector]:
				return "\n\n [b]"+Prefix + " - " + "" + inputText + "[/b]"
			else:
				return "\n\n"+Prefix + " - " + inputText
	return str(level)
func get_filename() -> String: ## This function returns the string name for this resource
	return get_script().resource_path.get_file().get_basename()
func unitDeath(team : int,level,unit : BaseUnit): ## This fires when a unit on a team dies
	pass
