extends BaseUnit
func castSpell(target : BaseUnit):
	super(target)
	var healAmount = 0
	if team == 2:
		for E in gameManagerObject.engramInventory:
			healAmount += (gameManagerObject.engramInventory[E])
	else:
		healAmount = 5
	heal(healAmount)
