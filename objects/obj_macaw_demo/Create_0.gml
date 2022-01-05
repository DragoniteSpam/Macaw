width = 256;
height = 256;
octaves = 6;
code_type = 0;
demo_type = 0;
amplitude = 255;
seed = irandom(0xffffff);

sprite = -1;
vbuff = -1;

vbuff_width = width;
vbuff_height = height;

ui = new EmuCore(0, 0, window_get_width(), window_get_height());

ui.AddContent([
    new EmuText(32, EMU_AUTO, 256, 32, "[c_yellow]Macaw: Perlin noise"),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Width:", string(self.width), "16...2048", 4, E_InputTypes.INT, function() {
        obj_macaw_demo.width = real(self.value);
    }))
        .SetID("WIDTH")
        .SetRealNumberBounds(4, 8192),
    (new EmuInput(32, EMU_AUTO, 256, 32, "Height:", string(self.height), "16...2048", 4, E_InputTypes.INT, function() {
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
    (new EmuProgressBar(32, EMU_AUTO, 256, 32, 8, 1, 12, true, self.octaves, function() {
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
        obj_macaw_demo.seed = self.value;
        macaw_set_seed(obj_macaw_demo.seed);
    }))
        .SetRealNumberBounds(4, 8192),
    (new EmuRadioArray(32, EMU_AUTO, 256, 32, "Code type:", self.code_type, function() {
        obj_macaw_demo.code_type = self.value;
    }))
        .AddOptions(["Native GML (cross-platform)", "DLL (Windows only)"]),
    (new EmuRadioArray(32, EMU_AUTO, 256, 32, "Demo type:", self.demo_type, function() {
        obj_macaw_demo.demo_type = self.value;
    }))
        .AddOptions(["Noise sprite", "Terrain"]),
    new EmuButton(32, EMU_AUTO, 256, 32, "Generate", function() {
        var output = obj_macaw_demo.Generate();
        self.GetSibling("OUTPUT_GEN").text = "Generation time: " + string(output.noise) + " ms";
        self.GetSibling("OUTPUT_SPRITE").text = "Sprite time: " + string(output.sprite) + " ms";
        self.GetSibling("OUTPUT_TERRAIN").text = "Terrain time: " + string(output.terrain) + " ms";
    }),
    (new EmuRenderSurface(352, EMU_BASE, 640, 640, function() {
        draw_clear(c_black);
        obj_macaw_demo.Render(self.width, self.height);
    }, function() {
    }, function() {
    }))
        .SetID("3D"),
    new EmuText(1024, EMU_BASE, 256, 32, "YYC: " + (code_is_compiled() ? "True" : "Flase")),
    (new EmuText(1024, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT_GEN"),
    (new EmuText(1024, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT_SPRITE"),
    (new EmuText(1024, EMU_AUTO, 256, 32, ""))
        .SetID("OUTPUT_TERRAIN"),
]);

Generate = function() {
    if (self.sprite != -1) sprite_delete(self.sprite);
    if (self.vbuff != -1) vertex_delete_buffer(self.vbuff);
    
    var t0 = get_timer();
    switch (self.code_type) {
        case 0: var macaw = macaw_generate(self.width, self.height, self.octaves, self.amplitude); break;
        case 1: var macaw = macaw_generate_dll(self.width, self.height, self.octaves, self.amplitude); break;
    }
    var time_gen = (get_timer() - t0) / 1000;
    
    var t0 = get_timer();
    self.sprite = macaw.ToSpriteDLL();
    var time_sprite = (get_timer() - t0) / 1000;
    
    var t0 = get_timer();
    self.vbuff = macaw.ToVbuffDLL();
    vertex_freeze(self.vbuff);
    self.vbuff_width = width;
    self.vbuff_height = height;
    var time_terrain = (get_timer() - t0) / 1000;
    
    macaw.Destroy();
    
    return { noise: time_gen, sprite: time_sprite, terrain: time_terrain };
};

Render = function(w, h) {
    if (!sprite_exists(self.sprite)) {
        scribble("Upon generating some Perlin noise, the results will show up here.")
            .draw(32, 32);
    } else {
        switch (self.demo_type) {
            case 0:
                draw_sprite(self.sprite, 0, 0, 0);
                break;
            case 1:
                var cam = camera_get_active();
                var dist = max(64, point_distance(0, 0, self.vbuff_width, self.vbuff_height) / 1.4);
                camera_set_view_mat(cam, matrix_build_lookat(dist, dist, dist, 0, 0, 40, 0, 0, 1));
                camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -w / h, 1, 32000));
                camera_apply(cam);
                gpu_set_zwriteenable(true);
                gpu_set_ztestenable(true);
                shader_set(shd_terrain);
                var offset = matrix_build(-self.vbuff_width / 2, -self.vbuff_height / 2, 0, 0, 0, 0, 1, 1, 1);
                var rotation = matrix_build(0, 0, 0, 0, 0, current_time / 200, 1, 1, 1);
                matrix_set(matrix_world, matrix_multiply(offset, rotation));
                vertex_submit(self.vbuff, pr_trianglelist, -1);
                matrix_set(matrix_world, matrix_build_identity());
                shader_reset();
                gpu_set_zwriteenable(false);
                gpu_set_ztestenable(false);
                break;
        }
    }
};