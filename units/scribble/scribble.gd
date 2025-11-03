extends BaseUnit
func _process(delta):
	var currentColor : Color = $VisualHolder/YetAnotherHolder/Visual.self_modulate
	$VisualHolder/YetAnotherHolder/Visual.self_modulate = Color.from_hsv(currentColor.h + 0.1,currentColor.s,currentColor.v)
