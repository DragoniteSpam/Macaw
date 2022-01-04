#extension GL_OES_standard_derivatives : enable

varying vec3 v_vWorld;

const vec3 LIGHT = vec3(-1);

void main() {
    vec3 dx = dFdx(v_vWorld);
    vec3 dy = dFdy(v_vWorld);
    vec3 norm = normalize(cross(dx,dy));
    float NdotL = max(0.35, -dot(normalize(norm), LIGHT));
    gl_FragColor.rgb = vec3(0.05, 0.4, 0.12) * NdotL;
    gl_FragColor.a = 1.0;
}