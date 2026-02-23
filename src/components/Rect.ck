@import "../lib/GComponent.ck"
@import "../lib/UIUtil.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Rect extends GComponent {
    GRect gRect --> this;

    new MouseState(this, gRect) @=> _state;

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_RECT, @(0, 0, 0, 1)) => vec4 color;
        UIStyle.color(UIStyle.COL_RECT_BORDER, @(0, 0, 0, 1)) => vec4 borderColor;

        // Convert size from current unit system to world coordinates
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_RECT_SIZE, @(0.3, 0.3))) => vec2 size;
        UIStyle.varFloat(UIStyle.VAR_RECT_TRANSPARENT, 0) $ int => int transparent;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RECT_BORDER_RADIUS, 0)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_RECT_BORDER_WIDTH, 0)) => float borderWidth;

        UIStyle.varVec2(UIStyle.VAR_RECT_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_RECT_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_RECT_ROTATE, 0.0) => float rotate;

        gRect.size(size);
        gRect.transparent(transparent);
        gRect.color(color);
        gRect.borderRadius(borderRadius);
        gRect.borderWidth(borderWidth);
        gRect.borderColor(borderColor);

        // SDF 3D effects
        UIStyle.varVec2(UIStyle.VAR_BEVEL_LIGHT_DIR, @(0, 0)) => vec2 lightDir;
        UIStyle.varFloat(UIStyle.VAR_BEVEL_STRENGTH, 0) => float bevelStrength;
        UIStyle.varVec2(UIStyle.VAR_SHADOW_OFFSET, @(0, 0)) => vec2 shadowOffset;
        UIStyle.varFloat(UIStyle.VAR_SHADOW_BLUR, 0) => float shadowBlur;
        UIStyle.color(UIStyle.COL_SHADOW, @(0, 0, 0, 0)) => vec4 shadowColor;
        UIStyle.varFloat(UIStyle.VAR_INNER_SHADOW_WIDTH, 0) => float innerShadowWidth;

        gRect.lightDir(lightDir);
        gRect.bevelStrength(bevelStrength);
        gRect.shadowOffset(shadowOffset);
        gRect.shadowBlur(shadowBlur);
        gRect.shadowColor(shadowColor);
        gRect.innerShadowWidth(innerShadowWidth);

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();
        updateUI();
    }
}