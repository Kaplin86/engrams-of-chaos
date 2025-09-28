extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer

func viewUnit(unit : BaseUnit):
	$Damage.text = str(unit.damage)
	$Defense.text = str(unit.defense)
	$Health.text = str(unit.maxHP)
	$UnitSelectedImage.texture = load("res://units/"+unit.type+"/" +unit.type+ ".svg")
	$Description.text = unit.description
	
	if unit.team != 2:
		$Name.text = "ENEMY " + unit.type.replace("_"," ")
	else:
		$Name.text = unit.type.replace("_"," ")
	
	for E in $Synergies.get_children():
		E.queue_free()
	
	for E in DatastoreHolder.synergyUnitJson[unit.type]:
		var NewImage = TextureRect.new()
		NewImage.texture = load("res://ui/elements/"+E+".svg")
		$Synergies.add_child(NewImage)
	
