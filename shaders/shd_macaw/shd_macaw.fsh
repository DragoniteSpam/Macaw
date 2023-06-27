varying vec2 v_vTexcoord;

float rand(vec2 c) {
    // these numbers were chosen by Javascript's Math.random(), mostly to make
    // it look like i totally didn't just copy code from The Book of Shaders
    // like everyone else
    return fract(sin(dot(c, vec2(57.5527, 42.8601))) * 48529.7022);
}

void main() {
    gl_FragColor = vec4(rand(v_vTexcoord), 0, 0, 1);
}