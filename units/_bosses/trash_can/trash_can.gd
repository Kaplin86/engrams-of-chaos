extends BaseBoss
var doneability = false
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

func preTick():
	super()
	if !doneability:
		doneability = true
		var Enemies = []
		for E in gameManagerObject.units:
			if E.team != team:
				Enemies.append(E)
		for i in ceil(Enemies.size() * 0.3):
			var chosenEnemy : BaseUnit = Enemies.pick_random()
			Enemies.erase(chosenEnemy)
			chosenEnemy.hp = -999
			chosenEnemy.team = team
			var newunit = gameManagerObject.spawnUnit(chosenEnemy.type,chosenEnemy.board_position,team,chosenEnemy.isBoss)

func deathOnBoard(unit):
	super(unit)
	if unit.team != team:
		for E in gameManagerObject.units:
			if E.team == team:
				E.heal(100)
				E.defense += 2
				E.damage += 1
