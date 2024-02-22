// Adapted from Nathan Hunter:

/*
 * MIT License
 * 
 * Copyright (c) 2023 Nathan Hunter
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

// see: https://adrianb.io/2014/08/09/perlinnoise.html

#define M_PI   3.1415926535897932384626433832795

vec3 fade(vec3 t) {
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float grad(int hash, float x, float y, float z) {
    float h = mod(float(hash), 16.0);                                    
    float u = h < 8.0 ? x : y;                
    
    float v;                                             
    
    if(h < 4.0)                               
        v = y;
    else if(h == 12.0 || h == 14.0) 
        v = x;
    else                                                 
        v = z;
    
    return (mod(h, 2.0) == 0.0 ? u : -u) + (mod(h, 3.0) < 2.0 ? v : -v); 	
}

float perlin(vec3 pos, int[256] table) {
    ivec3 ii = ivec3(mod(pos, 256.0));
    ivec3 jj = ivec3(mod(pos + 1.0, 256.0));
	
	int aaa = table[table[table[ii.x] + ii.y]+ ii.z];
    int aba = table[table[table[ii.x] + jj.y]+ ii.z];
    int aab = table[table[table[ii.x] + ii.y]+ jj.z];
    int abb = table[table[table[ii.x] + jj.y]+ jj.z];
    int baa = table[table[table[jj.x] + ii.y]+ ii.z];
    int bba = table[table[table[jj.x] + jj.y]+ ii.z];
    int bab = table[table[table[jj.x] + ii.y]+ jj.z];
    int bbb = table[table[table[jj.x] + jj.y]+ jj.z];
	
    vec3 ff = fract(pos);
    vec3 faded = fade(ff);
   
    float x1 = mix(grad(aaa, ff.x, ff.y,       ff.z), grad(baa, ff.x - 1.0, ff.y,       ff.z), faded.x);                                     
    float y1 = mix(grad(aba, ff.x, ff.y - 1.0, ff.z), grad(bba, ff.x - 1.0, ff.y - 1.0, ff.z), faded.x);
    float z1 = mix(x1, y1, faded.y);

    float x2 = mix(grad(aab, ff.x, ff.y,       ff.z - 1.0), grad(bab, ff.x - 1.0, ff.y,       ff.z - 1.0), faded.x);
    float y2 = mix(grad(abb, ff.x, ff.y - 1.0, ff.z - 1.0), grad(bbb, ff.x - 1.0, ff.y - 1.0, ff.z - 1.0), faded.x);
    float z2 = mix (x2, y2, faded.y);
    
	return (mix(z1, z2, faded.z) + 1.0) * 0.5;	
}

varying vec2 v_vTexcoord;

uniform float u_Amplitude;
uniform float u_Seed;
uniform int u_Table[256]; // permutation table of values 0 - 255

void main() {
	float value = perlin(vec3(sin(abs(v_vTexcoord * 0.5) * M_PI * 0.5) * u_Seed, fract(u_Seed) * 1.387), u_Table);
    gl_FragColor = vec4(value * u_Amplitude, 0, 0, 1.0);
}