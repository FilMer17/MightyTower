shader_type canvas_item;

uniform vec4 current_color: hint_color;

void fragment() {
	vec4 final = mix(texture(TEXTURE, UV), current_color, texture(TEXTURE, UV).a);
	COLOR = final;
}