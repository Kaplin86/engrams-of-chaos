extends BaseUnit
class_name BaseBoss
func _ready():
	var unitFilename = get_script().get_path().get_file().get_basename()
	_sprite = load("res://units/_bosses/"+unitFilename+"/"+unitFilename+".svg")
	super()
	maxHP = maxHP * ((gameManagerObject.currentWave + 1.0) / 5.0)
	hp = maxHP
	
