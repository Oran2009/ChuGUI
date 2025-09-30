@import "../lib/GComponent.ck"
@import "../gmeshes/GIcon.ck"
@import "../UIStyle.ck"

public class Icon extends GComponent {
    GIcon gIcon --> this;
    string _icon;

    // ==== Getters and Setters ====

    fun string icon() { return _icon; }
    fun void icon(string icon) {
        if (_icon != icon) {
            gIcon.icon(icon);
        }
        icon => _icon;
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_ICON, Color.WHITE) => vec4 color;

        UIStyle.varVec2(UIStyle.VAR_ICON_SIZE, @(0.3, 0.3)) => vec2 size;
        
        UIStyle.varVec2(UIStyle.VAR_ICON_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_ICON_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_ICON_ROTATE, 0.0) => float rotate;

        gIcon.sca(size);
        gIcon.color(color);

        size.x * (0.5 - controlPoints.x) => float offsetX;
        size.y * (0.5 - controlPoints.y) => float offsetY;

        this.posX(_pos.x + offsetX);
        this.posY(_pos.y + offsetY);
        this.posZ(zIndex);
        this.rotZ(rotate);
    }

    fun void update() {
        updateUI();
    }
}