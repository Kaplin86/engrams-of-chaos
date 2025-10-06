extends CanvasLayer
var WantedPosition := Vector2(348.0,230.0)
var PointingDirection := deg_to_rad(193.3)
func _process(delta: float) -> void:
	
	$Guy.global_position -= ($Guy.global_position - WantedPosition) * 0.1
	print(PointingDirection)
	$Guy/BurntToastBody/Arm.global_rotation = lerp_angle($Guy/BurntToastBody/Arm.global_rotation,PointingDirection,0.1)

func moveTo(newpos : Vector2):
	WantedPosition = newpos
