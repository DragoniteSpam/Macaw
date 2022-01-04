width = 128;
height = 128;
octaves = 4;
code_type = 0;

sprite = -1;

ui = new EmuCore(0, 0, window_get_width(), window_get_height());

ui.AddContent([
    new EmuText(32, EMU_AUTO, 256, 32, "[c_yellow]Macaw: Perlin noise"),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Width:", string(self.width), "4...8192", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.width = real(self.value);
    }))
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Height:", string(self.height), "4...8192", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.height = real(self.value);
    }))
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Octaves:", string(self.octaves), "1...20", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.octaves = real(self.value);
    }))
        .SetRealNumberBounds(1, 20),
    (new EmuRadioArray(32, EMU_AUTO, 256, 32, "Code type:", self.code_type, function() {
        obj_macaw_demo.code_type = self.value;
    }))
        .AddOptions(["Native GML (cross-platform)", "DLL (Windows only)"]),
    new EmuButton(32, EMU_AUTO, 256, 32, "Generate", function() {
        var output = obj_macaw_demo.Generate();
        self.GetSibling("OUTPUT_GEN").text = "Generation time: " + string(output.noise) + " ms";
        self.GetSibling("OUTPUT_SPRITE").text = "Sprite creation time: " + string(output.sprite) + " ms";
    }),
    (new EmuText(32, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT_GEN"),
    (new EmuText(32, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT_SPRITE"),
]);

Generate = function() {
    if (sprite_exists(self.sprite)) sprite_delete(self.sprite);
    
    var t0 = get_timer();
    switch (self.code_type) {
        case 0: var macaw = macaw_generate(self.width, self.height, self.octaves, 256); break;
        case 1: var macaw = macaw_generate_dll(self.width, self.height, self.octaves, 256); break;
    }
    var time_gen = (get_timer() - t0) / 1000;
    
    var t0 = get_timer();
    self.sprite = macaw_to_sprite(macaw);
    var time_sprite = (get_timer() - t0) / 1000;
    
    return { noise: time_gen, sprite: time_sprite };
};