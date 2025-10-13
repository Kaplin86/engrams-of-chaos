extends BaseUnit
class_name BaseBoss
func _ready():
	super()
	maxHP = maxHP * ((gameManagerObject.currentWave + 1.0) / 5.0)
	hp = maxHP
