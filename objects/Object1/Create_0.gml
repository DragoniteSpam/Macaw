#macro trials 10

var t0 = get_timer();

repeat (trials) {
    noise = perlin_generate(perlin_white_noise(512, 512), 6);
}

show_debug_message("Generation took " + string((get_timer() - t0) / 1000000 / trials) + " seconds on average");

sprite_index = perlin_to_sprite(noise);