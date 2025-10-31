shader_type canvas_item;

uniform vec4 outlinecolor : source_color;
uniform float speed = 1;
uniform float time = 0;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 colorFromUvScale(vec2 uv, sampler2D Tex, vec2 scale, vec2 offset) {
	vec2 newUV = (uv - 0.5) * scale + 0.5;
	return texture(Tex,newUV + offset);
}

void fragment() {
	float newTime = mod(TIME * speed,1.0001);
	vec4 color = texture(TEXTURE,UV + vec2(newTime,0));
	vec4 otherColor = texture(TEXTURE,UV + vec2(newTime - 1.0,0));
	if (otherColor.a != 0.0){
		color = otherColor;
	}
	vec4 otherColor3 = texture(TEXTURE,UV + vec2(0,newTime));
	if (otherColor3.a != 0.0){
		color = otherColor3;
	}
	vec4 otherColor2 = texture(TEXTURE,UV + vec2(0,newTime - 1.0));
	if (otherColor2.a != 0.0){
		color = otherColor2;
	}
	vec4 origColor = texture(TEXTURE,UV);
	if (color == vec4(0,0,0,0)) {
		color = origColor;
	}
	if (origColor != outlinecolor) {
		color = origColor;
	}
	
	vec4 actualColor = color;
	actualColor.a = texture(TEXTURE,UV).a;
	COLOR = actualColor;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
