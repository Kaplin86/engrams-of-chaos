extends Node

## This script will automatically kill the window after no inactivity (for multi-game arcade system). It will also set the locale based on how this is executed

var timeSinceLastInput = 0.0
func _ready():
	# Parse command line arguments
	var args = OS.get_cmdline_args()
	for arg in args:
		if arg.begins_with("--locale="):
			var locale = arg.substr("--locale=".length())
			TranslationServer.set_locale(locale)
			print("Locale set to:", locale)
			
func _process(delta):
	if OS.has_feature("web"):
		return
	timeSinceLastInput += delta
	if Input.is_anything_pressed():
		timeSinceLastInput = 0
	if timeSinceLastInput > 30:
		get_tree().quit()
