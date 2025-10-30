extends BaseBoss
var charge = 0
func tick(time):
	timePerTick = time
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

func preTick():
	super()
	charge += 1
	if charge >= 5:
		charge = 0
		var Enemies = []
		for E in gameManagerObject.units:
			if E.team != team:
				Enemies.append(E)

		var ChosenOne = Enemies.pick_random()
		
		heal(ChosenOne.hp * 2)
		ChosenOne.hp -= 999
