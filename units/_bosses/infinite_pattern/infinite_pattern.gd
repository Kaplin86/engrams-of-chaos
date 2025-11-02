extends BaseBoss
var deltaTimer = 0.0
var tickNumber = 0
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)
	
func preTick():
	super()
	tickNumber += 1
	if tickNumber >= 20:
		tickNumber = 0
		$Bell.play()
		var BoardPositions = board.get_used_cells()
		for E in gameManagerObject.units:
			BoardPositions.erase(E.board_position)
		if  BoardPositions.size() > 0:
			var newunit = gameManagerObject.spawnUnit("infinite_pattern",BoardPositions.pick_random(),team,true)
			newunit.maxHP = maxHP * 0.8
			newunit.heal(1)
func _process(delta):
	deltaTimer += delta
	super(delta)
	#$VisualHolder/YetAnotherHolder/Visual.material.set_shader_parameter("time",deltaTimer)
