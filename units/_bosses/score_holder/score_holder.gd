extends BaseBoss
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

func postTick():
	super()
	var enemies = []
	for E in gameManagerObject.units:
		if E.team != team:
			enemies.append(E)
	enemies.sort_custom(mysort)
	print("num",ceil(enemies.size() / 2.0))
	for E in ceil(enemies.size() / 2.0):
		enemies[E].onHit(20)
	

func mysort(A,B):
	if A.damage + A.defense > B.damage + B.defense:
		return true
	else:
		return false
