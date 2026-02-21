@import "../lib/GComponent.ck"
@import "../lib/UIUtil.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Separator extends GComponent {
    GRect gSeparator --> this;

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_SEPARATOR, @(0.3, 0.3, 0.3, 1)) => vec4 color;
        UIStyle.color(UIStyle.COL_SEPARATOR_BORDER, @(0, 0, 0, 0)) => vec4 borderColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_SEPARATOR_SIZE, @(1.0, 0.02))) => vec2 size;
        UIStyle.varFloat(UIStyle.VAR_SEPARATOR_SCALE, UIStyle.varFloat(UIStyle.VAR_SCALE, 1.0)) => float scale;
        scale *=> size;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SEPARATOR_BORDER_RADIUS, UIStyle.varFloat(UIStyle.VAR_BORDER_RADIUS, 0))) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_SEPARATOR_BORDER_WIDTH, UIStyle.varFloat(UIStyle.VAR_BORDER_WIDTH, 0))) => float borderWidth;

        UIStyle.varVec2(UIStyle.VAR_SEPARATOR_CONTROL_POINTS, UIStyle.varVec2(UIStyle.VAR_CONTROL_POINTS, @(0.5, 0.5))) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_SEPARATOR_Z_INDEX, UIStyle.varFloat(UIStyle.VAR_Z_INDEX, 0.0)) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_SEPARATOR_ROTATE, UIStyle.varFloat(UIStyle.VAR_ROTATE, 0.0)) => float rotate;

        gSeparator.size(size);
        gSeparator.color(color);
        gSeparator.borderRadius(borderRadius);
        gSeparator.borderWidth(borderWidth);
        gSeparator.borderColor(borderColor);

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        updateUI();
    }
}
