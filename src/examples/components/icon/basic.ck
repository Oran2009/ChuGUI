@import "../../../ChuGUI.ck"

GG.camera().orthographic();

ChuGUI gui --> GG.scene();

// Available icons can be found here: https://phosphoricons.com 

while (true) {
    GG.nextFrame() => now; // must be called before rendering any components

    UIStyle.pushColor(UIStyle.COL_ICON, Color.WHITE);

    // Default
    gui.icon("acorn", @(-0.75, 0.5));

    // Large icon
    UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(0.5, 0.5));
    gui.icon("cookie", @(0, 0.5));
    UIStyle.popVar();

    // Small red icon
    UIStyle.pushColor(UIStyle.COL_ICON, Color.RED);
    UIStyle.pushVar(UIStyle.VAR_ICON_SIZE, @(0.2, 0.2));
    gui.icon("star", @(0.75, 0.5));
    UIStyle.popVar();
    UIStyle.popColor();

    // Blue icon
    UIStyle.pushColor(UIStyle.COL_ICON, Color.BLUE);
    gui.icon("heart", @(-0.75, 0));
    UIStyle.popColor();

    // Green icon with rotation
    UIStyle.pushColor(UIStyle.COL_ICON, Color.GREEN);
    UIStyle.pushVar(UIStyle.VAR_ICON_ROTATE, 0.3); // radians (~17 degrees)
    gui.icon("bell", @(0, 0));
    UIStyle.popVar();
    UIStyle.popColor();

    // Yellow icon
    UIStyle.pushColor(UIStyle.COL_ICON, @(1, 1, 0, 0.5));
    gui.icon("smiley", @(0.75, 0));
    UIStyle.popColor();

    gui.icon("music-note", @(0, -0.5));

    UIStyle.popColor();
}
