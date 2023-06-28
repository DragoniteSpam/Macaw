varying vec2 v_vTexcoord;

uniform float u_Amplitude;

void main() {
    gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).rrr / u_Amplitude, 1);
}