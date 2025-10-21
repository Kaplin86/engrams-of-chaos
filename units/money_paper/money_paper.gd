extends BaseUnit
func castSpell(target : BaseUnit):
	super(target)
	var attackAmount = 0
	if team == 2:
		for E in gameManagerObject.engramInventory:
			attackAmount += (gameManagerObject.engramInventory[E])
	else:
		attackAmount = 5
	target.onHit(attackAmount,self,trueDamagePercentage)
