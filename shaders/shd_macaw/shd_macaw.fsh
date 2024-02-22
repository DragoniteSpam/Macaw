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

float fade(float t) {
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
    int xi = int(mod(pos.x, 256.0));                           
    int yi = int(mod(pos.y, 256.0));                              
    int zi = int(mod(pos.z, 256.0));  
	
	int xj = int(mod(pos.x + 1.0, 256.0));
	int yj = int(mod(pos.y + 1.0, 256.0));
	int zj = int(mod(pos.z + 1.0, 256.0));
	
	int aaa = table[table[table[xi] + yi]+ zi];
    int aba = table[table[table[xi] + yj]+ zi];
    int aab = table[table[table[xi] + yi]+ zj];
    int abb = table[table[table[xi] + yj]+ zj];
    int baa = table[table[table[xj] + yi]+ zi];
    int bba = table[table[table[xj] + yj]+ zi];
    int bab = table[table[table[xj] + yi]+ zj];
    int bbb = table[table[table[xj] + yj]+ zj];
	
    float xf = fract(pos.x);
    float yf = fract(pos.y);
    float zf = fract(pos.z);
    
    float u = fade(xf);
    float v = fade(yf);
    float w = fade(zf);
   
    float x1 = mix(grad(aaa, xf, yf,       zf), grad(baa, xf - 1.0, yf,       zf), u);                                     
    float y1 = mix(grad(aba, xf, yf - 1.0, zf), grad(bba, xf - 1.0, yf - 1.0, zf), u);
    float z1 = mix(x1, y1, v);

    float x2 = mix(grad(aab, xf, yf,       zf - 1.0), grad(bab, xf - 1.0, yf,       zf - 1.0), u);
    float y2 = mix(grad(abb, xf, yf - 1.0, zf - 1.0), grad(bbb, xf - 1.0, yf - 1.0, zf - 1.0), u);
    float z2 = mix (x2, y2, v);
    
	return (mix(z1, z2, w) + 1.0) * 0.5;	
}

varying vec2 v_vTexcoord;

uniform float u_Seed;
uniform int u_Table[256]; // permutation table of values 0 - 255

void main() {
	float value = perlin(vec3(sin(abs(v_vTexcoord * 0.5) * M_PI * 0.5) * u_Seed, fract(u_Seed) * 1.387), u_Table);
    gl_FragColor = vec4(vec3(value), 1.0);
}