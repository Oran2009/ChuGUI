@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Rect extends GComponent {
    GRect gRect --> this;

    new MouseState(this, gRect) @=> _state;

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_RECT, @(0, 0, 0, 1)) => vec4 color;
        UIStyle.color(UIStyle.COL_RECT_BORDER, @(0, 0, 0, 1)) => vec4 borderColor;

        UIStyle.varVec2(UIStyle.VAR_RECT_SIZE, @(0.3, 0.3)) => vec2 size;
        UIStyle.varFloat(UIStyle.VAR_RECT_TRANSPARENT, 0) $ int => int transparent;
        UIStyle.varFloat(UIStyle.VAR_RECT_BORDER_RADIUS, 0) => float borderRadius;
        UIStyle.varFloat(UIStyle.VAR_RECT_BORDER_WIDTH, 0) => float borderWidth;

        UIStyle.varVec2(UIStyle.VAR_RECT_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_RECT_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_RECT_ROTATE, 0.0) => float rotate;

        gRect.size(size);
        gRect.transparent(transparent);
        gRect.color(color);
        gRect.borderRadius(borderRadius);
        gRect.borderWidth(borderWidth);
        gRect.borderColor(borderColor);

        size.x * (0.5 - controlPoints.x) => float offsetX;
        size.y * (0.5 - controlPoints.y) => float offsetY;

        this.posX(_pos.x + offsetX);
        this.posY(_pos.y + offsetY);
        this.posZ(zIndex);
        this.rotZ(rotate);
    }

    fun void update() {
        _state.update();
        updateUI();
    }
}