@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();

["Red", "Green", "Blue"] @=> string colors[];
0 => int colorIx;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.label("Choose a color:", @(0, 0.6));
    gui.radio("colorRadio", @(0, 0.4), colors, colorIx) => colorIx;
    gui.label("Selected: " + colors[colorIx], @(0, 0));
}