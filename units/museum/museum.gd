extends BaseUnit
var LastDeathStats = {}
func deathOnBoard(data : BaseUnit):
	super(data)
	if data.team == team:
		if data.type != type:
			LastDeathStats["damage"] = data.damage
			LastDeathStats["speed"] = data.speed
			LastDeathStats["defense"] = data.defense
			LastDeathStats["type"] = data.type
			LastDeathStats["isBoss"] = data.isBoss
			LastDeathStats["critChance"] = data.CritChance

func die():
	super()
	if !LastDeathStats.is_empty():
		var newguy = gameManagerObject.spawnUnit(LastDeathStats["type"],board_position,team,LastDeathStats["isBoss"])
		newguy.damage = LastDeathStats["damage"]
		newguy.speed = LastDeathStats["speed"]
		newguy.defense = LastDeathStats["defense"]
		newguy.CritChance = LastDeathStats["critChance"]
