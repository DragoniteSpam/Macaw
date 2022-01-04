width = 128;
height = 128;
octaves = 4;
code_type = 0;

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
    }),
    (new EmuText(32, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT"),
]);