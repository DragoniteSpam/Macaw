varying vec2 v_vTexcoord;

float rand(vec2 c) {
    return fract(sin(dot(c, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    gl_FragColor.rgb = vec3(rand(v_vTexcoord));
    gl_FragColor.a = 1.0;
}