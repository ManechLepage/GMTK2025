shader_type canvas_item;

uniform vec2 scale = vec2(0.25);
uniform vec2 offset;
uniform vec4 background_color: source_color = vec4(vec3(0.2), 1.0);
uniform vec4 checkered_color: source_color = vec4(vec3(0.0), 0.3);

uniform vec4 coarse_grid_color : source_color = vec4(vec3(0.8), 1.0);
uniform vec2 coarse_grid_line_width = vec2(0.03);

uniform vec4 fine_grid_color: source_color = vec4(0.8);
uniform float fine_grid_subdivisions: hint_range(0.0, 15.0, 1.0) = 1.0;
uniform vec2 fine_grid_line_width = vec2(0.03);

float grid(vec2 uv, vec2 line_width) {
	bvec2 invert_line = bvec2(line_width.x > 0.5, line_width.y > 0.5);
	line_width.x = invert_line.x ? 1.0 - line_width.x : line_width.x;
	line_width.y = invert_line.y ? 1.0 - line_width.y : line_width.y;
	
	vec2 grid_uv = abs(fma(fract(uv), vec2(2.0), vec2(-1.0)));
	grid_uv.x = invert_line.x ? grid_uv.x : 1.0 - grid_uv.x;
	grid_uv.y = invert_line.y ? grid_uv.y : 1.0 - grid_uv.y;
	
	vec2 aa = fwidth(grid_uv);
	vec2 grid_value = 1.0 - smoothstep(line_width - aa, line_width + aa, grid_uv);
	grid_value.x = invert_line.x ? 1.0 - grid_value.x : grid_value.x;
	grid_value.y = invert_line.y ? 1.0 - grid_value.y : grid_value.y;
	return mix(grid_value.x, 1.0, grid_value.y);
}

float checker(vec2 uv) {
	float prod = sin(PI * uv.x) * sin(PI * uv.y);
	float aa = fwidth(prod);
	return smoothstep(-aa, aa, prod);
}

void fragment() {
	vec2 uv = (UV - offset) / scale;
	
	float checkered_mask = checker(uv);
	float coarse_grid_mask = grid(uv, coarse_grid_line_width);

	vec2 fine_grid_scale = vec2(1.0 + fine_grid_subdivisions);
	vec2 fine_uv = uv * (1.0 + fine_grid_subdivisions);
	float fine_grid_mask = grid(fine_uv, fine_grid_line_width);
	
	COLOR = background_color * COLOR;
	COLOR.rgb = mix(COLOR.rgb, checkered_color.rgb, checkered_mask * checkered_color.a);
	COLOR.rgb = mix(COLOR.rgb, fine_grid_color.rgb, fine_grid_mask * fine_grid_color.a);
	COLOR.rgb = mix(COLOR.rgb, coarse_grid_color.rgb, coarse_grid_mask * coarse_grid_color.a);
}