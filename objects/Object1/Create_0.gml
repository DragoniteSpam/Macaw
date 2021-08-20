#macro TRIALS 10
#macro SIZE 1024
#macro OCTAVES 10

var t0 = get_timer();

repeat (TRIALS) {
    noise = macaw_generate(SIZE, SIZE, OCTAVES);
}

show_debug_message("Generation took " + string((get_timer() - t0) / 1000000 / TRIALS) + " seconds on average");

sprite_index = macaw_to_sprite(noise);