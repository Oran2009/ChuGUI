//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render continuous and discrete knobs
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.5 => float val1;
0.0 => float val2;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    // Continuous knob
    gui.knob("Knob", @(-0.5, 0.3), 0, 1, val1) => val1;
    gui.label("Continuous: " + val1, @(-0.5, -0.05));

    // Discrete knob with 5 steps
    gui.discreteKnob("DiscreteKnob", @(0.5, 0.3), 0, 10, 5, val2) => val2;
    gui.label("Discrete: " + val2, @(0.5, -0.05));
}
