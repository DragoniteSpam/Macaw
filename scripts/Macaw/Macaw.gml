#macro MACAW_VERSION "0.0.1"

function macaw_generate_gml(w, h, octave_count) {
    static macaw_white_noise = function(w, h) {
        var array = array_create(w * h);
        for (var i = 0; i < w; i++) {
            for (var j = 0; j < h; j++) {
                array[@ i * h + j] = random(1);
            }
        }
        return array;
    };
    
    static macaw_smooth_noise = function(base_noise, w, h, octave_count) {
        var base = w * h;
        var len = base * octave_count;
        var smooth_noise = array_create(len);
        for (var octave = 0; octave < octave_count; octave++) {
            var period = 1 << octave;
            var frequency = 1 / period;
            
            var base_a = base * octave;
            
            for (var i = 0; i < w; i++) {
                var i0 = (i div period) * period;
                var i1 = (i0 + period) % w;
                var hblend = (i - i0) * frequency;
                
                var base_b = base_a + i * h;
                
                for (var j = 0; j < h; j++) {
                    var j0 = (j div period) * period;
                    var j1 = (j0 + period) % h;
                    var vblend = (j - j0) * frequency;
                    
                    var b00 = base_noise[i0 * h + j0];
                    var b10 = base_noise[i1 * h + j0];
                    var b01 = base_noise[i0 * h + j1];
                    var b11 = base_noise[i1 * h + j1];
                    
                    var top = lerp(b00, b10, hblend);
                    var bottom = lerp(b01, b11, hblend);
                    smooth_noise[@ base_b + j] = lerp(top, bottom, vblend);
                }
            }
        }
        
        return smooth_noise;
    };
    
    var base_noise = macaw_white_noise(w, h);
    var len = w * h * 4;
    var persistence = 0.5;
    var amplitude = 1;
    var total_amplitude = 0;
    
    var smooth_noise = macaw_smooth_noise(base_noise, w, h, octave_count);
    
    var perlin = buffer_create(len, buffer_fixed, 4);
    
    for (var o = octave_count - 1; o >= 0; o--) {
        amplitude *= persistence;
        total_amplitude += amplitude;
        var base_a = w * h * o;
        
        for (var i = 0; i < w; i++) {
            var base_b = i * h;
            for (var j = 0; j < h; j++) {
                buffer_poke(perlin, (base_b + j) * 4, buffer_f32, buffer_peek(perlin, (base_b + j) * 4, buffer_f32) + smooth_noise[base_a + base_b + j] * amplitude);
            }
        }
    }
    
    for (var i = 0; i < len; i += 4) {
        buffer_poke(perlin, i, buffer_f32, buffer_peek(perlin, i, buffer_f32) / total_amplitude);
    }
    
    return perlin;
}

function macaw_to_sprite(noise, w, h) {
    var buffer = buffer_create(w * h * 4, buffer_fixed, 4);
    buffer_seek(noise, buffer_seek_start, 0);
    repeat (w * h) {
        var intensity = floor(buffer_read(noise, buffer_f32) * 255);
        var c = 0xff000000 | make_colour_rgb(intensity, intensity, intensity);
        buffer_write(buffer, buffer_u32, c);
    }
    var surface = surface_create(w, h);
    buffer_set_surface(buffer, surface, 0);
    var spr = sprite_create_from_surface(surface, 0, 0, w, h, false, false, 0, 0);
    surface_free(surface);
    buffer_delete(buffer);
    return spr;
}

function macaw_version_gml() {
    show_debug_message("Macaw GML version: " + MACAW_VERSION);
}

macaw_version_gml();

show_debug_message(macaw_version());