//-----------------------------------------------------------------------------
// name: perspective.ck
// desc: this example shows ChuGUI working with a perspective camera.
//       a panel is positioned and rotated in 3D space.
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

// Use perspective camera
GG.camera().perspective();
GG.scene().backgroundColor(@(0.2, 0.2, 0.3));
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);

// Create a ChuGUI panel in 3D space
ChuGUI gui --> GG.scene();
gui.units(ChuGUI.WORLD);
gui.posZ(-5);       // 5 units in front
gui.rotY(0.3);      // slightly angled

0 => float sliderVal;
0 => int checkState;

while (true) {
    GG.nextFrame() => now;

    gui.label("3D ChuGUI", @(0, 1.5));

    if (gui.button("Click Me", @(0, 0.8))) {
        <<< "Button clicked!" >>>;
    }

    gui.slider("Volume", @(0, 0), 0, 100, sliderVal) => sliderVal;

    gui.checkbox("Enable", @(0, -0.8), checkState) => checkState;

    <<< "slider:", sliderVal, "check:", checkState >>>;
}
