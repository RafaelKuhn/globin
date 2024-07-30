shader_type spatial;
render_mode unshaded, cull_back;

uniform sampler2D image;
uniform float _intensity = 0.0;
uniform float _time = 0.0;


void fragment() {
	vec2 tri_wave_uvs = 1.0 - vec2(UV.x, abs( mod( UV.y * 2.0 + _time * _intensity, 2.0 ) - 1.0 ));
	ALBEDO = texture(image, tri_wave_uvs).rgb;
	ALPHA = 1.0 - pow(UV.y, 3);
}