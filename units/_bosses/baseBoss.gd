extends BaseUnit
class_name BaseBoss
func _ready():
	var unitFilename = get_script().get_path().get_file().get_basename()
	_sprite = load("res://units/_bosses/"+unitFilename+"/"+unitFilename+".svg")
	super()
	if !gameManagerObject:
		return
	maxHP = maxHP * ((gameManagerObject.currentWave + 1.0) / 5.0)
	hp = maxHP
	
	
	if team != 2:
		var NewAnimPlayer = load("res://boss_fall.tscn").instantiate()
		add_child(NewAnimPlayer)
		NewAnimPlayer.get_child(0).position = visualPosition
		get_child(0).visible = false
		await get_tree().create_timer(1).timeout
		get_child(0).visible  = true
		NewAnimPlayer.play("fall")
	
