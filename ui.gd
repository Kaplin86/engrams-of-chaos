extends Node2D
@export var timer : Timer
func _ready() -> void:
	$Metronome.timer = timer
