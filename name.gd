extends Label


var preText = ""
func _process(delta):
	scale = scale.lerp(Vector2.ONE,0.1)
	if preText != text:
		preText = text
		scale *= 1.2
