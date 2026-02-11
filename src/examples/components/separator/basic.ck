//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to use separators and spacers in layouts
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(@(0.15, 0.15, 0.15));

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.5 => float vol;
0.5 => float pan;
0 => int muted;

while (true) {
    GG.nextFrame() => now;

    // Column with separators between groups
    gui.beginColumn(@(-0.95, 0.9));
        gui.label("Volume");
        gui.slider("vol", 0, 1, vol) => vol;

        gui.separator();

        gui.label("Pan");
        gui.slider("pan", -1, 1, pan) => pan;

        gui.separator();

        gui.checkbox("mute", muted) => muted;
    gui.endColumn();

    // Row with spacers for manual spacing
    gui.beginRow(@(-0.95, -0.3));
        gui.button("Play");
        gui.spacer(0.2);
        gui.button("Stop");
        gui.spacer(0.2);
        gui.button("Record");
    gui.endRow();

    // Standalone separator at a fixed position
    gui.separator(@(0.5, 0));
}
