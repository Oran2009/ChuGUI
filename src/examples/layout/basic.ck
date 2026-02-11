//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to use auto-layout containers
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(@(0.5, 0.5, 0.5));

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.5 => float vol;
0 => int muted;
0 => int choice;
string name;

while (true) {
    GG.nextFrame() => now;

    // Column layout: vertical stack of controls
    gui.beginColumn(@(-0.95, 0.9));
        gui.label("Controls");
        gui.slider("vol", 0, 1, vol) => vol;
        gui.checkbox("mute", muted) => muted;
        gui.input("name", name, "Enter name") => name;
    gui.endColumn();

    // Row layout: horizontal toolbar
    gui.beginRow(@(-0.95, -0.5));
        gui.button("Play");
        gui.button("Stop");
        gui.button("Record");
    gui.endRow();

    // Nested layout: row inside a column
    gui.beginColumn(@(-0.95, 0));
        gui.label("Settings");
        gui.slider("brightness", 0, 1, 0.75);
        gui.beginRow();
            gui.button("OK");
            gui.button("Cancel");
        gui.endRow();
    gui.endColumn();

    // Custom spacing
    UIStyle.pushVar(UIStyle.VAR_CONTAINER_SPACING, 0.02);
    gui.beginRow(@(-0.95, -0.7));
        gui.button("A");
        gui.button("B");
        gui.button("C");
    gui.endRow();
    UIStyle.popVar();
}
