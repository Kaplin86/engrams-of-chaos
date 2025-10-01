extends BaseUnit
func castSpell(target : BaseUnit):
	target.onHit(damage + target.defense,self)
	attackAnim(1)
	mana = 0
