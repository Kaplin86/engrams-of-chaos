shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist =( sin(TIME * 3.0) * 0.75 )+ 1.0;
	COLOR = vec4(UV.x * dist,UV.y * dist * cos(TIME),UV.x * UV.y * dist,1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
