extends BaseBoss
var Activate = false
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

func onHit(damage,hitter : BaseUnit = null, truedamage := 0.0):
	Activate = true
	super(damage,hitter,truedamage)
func preTick():
	super()
	if Activate:
		Activate = false
		var Tiles : Array[Vector2i] = board.get_used_cells()
		for E in gameManagerObject.units:
			var NewTile = Tiles.pick_random()
			Tiles.erase(NewTile)
			E.board_position = NewTile
			if E.type != type:
				E.onHit(10,null,0.2)
