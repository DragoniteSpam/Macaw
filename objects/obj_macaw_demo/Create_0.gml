ui = new EmuCore(0, 0, window_get_width(), window_get_height());

ui.AddContent([
    new EmuText(32, EMU_AUTO, 256, 32, "[c_yellow]Macaw: Perlin noise"),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Width:", "128", "4...8192", 4, E_InputTypes.INT, function() {
    }))
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Height:", "128", "4...8192", 4, E_InputTypes.INT, function() {
    }))
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Octaves:", "4", "1...20", 4, E_InputTypes.INT, function() {
    }))
        .SetRealNumberBounds(1, 20),
    (new EmuRadioArray(32, EMU_AUTO, 256, 32, "Code type:", 0, function() {
    }))
        .AddOptions(["Native GML (cross-platform)", "DLL (Windows only)"]),
    new EmuButton(32, EMU_AUTO, 256, 32, "Generate", function() {
    }),
    (new EmuText(32, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT"),
]);