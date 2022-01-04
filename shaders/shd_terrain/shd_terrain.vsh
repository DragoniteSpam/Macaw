attribute vec3 in_Position;

varying vec3 v_vWorld;

void main() {
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1);
    v_vWorld = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1)).xyz;
}