extends BaseBoss
func preTick():
	var cells = board.get_used_cells().duplicate()
	cells.erase(board_position)
	var chosenCell = cells.pick_random()
	board.erase_cell(chosenCell)
	cells.erase(chosenCell)
	for E in gameManagerObject.units:
		if E.board_position == chosenCell:
			E.die()
	
	board_position = cells.pick_random()

func _process(delta):
	super(delta)
	$VisualHolder.rotation += delta
