extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer

func viewUnit(unit : BaseUnit):
	$Damage.text = str(unit.damage)
	$Defense.text = str(unit.defense)
	$Health.text = str(unit.maxHP)
