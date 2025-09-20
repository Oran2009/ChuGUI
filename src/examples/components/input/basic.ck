@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();

string input;

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.input("Input", @(0, 0), input, "Input...") => input;
}
