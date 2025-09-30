//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to render a colorpicker
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../src/ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();

@(1, 0, 0) => vec3 color;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.colorPicker("Default", @(0, 0), color) => color;

    <<< "Color:", color >>>;
}