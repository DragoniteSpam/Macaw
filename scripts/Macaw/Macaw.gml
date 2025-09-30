#macro MACAW_VERSION            "1.1.0"

#macro MACAW_MAX_GEN_SIZE       16384

global.__macaw_seed = 0;

function macaw_generate_dll(w, h, octaves, amplitude) {
    w = min(MACAW_MAX_GEN_SIZE, w);
    h = min(MACAW_MAX_GEN_SIZE, h);
    static warned = false;
    var perlin = buffer_create(w * h * 4, buffer_fixed, 4);
    
    if (os_type == os_windows && os_browser == browser_not_a_browser) {
        __macaw_set_octaves(octaves);
        __macaw_set_height(amplitude);
        __macaw_generate(buffer_get_address(perlin), w, h);
        
        return new __macaw_class(perlin, w, h, amplitude);
    }
    
    if (!warned) {
        show_debug_message("DLL version of macaw_generate is supported on this target platform - using the GML version instead.");
        warned = true;
    }
    
    return macaw_generate(w, h, octaves, amplitude);
}

function macaw_generate_gml(w, h, octave_count, amplitude) {
    static macaw_white_noise = function(w, h) {
        if (global.__macaw_seed != random_get_seed()) {
            random_set_seed(global.__macaw_seed);
        }
        var array = array_create(w * h);
        var i = 0;
        repeat (w) {
            var j = 0;
            repeat (h) {
                array[@ i * h + j++] = random(1);
            }
            i++;
        }
        global.__macaw_seed = random_get_seed();
        return array;
    };
    
    static macaw_smooth_noise = function(base_noise, w, h, octave_count) {
        var base = w * h;
        
        static smooth_noise = buffer_create(10, buffer_fixed, 4);
        if (buffer_get_size(smooth_noise) != w * h * octave_count * 4) {
            buffer_resize(smooth_noise, w * h * octave_count * 4);
        }
        
        // the interpolation function you use can make quite a difference, it seems
        // https://web.archive.org/web/20220130085702/https://en.wikipedia.org/wiki/Perlin_noise#Implementation
        static macaw_lerp = lerp;
        
        static macaw_lerp_cubic = function(a, b, f) {
            return (b - a) * (3.0 - f * 2.0) * f * f + a;
        };
        
        static macaw_lerp_whatevers_better_than_cubic = function(a, b, f) {
            return (b - a) * ((f * (f * 6.0 - 15.0) + 10.0) * f * f * f) + a;
        };
        
        for (var octave = 0; octave < octave_count; octave++) {
            var period = 1 << octave;
            var frequency = 1 / period;
            
            var base_a = base * octave;
            
            var i = 0;
            repeat (w) {
                var i0 = (i div period) * period;
                var i1 = (i0 + period) % w;
                var hblend = (i - i0) * frequency;
                
                var base_b = base_a + i * h;
                
                var hblend3 = hblend * hblend * hblend;
                
                var j = 0;
                repeat (h) {
                    var j0 = (j div period) * period;
                    var j1 = (j0 + period) % h;
                    var vblend = (j - j0) * frequency;
                    
                    var b00 = base_noise[i0 * h + j0];
                    var b10 = base_noise[i1 * h + j0];
                    var b01 = base_noise[i0 * h + j1];
                    var b11 = base_noise[i1 * h + j1];
                    
                    //var top = macaw_lerp_whatevers_better_than_cubic(b00, b10, hblend);
                    //var bottom = macaw_lerp_whatevers_better_than_cubic(b01, b11, hblend);
                    //var middle = macaw_lerp_whatevers_better_than_cubic(top, bottom, vblend);
                    var hblend_f = ((hblend * (hblend * 6.0 - 15.0) + 10.0) * hblend3);
                    var top = (b10 - b00) * hblend_f + b00;
                    var bottom = (b11 - b01) * hblend_f + b01;
                    
                    var middle = (bottom - top) * ((vblend * (vblend * 6.0 - 15.0) + 10.0) * vblend * vblend * vblend) + top;
                    buffer_poke(smooth_noise, (base_b + j++) * 4, buffer_f32, middle);
                }
                i++;
            }
        }
        
        return smooth_noise;
    };
    
    w = min(MACAW_MAX_GEN_SIZE, w);
    h = min(MACAW_MAX_GEN_SIZE, h);
    var base_noise = macaw_white_noise(w, h);
    var len = w * h * 4;
    var persistence = 0.5;
    var amp = 1;
    var total_amplitude = 0;
    
    var smooth_noise = macaw_smooth_noise(base_noise, w, h, octave_count);
    
    var perlin = buffer_create(len, buffer_fixed, 4);
    
    for (var o = octave_count - 1; o >= 0; o--) {
        amp *= persistence;
        total_amplitude += amp;
        var base_a = w * h * o;
        
        var i = 0;
        repeat (w) {
            var base_b = i++ * h;
            var j = 0;
            repeat (h) {
                buffer_poke(perlin, (base_b + j) * 4, buffer_f32, buffer_peek(perlin, (base_b + j) * 4, buffer_f32) + buffer_peek(smooth_noise, (base_a + base_b + j) * 4, buffer_f32) * amp);
                j++;
            }
        }
    }
    
    var index = 0;
    repeat (len / 4) {
        buffer_poke(perlin, index, buffer_f32, buffer_peek(perlin, index, buffer_f32) / total_amplitude * amplitude);
        index += 4;
    }
    
    return new __macaw_class(perlin, w, h, amplitude);
}

