extends BaseUnit
func castSpell(target : BaseUnit): ## When the unit reaches max mana, it casts this spell instead of attacking.
	target.CritChance = 0
