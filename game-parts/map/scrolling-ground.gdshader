shader_type spatial;
render_mode unshaded, cull_back;

uniform sampler2D image;
uniform float _intensity = 0.0;
uniform float _time = 0.0;

//void vertex() {
//    VERTEX = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
//    NORMAL = normalize((MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz);
//}

void fragment() {
	vec2 tri_wave_uvs = 1.0 - vec2(UV.x, abs( mod( UV.y * 2.0 + _time * _intensity, 2.0 ) - 1.0 ));
//	tri_wave_uvs = UV;
//	tri_wave_uvs.y += TIME * 0.2;
//	ALBEDO = vec3(tri_wave_uvs.y, 0.0, 0.0);
	ALBEDO = texture(image, tri_wave_uvs).rgb;
}