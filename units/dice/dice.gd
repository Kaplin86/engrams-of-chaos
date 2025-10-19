extends BaseUnit
func tick(time):
	super(time)
	var allies = []
	for E in gameManagerObject.units:
		if E.team == team:
			allies.append(E)
	var subject = allies.pick_random()
	subject.damage += randi_range(-1,3)
	subject.defense += randi_range(-1,3)
	subject.speed += randf_range(-0.1,0.3)
