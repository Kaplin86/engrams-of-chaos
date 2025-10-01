extends BaseRanger
func castSpell(target):
	var oldDefense = defense
	defense = damage
	damage = oldDefense
