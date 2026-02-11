//-----------------------------------------------------------------------------
// name: basic.ck
// desc: this example shows how to use tooltips on components
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

0.5 => float vol;
0 => int muted;

while (true) {
    GG.nextFrame() => now;

    // Tooltips appear after hovering for 0.5 seconds (default)
    gui.beginColumn(@(-0.7, 0.7));
        gui.button("Save");
        gui.tooltip("Save the current project");

        gui.button("Load");
        gui.tooltip("Load an existing project");

        gui.slider("vol", 0, 1, vol) => vol;
        gui.tooltip("Adjust the master volume");

        gui.checkbox("mute", muted) => muted;
        gui.tooltip("Mute all audio output");
    gui.endColumn();

    // Custom tooltip styling
    UIStyle.pushColor(UIStyle.COL_TOOLTIP, @(0.8, 0.2, 0.2, 0.95));
    UIStyle.pushColor(UIStyle.COL_TOOLTIP_TEXT, @(1, 1, 0.8, 1));
        gui.button("Delete", @(0.5, 0.5));
        gui.tooltip("Permanently delete this item");
    UIStyle.popColor(2);
}
