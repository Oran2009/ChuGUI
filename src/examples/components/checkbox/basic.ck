@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();

0 => int checked;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.checkbox("Basic", @(0, 0), checked) => checked;

    <<< "Checked:", checked >>>;
}