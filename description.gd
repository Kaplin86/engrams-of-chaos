extends RichTextLabel

var oldtext = ""
func _process(delta):
	if oldtext != text:
		oldtext = text
		call_deferred("_adjust_font_size")

func _adjust_font_size():
	var size = 24
	add_theme_font_size_override("normal_font_size", size)
	await get_tree().process_frame  # wait for layout update

	while get_v_scroll_bar().visible and size > 8:
		size -= 1
		add_theme_font_size_override("normal_font_size", size)
		await get_tree().process_frame  # wait for UI update
	print("FINAL SIZE:", size)
