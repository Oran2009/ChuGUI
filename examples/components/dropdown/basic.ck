@import "../../../src/ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();

["Option 1", "Option 2", "Option 3"] @=> string options[];
-1 => int selected;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    gui.dropdown("Dropdown", @(0, 0), options, selected) => selected;

    if (selected == -1) {
        <<< "Selected: None" >>>;
    } else {
        <<< "Selected:", options[selected] >>>;
    }
}