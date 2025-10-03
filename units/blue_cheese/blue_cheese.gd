extends BaseUnit
func die():
	super()
	gameManagerObject.spawnUnit("mini_cheese",board_position,team)
