//-----------------------------------------------------------------------------
// name: mixed.ck
// desc: this example shows multiple ChuGUI panels in 3D: a world-space
//       control panel and a camera-parented HUD, both working simultaneously.
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

GG.camera().perspective();
GG.scene().backgroundColor(@(0.15, 0.15, 0.2));
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);

// World-space control panel (angled in 3D)
ChuGUI controls --> GG.scene();
controls.units(ChuGUI.WORLD);
controls.posZ(-4);
controls.rotY(0.2);

// HUD panel parented to camera (always faces viewer)
ChuGUI hud --> GG.camera();
hud.units(ChuGUI.WORLD);
hud.posZ(-2);

0 => int score;
50.0 => float speed;

while (true) {
    GG.nextFrame() => now;

    // --- World-space controls (angled panel) ---

    controls.label("Controls", @(0, 1));

    if (controls.button("Score +1", @(0, 0.3))) {
        score++;
    }

    controls.slider("Speed", @(0, -0.5), 0, 100, speed) => speed;

    // --- HUD (screen-fixed) ---

    UIStyle.pushVar(UIStyle.VAR_LABEL_CONTROL_POINTS, @(0, 1));
    UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.15);
    hud.label("Score: " + score, @(-0.8, 0.8));
    hud.label("Speed: " + speed, @(-0.8, 0.65));
    UIStyle.popVar(2);
}
