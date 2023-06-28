#macro MACAW_VERSION            "1.0.5"

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

function macaw_generate(w, h, octave_count, amplitude) {
    static pixel = undefined;
    
    if (pixel == undefined) {
        var s = surface_create(1, 1);
        surface_set_target(s);
        draw_clear(c_white);
        surface_reset_target();
        pixel = sprite_create_from_surface(s, 0, 0, 1, 1, false, false, 0, 0);
        surface_free(s);
    }
    
    var octaves = array_create(octave_count);
    
    octaves[0] = surface_create(w, h, surface_r32float);
    surface_set_target(octaves[0]);
    shader_set(shd_macaw);
    shader_set_uniform_f(shader_get_uniform(shd_macaw, "u_Amplitude"), amplitude);
    draw_sprite_stretched(pixel, 0, 0, 0, w, h);
    shader_reset();
    surface_reset_target();
    
    var perlin = buffer_create(w * h * 4, buffer_fixed, 1);
    buffer_get_surface(perlin, octaves[0], 0);
    surface_free(octaves[0]);
    
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
        return buffer_peek(self.noise, ((x * self.height) + y) * 2, buffer_f16);
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
        var surfacer32 = surface_create(self.width, self.height, surface_r32float);
        var surfacergba8 = surface_create(self.width, self.height);
        buffer_set_surface(self.noise, surfacer32, 0);
        surface_set_target(surfacergba8);
        draw_clear(c_black);
        draw_surface(surfacer32, 0, 0);
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