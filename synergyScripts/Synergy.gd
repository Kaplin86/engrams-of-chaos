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
	return "BaseSynergy. Does NOTHING"
func get_filename() -> String: ## This function returns the string name for this resource
	return get_script().resource_path.get_file().get_basename()
func unitDeath(team : int,level,unit : BaseUnit): ## This fires when a unit on a team dies
	pass
