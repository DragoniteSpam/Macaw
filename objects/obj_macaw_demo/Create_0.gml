width = 128;
height = 128;
octaves = 8;
code_type = 0;
amplitude = 255;
seed = irandom(0xffffffff);

sprite = -1;

ui = new EmuCore(0, 0, window_get_width(), window_get_height());

ui.AddContent([
    new EmuText(32, EMU_AUTO, 256, 32, "[c_yellow]Macaw: Perlin noise"),
    //new EmuText(32, EMU_AUTO, 256, 32, "GML version: " + MACAW_VERSION),
    //new EmuText(32, EMU_AUTO, 256, 32, "DLL version: " + __macaw_version()),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Width:", string(self.width), "4...8192", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.width = real(self.value);
    }))
        .SetID("WIDTH")
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Height:", string(self.height), "4...8192", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.height = real(self.value);
    }))
        .SetID("HEIGHT")
        .SetRealNumberBounds(4, 8192),
    new EmuButton(32 + 64 * 0, EMU_AUTO, 64, 32, "64", function() {
        obj_macaw_demo.width = 64;
        obj_macaw_demo.height = 64;
        self.GetSibling("WIDTH").SetValue("64");
        self.GetSibling("HEIGHT").SetValue("64");
    }),
    new EmuButton(32 + 64 * 1, EMU_INLINE, 64, 32, "128", function() {
        obj_macaw_demo.width = 128;
        obj_macaw_demo.height = 128;
        self.GetSibling("WIDTH").SetValue("128");
        self.GetSibling("HEIGHT").SetValue("128");
    }),
    new EmuButton(32 + 64 * 2, EMU_INLINE, 64, 32, "256", function() {
        obj_macaw_demo.width = 256;
        obj_macaw_demo.height = 256;
        self.GetSibling("WIDTH").SetValue("256");
        self.GetSibling("HEIGHT").SetValue("256");
    }),
    new EmuButton(32 + 64 * 3, EMU_INLINE, 64, 32, "640", function() {
        obj_macaw_demo.width = 640;
        obj_macaw_demo.height = 640;
        self.GetSibling("WIDTH").SetValue("640");
        self.GetSibling("HEIGHT").SetValue("640");
    }),
    (new EmuText(32, EMU_AUTO, 256, 32, "Octaves: " + string(self.octaves)))
        .SetID("OCTAVES_LABEL"),
    (new EmuProgressBar(32, EMU_AUTO, 256, 32, 8, 1, 16, true, self.octaves, function() {
        obj_macaw_demo.octaves = self.value;
        self.GetSibling("OCTAVES_LABEL").text = "Octaves: " + string(self.value);
    }))
        .SetIntegersOnly(true),
    (new EmuText(32, EMU_AUTO, 256, 32, "Amplitude: " + string(self.amplitude)))
        .SetID("AMPLITUDE_LABEL"),
    (new EmuProgressBar(32, EMU_AUTO, 256, 32, 8, 4, 255, true, self.amplitude, function() {
        obj_macaw_demo.amplitude = self.value;
        self.GetSibling("AMPLITUDE_LABEL").text = "Amplitude: " + string(self.value);
    }))
        .SetIntegersOnly(true),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Seed:", string(self.seed), "any string will do", 32, E_InputTypes.STRING, function() {
        if (string_length(self.value) > 0 && string_digits(self.value) == self.value) {
            obj_macaw_demo.seed = real(self.value);
        } else {
            // MD5 will produce a hex value that's 32 hextets long, which will cause problems
            // if we try to convert it to an int64, so we only use the first 15 digits
            obj_macaw_demo.seed = real(ptr(string_copy(md5_string_utf8(self.value), 1, 15)));
        }
        macaw_set_seed(obj_macaw_demo.seed);
    }))
        .SetID("HEIGHT")
        .SetRealNumberBounds(4, 8192),
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
        case 0: var macaw = macaw_generate(self.width, self.height, self.octaves, self.amplitude); break;
        case 1: var macaw = macaw_generate_dll(self.width, self.height, self.octaves, self.amplitude); break;
    }
    var time_gen = (get_timer() - t0) / 1000;
    
    var t0 = get_timer();
    self.sprite = macaw_to_sprite(macaw);
    var time_sprite = (get_timer() - t0) / 1000;
    
    return { noise: time_gen, sprite: time_sprite };
};