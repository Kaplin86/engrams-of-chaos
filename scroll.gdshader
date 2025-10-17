shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

float wrap_value(float x, float min_value, float max_value) {
    float range = max_value - min_value;
    return mod(x - min_value, range) + min_value;
}


void fragment() {
	vec2 offset = vec2(0,wrap_value(TIME * 0.1,0.0,1.1));
	COLOR = texture(TEXTURE, vec2(UV.x,wrap_value((TIME * 0.1) + UV.y,0.0,1.0)));
	// Called for every pixel the material is visible on.
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
