extends BaseRanger
func castSpell(target):
	var oldDefense = defense
	defense = damage
	damage = oldDefense
	$VisualHolder/YetAnotherHolder/Visual.flip_h = !$VisualHolder/YetAnotherHolder/Visual.flip_h
