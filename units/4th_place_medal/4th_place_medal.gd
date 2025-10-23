extends BaseUnit
var trigger = false
func preTick():
	super()
	if maxHP / hp <= 3.33333:
		if !trigger:
			trigger = true
			defense += 7
