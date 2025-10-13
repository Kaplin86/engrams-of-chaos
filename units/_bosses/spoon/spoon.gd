extends BaseBoss
func attack(target, hitcount = 1):
	super(target, hitcount)
	board_position = target.board_position
