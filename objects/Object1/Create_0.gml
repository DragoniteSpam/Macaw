#macro TRIALS 1
#macro SIZE 1024
#macro OCTAVES 8

var t0 = get_timer();

repeat (TRIALS) {
    noise = macaw_generate(SIZE, SIZE, OCTAVES, 255);
}

show_debug_message("Generation took " + string((get_timer() - t0) / 1000000 / TRIALS) + " seconds on average");

sprite_index = macaw_to_sprite(noise);

macaw_destroy(noise);