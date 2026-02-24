//-----------------------------------------------------------------------------
// name: orbit.ck
// desc: this example demonstrates ChuGUI working with a GOrbitCamera.
//       the user can orbit, zoom, and pan the camera while interacting
//       with a 3D GUI panel from any angle.
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

// Set up orbit camera
GOrbitCamera cam --> GG.scene();
GG.scene().camera(cam);
cam.target(@(0, 0, -5));

GG.scene().backgroundColor(@(0.15, 0.18, 0.22));
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);

// A world-space panel floating in 3D
ChuGUI gui --> GG.scene();
gui.units(ChuGUI.WORLD);
gui.posZ(-5);

// State
0.5 => float volume;
440.0 => float freq;
0 => int mute;
0 => int clickCount;

while (true) {
    GG.nextFrame() => now;

    gui.label("Orbit Camera Demo", @(0, 2));

    if (gui.button("Click Me", @(0, 1.2))) {
        clickCount++;
        <<< "Clicked", clickCount, "times" >>>;
    }

    UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.15);
    gui.label("Clicks: " + clickCount, @(0, 0.6));
    UIStyle.popVar();

    gui.slider("Volume", @(0, 0), 0, 1, volume) => volume;
    gui.slider("Frequency", @(0, -0.8), 20, 2000, freq) => freq;
    gui.checkbox("Mute", @(0, -1.6), mute) => mute;
}
