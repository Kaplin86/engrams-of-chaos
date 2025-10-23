extends RichTextLabel
var lastString = ""

@export var RelativeToLength = true
@export var KeywordToColor : Dictionary = {"damage":Color(1,1,1)}
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

func keywordToColor():
	for E in KeywordToColor:
		var color : Color = KeywordToColor[E]
		text.replace(E,"[color=#" + color.to_html(false) +"]"+"E" + "[/color]")
		
