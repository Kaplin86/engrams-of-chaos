extends BaseBoss
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)

func preTick():
	var Enemies = []
	for E in gameManagerObject.units:
		if E.team != team:
			Enemies.append(E)
	var EnemysToFreeze = ceil(Enemies.size() / 2.0)
	print(EnemysToFreeze)
	for E in range(EnemysToFreeze):
		var ChosenEnemy : BaseUnit 
		ChosenEnemy = Enemies.pick_random()
		ChosenEnemy.Frozen = true
		ChosenEnemy.onHit(10,null,1)
		var Newparticle = $CPUParticles2D.duplicate()
		Newparticle.global_position = board.map_to_local(Vector2i(ChosenEnemy.board_position.x,ChosenEnemy.board_position.y))
		add_child(Newparticle)
		Newparticle.speed_scale = 1 / timePerTick
		Newparticle.emitting = true
		Enemies.erase(ChosenEnemy)
