extends BaseBoss
func tick(time):
	super(time)
	var Enemies = []
	for E in gameManagerObject.units:
		if E.team != team:
			Enemies.append(E)
	var EnemyPairs = []
	for E in Enemies:
		if Enemies.size() > 1:
			Enemies.erase(E)
			var selectedOtherEnemy = Enemies.pick_random()
			Enemies.erase(selectedOtherEnemy)
			EnemyPairs.append([E,selectedOtherEnemy])
	for E in EnemyPairs:
		var FirstPos = E[0].board_position
		var SecondPos = E[1].board_position
		E[0].board_position = SecondPos
		E[1].board_position = FirstPos
