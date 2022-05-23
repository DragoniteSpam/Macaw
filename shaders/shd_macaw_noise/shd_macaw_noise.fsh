varying vec2 v_vTexcoord;

uniform float u_Amplitude;

float rand(vec2 c, float amplitude) {
    // these numbers were chosen by Javascript's Math.random(), mostly to make
    // it look like i totally didn't just copy code from The Book of Shaders
    // like everyone else
    return fract(sin(dot(c, vec2(57.5527, 42.8601))) * 48529.7022) * amplitude;
}

vec3 ValueToColor(float f) {
    const float SCALE_FACTOR = 16777215.0;
    float longValue = f * SCALE_FACTOR;
    vec3 valueAsColor = vec3(mod(longValue, 256.0), mod(longValue / 256.0, 256.0), longValue / 65536.0);
    return floor(valueAsColor) / 255.0;
}

void main() {
    gl_FragColor.rgb = ValueToColor(rand(v_vTexcoord, u_Amplitude));
    gl_FragColor.a = 1.0;
}