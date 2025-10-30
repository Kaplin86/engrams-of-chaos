extends BaseBoss
func tick(time_per_tick):
	timePerTick = time_per_tick
	
	$VisualHolder/ManaBar.value = mana
	
	if hp <= 0:
		die()
		return
	
	visualPosition = board.map_to_local(board_position)
var SynergyCalc
func postTick():
	super()
	var Enemies = []
	for E in gameManagerObject.units:
		if E.team != team:
			Enemies.append(E)
	
	if team == 2:
		SynergyCalc = gameManagerObject.calculatesynergies(1)
	else:
		SynergyCalc = gameManagerObject.calculatesynergies(2)
	
	var SynergyNames = SynergyCalc.keys()
	
	SynergyNames.sort_custom(sortSynergy)
	if SynergyNames.size() != 0:
		var SelectedSynergy = SynergyNames[0]
		for E in Enemies:
			if DatastoreHolder.synergyUnitJson.has(E.type):
				if DatastoreHolder.synergyUnitJson[E.type].has(SelectedSynergy):
					E.onHit(20)
					var Newparticle = $CPUParticles2D.duplicate()
					Newparticle.texture = load("res://ui/elements/"+SelectedSynergy+".svg")
					Newparticle.global_position = board.map_to_local(Vector2i(E.board_position))
					add_child(Newparticle)
					Newparticle.speed_scale = 1 / timePerTick
					Newparticle.emitting = true
	else:
		for E in Enemies:
			E.onHit(5)


func sortSynergy(a, b):
	return SynergyCalc[a] > SynergyCalc[b]