function macaw_generate_shader(w, h, octave_count, amplitude) {
    static target_surface_format = surface_format_is_supported(surface_r32float) ? surface_r32float : surface_rgba8unorm;
    
    var surface = surface_create(w, h, target_surface_format);
    surface_set_target(surface);
    draw_clear(c_black);
    shader_set(shd_macaw);
    
    var colour_write = gpu_get_colorwriteenable();
    gpu_set_colorwriteenable(true, false, false, false);
    
    var shader_seed = ((global.__macaw_seed / 1000) % 50) + 50;
    
    shader_set_uniform_f(shader_get_uniform(shd_macaw, "u_Amplitude"), amplitude);
    shader_set_uniform_f(shader_get_uniform(shd_macaw, "u_Seed"), shader_seed);
    shader_set_uniform_f(shader_get_uniform(shd_macaw, "u_Octaves"), octave_count);
    
	draw_primitive_begin(pr_trianglestrip);
	draw_vertex(0, 0);
	draw_vertex(w, 0);
	draw_vertex(0, h);
	draw_vertex(w, h);
	draw_primitive_end();
    
    surface_reset_target();
    shader_reset();
    
    var perlin = buffer_create(w * h * 4, buffer_fixed, 1);
    buffer_get_surface(perlin, surface, 0);
    surface_free(surface);
    
    gpu_set_colorwriteenable(colour_write);
    
    return new __macaw_class(perlin, w, h, amplitude);
}

function macaw_generate_perlin(w, h, octave_count, amplitude) {
    static source_table = array_create_ext(256, function(index) {
        return index;
    });
    
    static target_surface_format = surface_format_is_supported(surface_r32float) ? surface_r32float : surface_rgba8unorm;
    
    var surface = surface_create(w, h, target_surface_format);
    surface_set_target(surface);
    draw_clear(c_black);
    shader_set(shd_macaw_perlin);
    
    var colour_write = gpu_get_colorwriteenable();
    gpu_set_colorwriteenable(true, false, false, false);
    
    var shader_seed = ((global.__macaw_seed / 1000) % 50) + 50;
    var current_seed = random_get_seed();
    random_set_seed(global.__macaw_seed);
    var table = array_shuffle(source_table);
    random_set_seed(current_seed);
    
    shader_set_uniform_f(shader_get_uniform(shd_macaw_perlin, "u_Amplitude"), amplitude);
    shader_set_uniform_f(shader_get_uniform(shd_macaw_perlin, "u_Seed"), shader_seed);
    shader_set_uniform_i_array(shader_get_uniform(shd_macaw_perlin, "u_Table"), table);
    
	draw_primitive_begin_texture(pr_trianglestrip, -1);
	draw_vertex_texture(0, 0, 0, 0);
	draw_vertex_texture(w, 0, 1, 0);
	draw_vertex_texture(0, h, 0, 1);
	draw_vertex_texture(w, h, 1, 1);
	draw_primitive_end();
    
    surface_reset_target();
    shader_reset();
    
    var perlin = buffer_create(w * h * 4, buffer_fixed, 1);
    buffer_get_surface(perlin, surface, 0);
    surface_free(surface);
    
    gpu_set_colorwriteenable(colour_write);
    
    return new __macaw_class(perlin, w, h, amplitude);
}

