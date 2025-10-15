extends BaseBoss
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)
	
	
func postTick():
	var Enemies = []
	for E in gameManagerObject.units:
		if E.team != team:
			Enemies.append(E)
	
	var selectedEnemy : BaseUnit = Enemies.pick_random()
	var PosToEnemies = {}
	for E : BaseUnit in Enemies:
		PosToEnemies[E.board_position] = E
	$CardDraw.pitch_scale = 1 + randf_range(-0.1,0.1)
	$CardDraw.play()
	if randi_range(0,0) == 0:
		for E in range(2,13):
			if PosToEnemies.has(Vector2i(E,selectedEnemy.board_position.y)):
				var Target : BaseUnit = PosToEnemies.get(Vector2i(E,selectedEnemy.board_position.y))
				Target.onHit(20)
			var Newparticle = $CPUParticles2D.duplicate()
			Newparticle.global_position = board.map_to_local(Vector2i(E,selectedEnemy.board_position.y))
			add_child(Newparticle)
			Newparticle.speed_scale = 1 / timePerTick
			Newparticle.emitting = true
	else:
		for E in range(1,15):
			if PosToEnemies.has(Vector2i(selectedEnemy.board_position.x,E)):
				var Target : BaseUnit = PosToEnemies.get(Vector2i(selectedEnemy.board_position.x,E))
				Target.onHit(20)
			var Newparticle = $CPUParticles2D.duplicate()
			Newparticle.global_position = board.map_to_local(Vector2i(selectedEnemy.board_position.x,E))
			add_child(Newparticle)
			Newparticle.speed_scale = 1 / timePerTick
			Newparticle.emitting = true
