extends RichTextLabel
var lastString = ""

@export var RelativeToLength = true
@export var KeywordToColor : Dictionary = {"damage":Color(1,1,1)}
var NewTween



func _process(delta):
	if lastString != get_parsed_text():
		
		lastString = get_parsed_text()
		
		var newColor = keywordToColor(text)
		print(newColor)
		parse_bbcode(newColor)
		
		
		visible_characters = 0
		if NewTween:
			NewTween.stop()
		NewTween = create_tween()
		if RelativeToLength:
			NewTween.tween_property(self,"visible_characters",text.length(),0.3 * (text.length() / 20))
		else:
			NewTween.tween_property(self,"visible_characters",text.length(),0.3)

func keywordToColor(baseText):
	var NewText = baseText
	for E in KeywordToColor:
		
		var color : Color = KeywordToColor[E]
		print("looking for", E)
		print("before",text)
		NewText = NewText.replace(E,"[color=#" + color.to_html(false) +"]"+E + "[/color]")
		print("after",text)
	return NewText