function macaw_version() {
    show_debug_message("Macaw GML version: " + MACAW_VERSION);
    if (os_type == os_windows && os_browser == browser_not_a_browser) {
        show_debug_message("Macaw DLL version: " + string(__macaw_version()));
    } else {
        show_debug_message("Macaw DLL version: N/A");
    }
}

function macaw_set_seed(seed) {
    // MD5 will produce a hex value that's 32 hextets long, which will cause problems
    // if we try to convert it to an int64, so we only use the first 15 digits
    seed = int64(ptr(string_copy(md5_string_utf8(string(seed)), 1, 15)));
    global.__macaw_seed = seed;
    __macaw_set_seed(seed);
}

function __macaw_class(noise, w, h, amplitude) constructor {
    static format = undefined;
    if (self.format == undefined) {
        vertex_format_begin();
        vertex_format_add_position_3d();
        self.format = vertex_format_end();
    }
    
    self.noise = noise;
    self.width = w;
    self.height = h;
    self.amplitude = amplitude;
            
    static Get = function(x, y) {
        x = floor(clamp(x, 0, self.width - 1));
        y = floor(clamp(y, 0, self.height - 1));
        return buffer_peek(self.noise, ((x * self.height) + y) * 4, buffer_f16);
    };
    
    static GetNormalized = function(u, v) {
        return self.Get(x * self.width, y * self.height);
    };
    
    static GetNormalised = GetNormalized;
    
    static Destroy = function() {
        buffer_delete(self.noise);
    };
    
    #region Helper functions that may ocasionally be useful
    static ToSprite = function() {
        static target_surface_format = surface_format_is_supported(surface_r32float) ? surface_r32float : surface_rgba8unorm;
        var surfacer32 = surface_create(self.width, self.height, target_surface_format);
        var surfacergba8 = surface_create(self.width, self.height);
        buffer_set_surface(self.noise, surfacer32, 0);
        surface_set_target(surfacergba8);
        draw_clear(c_black);
        shader_set(shd_macaw_spritification);
        shader_set_uniform_f(shader_get_uniform(shd_macaw_spritification, "u_Amplitude"), self.amplitude);
        draw_surface(surfacer32, 0, 0);
        shader_reset();
        surface_reset_target();
        var spr = sprite_create_from_surface(surfacergba8, 0, 0, self.width, self.height, false, false, 0, 0);
        surface_free(surfacergba8);
        surface_free(surfacer32);
        return spr;
    };
    
    static ToVbuff = function() {
        var vbuff = vertex_create_buffer();
        vertex_begin(vbuff, self.format);
        
        var noise = self.noise;
        for (var i = 0; i < self.width - 1; i++) {
            for (var j = 0; j < self.height - 1; j++) {
                var h00 = buffer_peek(noise, 4 * ( j      * self.width + i    ), buffer_f32);
                var h01 = buffer_peek(noise, 4 * ((j + 1) * self.width + i    ), buffer_f32);
                var h10 = buffer_peek(noise, 4 * ( j      * self.width + i + 1), buffer_f32);
                var h11 = buffer_peek(noise, 4 * ((j + 1) * self.width + i + 1), buffer_f32);
                vertex_position_3d(vbuff, i,     j,     h00);
                vertex_position_3d(vbuff, i + 1, j,     h10);
                vertex_position_3d(vbuff, i + 1, j + 1, h11);
                vertex_position_3d(vbuff, i + 1, j + 1, h11);
                vertex_position_3d(vbuff, i,     j + 1, h01);
                vertex_position_3d(vbuff, i,     j,     h00);
            }
        }
    
        vertex_end(vbuff);
    
        return vbuff;
    }

    static ToVbuffDLL = function() {
        static warned = false;
        
        if (os_type == os_windows && os_browser == browser_not_a_browser) {
            var data = buffer_create((self.width - 1) * (self.height - 1) * 4 * 18, buffer_fixed, 1);
            buffer_fill(data, 0, buffer_f32, 0, buffer_get_size(data));
            __macaw_to_vbuff(buffer_get_address(self.noise), buffer_get_address(data), self.width, self.height);
            var vbuff = vertex_create_buffer_from_buffer(data, self.format);
            buffer_delete(data);
            return vbuff;
        }
    
        if (!warned) {
            show_debug_message("DLL version of macaw_to_vbuff is not supported on this target platform - using the GML version instead.");
            warned = true;
        }
    
        return self.ToVbuff();
    }
    #endregion
}

macaw_version();