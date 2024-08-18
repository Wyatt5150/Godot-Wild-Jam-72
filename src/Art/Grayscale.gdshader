shader_type canvas_item;

uniform float saturation = 0.0;

void fragment() {
    vec3 c = texture(TEXTURE, UV).rgb;

    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

    COLOR.rgb = c;
}