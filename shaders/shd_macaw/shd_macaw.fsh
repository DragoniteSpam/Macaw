varying vec2 v_vTexcoord;

uniform float u_Amplitude;
uniform vec2 u_Seed;
uniform vec2 u_Dimensions;

float rand(vec2 c) {
    // these numbers were chosen by Javascript's Math.random(), mostly to make
    // it look like i totally didn't just copy code from The Book of Shaders
    // like everyone else
    return fract(sin(dot(c + u_Seed, vec2(57.5527, 42.8601))) * 48529.7022) * u_Amplitude;
}

vec2 rand2(vec2 c) {
    return normalize(fract(sin((c + u_Seed) * mat2(0.242231, 0.464455, 0.462648, 0.457062)) * u_Amplitude) - 0.5);
}

float perlin(vec2 coord) {
    const vec2 offset = vec2(0, 1);
    vec2 c = coord * u_Dimensions;
    vec2 sub = c - floor(c);
    vec2 corner00 = rand2(c + offset.xx);
    vec2 corner10 = rand2(c + offset.yx);
    vec2 corner01 = rand2(c + offset.xy);
    vec2 corner11 = rand2(c + offset.yy);
    float grad00 = dot(corner00, offset.xx - sub);
    float grad10 = dot(corner10, offset.yx - sub);
    float grad01 = dot(corner01, offset.xy - sub);
    float grad11 = dot(corner11, offset.yy - sub);
    
    vec2 quintic = sub * sub * sub * (10.0 + sub * (6.0 * sub - 15.0));
    float h0 = mix(grad00, grad10, quintic.x);
    float h1 = mix(grad01, grad11, quintic.x);
    
    return mix(h0, h1, quintic.y) * 0.7 + 0.5;
}

void main() {
    gl_FragColor = vec4(perlin(v_vTexcoord), 0, 0, 1);
}