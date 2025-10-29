extends BaseBoss
func attack(target, hitcount = 1):
	super(target, hitcount)
	var oldpos = board_position
	board_position = target.board_position
	target.board_position = oldpos
