//-----------------------------------------------------------------------------
// name: sdf_styling.ck
// desc: this example shows SDF-based 3D visual effects: bevel, drop shadow,
//       and inner shadow on ChuGUI components.
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(@(0.9, 0.9, 0.9));
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.units(ChuGUI.WORLD);

while (true) {
    GG.nextFrame() => now;

    // Raised button with bevel + drop shadow
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(-1, 1));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.15);
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0.05, -0.05));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.1);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.3));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(3, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.2);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.75, 0.75, 0.8));
        gui.rect(@(0, 1.5));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(4);

    // Recessed input area with inner shadow
    UIStyle.pushVar(UIStyle.VAR_INNER_SHADOW_WIDTH, 0.03);
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(3, 0.4));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.1);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.95, 0.95, 0.95));
        gui.rect(@(0, 0.5));
    UIStyle.popColor();
    UIStyle.popVar(3);

    // Flat rect for comparison (no effects)
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(3, 0.4));
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.75, 0.75, 0.8));
        gui.rect(@(0, -0.3));
    UIStyle.popColor();
    UIStyle.popVar();

    // Deep shadow card
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0.1, -0.1));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.2);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(3, 1.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.1);
    UIStyle.pushColor(UIStyle.COL_RECT, Color.WHITE);
        gui.rect(@(0, -2));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(2);
}
