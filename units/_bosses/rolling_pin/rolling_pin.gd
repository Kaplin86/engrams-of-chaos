extends BaseBoss
var doneAbility = false
func tick(time):
	super(time)
	if !doneAbility:
		speed = 1
		doneAbility = true
		var Enemies = []
		for E in gameManagerObject.units:
			if E.team != team:
				Enemies.append(E)
		var EnemiesToConvert : int = round(Enemies.size() / 2)
		for E in range(EnemiesToConvert):
			var chosen : BaseUnit = Enemies.pick_random()
			Enemies.erase(chosen)
			chosen.hp = -999
			var NewBoardPos = chosen.board_position
			gameManagerObject.spawnUnit("dough",NewBoardPos,chosen.team)
