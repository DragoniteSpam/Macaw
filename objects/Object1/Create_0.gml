#macro TRIALS 10
#macro SIZE 1024
#macro OCTAVES 10

var t0 = get_timer();

repeat (TRIALS) {
    noise = perlin_generate(perlin_white_noise(SIZE, SIZE), OCTAVES);
}

show_debug_message("Generation took " + string((get_timer() - t0) / 1000000 / TRIALS) + " seconds on average");

sprite_index = perlin_to_sprite(noise);