varying vec2 v_vTexcoord;

uniform float u_Amplitude;
uniform sampler2D samplerCombine;

vec3 ValueToColor(float f) {
    const float SCALE_FACTOR = 16777215.0;
    float longValue = f * SCALE_FACTOR;
    vec3 valueAsColor = vec3(mod(longValue, 256.0), mod(longValue / 256.0, 256.0), longValue / 65536.0);
    return floor(valueAsColor) / 255.0;
}

float ValueFromColor(vec3 color) {
    const vec3 UNDO = vec3(1.0, 256.0, 65536.0) / 16777215.0 * 255.0;
    return dot(color, UNDO);
}

void main() {
    gl_FragColor.rgb = ValueToColor(ValueFromColor(texture2D(gm_BaseTexture, v_vTexcoord).rgb) + ValueFromColor(texture2D(samplerCombine, v_vTexcoord).rgb) * u_Amplitude);
    gl_FragColor.a = 1.0;
}