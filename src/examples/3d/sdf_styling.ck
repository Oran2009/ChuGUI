//-----------------------------------------------------------------------------
// name: sdf_styling.ck
// desc: this example shows SDF-based 3D visual effects: bevel, drop shadow,
//       and inner shadow on ChuGUI components.
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(@(0.85, 0.85, 0.88));
GG.scene().light().intensity(0.0);
GG.scene().ambient(Color.WHITE);

ChuGUI gui --> GG.scene();
gui.units(ChuGUI.WORLD);

while (true) {
    GG.nextFrame() => now;

    // ===== LEFT COLUMN: Bevel variations =====

    // 1. Raised pill — strong bevel, top-left light
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(-1, 1));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.25);
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0.04, -0.04));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.08);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.35));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.25);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.55, 0.6, 0.85));
        gui.rect(@(-2, 2.5));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(4);

    // 2. Etched/engraved — reverse light direction for carved look
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(1, -1));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.2);
    UIStyle.pushVar(UIStyle.VAR_INNER_SHADOW_WIDTH, 0.015);
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.08);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.78, 0.78, 0.82));
        gui.rect(@(-2, 1.5));
    UIStyle.popColor();
    UIStyle.popVar(4);
    UIStyle.popVar();

    // 3. Soft dome — circular with bevel only (no shadow to avoid quad clipping)
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(-0.7, 0.7));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.3);
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(1.0, 1.0));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.5);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.9, 0.65, 0.55));
        gui.rect(@(-2, 0.2));
    UIStyle.popColor();
    UIStyle.popVar(3);

    // 4. Bottom-lit — light from below for dramatic effect
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(0, -1));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.2);
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0, 0.06));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.1);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.4));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.1);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.35, 0.35, 0.45));
        gui.rect(@(-2, -1));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(4);

    // ===== RIGHT COLUMN: Shadow & combined effects =====

    // 5. Floating card — large soft shadow
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0.12, -0.15));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.3);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.4));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 1.2));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.15);
    UIStyle.pushColor(UIStyle.COL_RECT, Color.WHITE);
        gui.rect(@(2, 2.2));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(2);

    // 6. Colored shadow — tinted glow effect
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0, -0.03));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.2);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0.2, 0.4, 1.0, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.12);
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.25, 0.45, 0.9));
        gui.rect(@(2, 0.9));
    UIStyle.popColor();
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.popVar(2);

    // 7. Deep inset — thick inner shadow + border
    UIStyle.pushVar(UIStyle.VAR_INNER_SHADOW_WIDTH, 0.06);
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 0.6));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.12);
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_WIDTH, 0.01);
    UIStyle.pushColor(UIStyle.COL_RECT_BORDER, @(0.6, 0.6, 0.65));
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.92, 0.92, 0.94));
        gui.rect(@(2, 0));
    UIStyle.popColor(2);
    UIStyle.popVar(4);

    // 8. Full combo — bevel + drop shadow + inner shadow + border
    UIStyle.pushVar(UIStyle.VAR_BEVEL_LIGHT_DIR, @(-1, 1));
    UIStyle.pushVar(UIStyle.VAR_BEVEL_STRENGTH, 0.15);
    UIStyle.pushVar(UIStyle.VAR_SHADOW_OFFSET, @(0.08, -0.08));
    UIStyle.pushVar(UIStyle.VAR_SHADOW_BLUR, 0.15);
    UIStyle.pushColor(UIStyle.COL_SHADOW, @(0, 0, 0, 0.35));
    UIStyle.pushVar(UIStyle.VAR_INNER_SHADOW_WIDTH, 0.02);
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.5, 1.2));
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_RADIUS, 0.15);
    UIStyle.pushVar(UIStyle.VAR_RECT_BORDER_WIDTH, 0.008);
    UIStyle.pushColor(UIStyle.COL_RECT_BORDER, @(0.65, 0.55, 0.7));
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.82, 0.75, 0.88));
        gui.rect(@(2, -1.2));
    UIStyle.popColor(2);
    UIStyle.popVar(3);
    UIStyle.popColor();
    UIStyle.popVar(5);
}
