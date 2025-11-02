extends Node

## This script will automatically kill the window after no inactivity (for multi-game arcade system).

var timeSinceLastInput = 0.0
func _process(delta):
	if OS.has_feature("web"):
		return
	timeSinceLastInput += delta
	if Input.is_anything_pressed():
		timeSinceLastInput = 0
	if timeSinceLastInput > 30:
		get_tree().quit()
