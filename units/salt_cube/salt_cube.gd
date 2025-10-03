extends BaseUnit
var saltCount = 0
func tick(time):
	super(time)
	saltCount += 1
	if saltCount == 3:
		defense += 2
