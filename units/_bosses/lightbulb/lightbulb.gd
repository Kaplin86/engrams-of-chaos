extends BaseBoss
var ability = false
func tick(time):
	timePerTick = time
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

var Transfer = {12:1,13:2,14:3,3:14,2:13,1:12}

func preTick():
	super()
	if !ability:
		ability = true
		$Switch1.play()
		var PositionArray = {}
		for E in gameManagerObject.units:
			PositionArray[E.board_position] = E
		for E in gameManagerObject.units:
			if E.team != team:
				var NewUnitPos = E.board_position
				NewUnitPos.y = Transfer[E.board_position.y]
				if !PositionArray.has(NewUnitPos):
					if !E.isBoss:
						gameManagerObject.spawnUnit(E.type,NewUnitPos,team)
