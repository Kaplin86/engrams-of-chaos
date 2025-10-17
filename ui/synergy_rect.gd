extends ColorRect
func _ready():
	$Label.add_theme_color_override("font_color",getColorOfImage($Image.texture))
func getColorOfImage(texture : Texture2D):
	var color := Vector3.ZERO
	var texture_size := texture.get_size()
	var image := texture.get_image()
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			var pixel := image.get_pixel(x, y)
			color += Vector3(pixel.r, pixel.g, pixel.b)
			
	color /= texture_size.x * texture_size.y

	return Color(color.x, color.y, color.z)
