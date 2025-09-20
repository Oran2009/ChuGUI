@import "../lib/Util.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../gmeshes/GIcon.ck"
@import "../UIStyle.ck"

public class Checkbox extends GComponent {
    GRect gBox --> this;
    GIcon gIcon --> this;

    string _icon;

    new MouseState(this, gBox) @=> _state;

    // ==== Getters and Setters ====

    fun void checked(int checked) { _state.toggled(checked); }
    fun int checked() { return _state.toggled(); }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_CHECKBOX, @(1,1,1,1)) => vec4 boxColor;
        UIStyle.color(UIStyle.COL_CHECKBOX_BORDER, @(0.3,0.3,0.3,1)) => vec4 borderColor;
        UIStyle.color(UIStyle.COL_CHECKBOX_ICON, @(1,1,1,1)) => vec4 iconColor;

        UIStyle.varVec2(UIStyle.VAR_CHECKBOX_SIZE, @(0.3,0.3)) => vec2 boxSize;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_BORDER_RADIUS, 0.25) => float borderRadius;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_BORDER_WIDTH, 0.1) => float borderWidth;
        UIStyle.varString(UIStyle.VAR_CHECKBOX_ICON, "check") => string icon;

        UIStyle.varVec2(UIStyle.VAR_CHECKBOX_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_Z_INDEX, 0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_CHECKBOX_ROTATE, 0) => float rotate;

        if (gIcon.parent() != null) { gIcon --< this; }

        if (_disabled) {
            UIStyle.color(UIStyle.COL_CHECKBOX_DISABLED, boxColor) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_DISABLED, borderColor) => borderColor;
            if (_state.toggled()) gIcon --> this;
        } else if (_state.toggled()) {
            UIStyle.color(UIStyle.COL_CHECKBOX_PRESSED, Color.BLUE) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_PRESSED, borderColor) => borderColor;
            gIcon --> this;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_CHECKBOX_HOVERED, @(0, 0, 1, 0.5)) => boxColor;
            UIStyle.color(UIStyle.COL_CHECKBOX_BORDER_HOVERED, borderColor) => borderColor;
        }

        gBox.size(boxSize);
        gBox.color(boxColor);
        gBox.borderRadius(borderRadius);
        gBox.borderWidth(borderWidth);
        gBox.borderColor(borderColor);

        0.2 => float pad;
        @(boxSize.x*(1-pad), boxSize.y*(1-pad)) => vec2 inner;
        gIcon.sca(inner);
        gIcon.color(iconColor);

        if (_icon != icon) {
            gIcon.icon(icon);
        }
        icon => _icon;

        boxSize.x * (0.5 - controlPoints.x) => float offsetX;
        boxSize.y * (0.5 - controlPoints.y) => float offsetY;

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