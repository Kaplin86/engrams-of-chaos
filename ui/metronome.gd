extends Node2D
class_name metronomeUI

## A UI element that moves a particular object based on a timer

@export var timer : Timer ## The timer that the metronome runs off
@export var hammer : Node2D ## The hammer that moves from the metronome
@export var maxangle := 45 ## Determines how far the hammer moves

var hammerHalf = -1 ## The variable that determines whether the hammer is on the leftside or rightside of resting point
var _lasthammertime = 0
func _process(delta):
	if !hammer or !timer:
		return
	if _lasthammertime != timer.time_left:
		if _lasthammertime - timer.time_left < timer.time_left * -0.5:
			hammerHalf *= -1
		_lasthammertime = timer.time_left
		
		var TimePercent = timer.time_left / timer.wait_time # How much is REMAINING (goes from 1 to 0, 0 being tick)
		
		if TimePercent <= 0.5:
			$Hammer.rotation_degrees = maxangle * TimePercent * hammerHalf
		else:
			$Hammer.rotation_degrees = maxangle * (1 - TimePercent)  * hammerHalf
		
		
