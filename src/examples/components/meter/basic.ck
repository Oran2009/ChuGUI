@import "../../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(Color.WHITE);

ChuGUI gui --> GG.scene();

2.5 => float staticValue;
2.5 => float dynamicValue;

while(true) {
    GG.nextFrame() => now; // must be called before rendering any components

    now / second => float time;

    // Animate dynamic meters with sine waves
    (Math.sin(time * 1.5) * 0.5 + 0.5) * 5 => dynamicValue;  // 0..5 oscillation

    gui.meter(@(0, 0.5), 0, 5, staticValue);
    gui.meter(@(0, -0.5), 0, 5, dynamicValue);
}
