extends BaseBoss
var Hits = 0
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)
func onHit(damage,attacker = null,truedamage = 0.0):
	super(damage,attacker,truedamage)
	Hits += 1
	if Hits >= 2:
		Hits = 0
		var AvailableTiles = board.get_used_cells()
		for E in gameManagerObject.units:
			AvailableTiles.erase(E.board_position)
		var NewPosForUnit = AvailableTiles.pick_random()
		gameManagerObject.spawnUnit("plate",NewPosForUnit,team)
