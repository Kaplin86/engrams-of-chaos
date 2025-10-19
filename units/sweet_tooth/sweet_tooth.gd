extends BaseUnit
var abilityUsed = false
func preTick():
	super()
	if gameManagerObject.calculatesynergies(team).get("sweet",0) > 4:
		if !abilityUsed:
			abilityUsed = true
			$VisualHolder/YetAnotherHolder/Visual2.visible = true
			maxHP = 130
			hp = maxHP
			damage = 9
			defense = 7
