extends Label
var lastString = ""

@export var RelativeToLength = true
var NewTween

func _process(delta):
	if lastString != text:
		lastString = text
		visible_characters = 0
		if NewTween:
			NewTween.stop()
		NewTween = create_tween()
		if RelativeToLength:
			NewTween.tween_property(self,"visible_characters",text.length(),0.3 * (text.length() / 20))
		else:
			NewTween.tween_property(self,"visible_characters",text.length(),0.3)
