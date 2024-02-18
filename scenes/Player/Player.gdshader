shader_type canvas_item;

float circle(vec2 position, float radius, float feather)
{
	return smoothstep(radius, radius + feather, length(position - vec2(0.5)));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = circle(vec2(0, 0), 5, 1))
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
