extends BaseRanger
func calculateAttackDamage():
	return damage * (2 * (hp / maxHP))
