shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 colorFromUvScale(vec2 uv, sampler2D Tex, vec2 scale, vec2 offset) {
	vec2 newUV = (uv - 0.5) * scale + 0.5;
	return texture(Tex,newUV + offset);
}

void fragment() {
	vec4 COLOR1 = colorFromUvScale(UV,TEXTURE,vec2(1,1),vec2(0,0));
	vec4 COLOR2 = colorFromUvScale(UV,TEXTURE,vec2(2,2),vec2(sin(TIME),0));
	vec4 COLOR3 =colorFromUvScale(UV,TEXTURE,vec2(4,4),vec2(sin(TIME),0));
	vec4 COLOR4 =colorFromUvScale(UV,TEXTURE,vec2(3,3),vec2(sin(TIME * 1.1),0.1));
	vec4 COLOR5 =colorFromUvScale(UV,TEXTURE,vec2(1,1),vec2(cos(TIME * 1.1),sin(TIME * 1.1)));
	COLOR2 = mix(COLOR2,COLOR3,2);
	COLOR2 = mix(COLOR2,COLOR4,2);
	COLOR2 = mix(COLOR2,COLOR5,2);
	
	COLOR2.a = COLOR1.a;
	COLOR = mix(COLOR1,COLOR2,-0.5);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
