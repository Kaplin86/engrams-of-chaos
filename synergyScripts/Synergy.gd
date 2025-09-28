extends Resource
class_name BaseSynergy
var manager : gameManager

func tickTeam(team : int,level): ## This fires every tick. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	pass
func firstTick(team : int ,level): ## This fires at the first tick of battle. The team passed is the team with the synergy, and level refers to the level of synergy that team has.
	pass
func unitAttack(team : int,level,unit : BaseUnit): ## This fires when a unit on a team attacks
	pass
func unitGetHit(team : int,level,unit : BaseUnit): ## This fires when a unit on a team gets hit
	pass
