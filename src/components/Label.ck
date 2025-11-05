@import "../lib/GComponent.ck"
@import "../UIStyle.ck"

public class Label extends GComponent {
    GText gLabel --> this;

    string _label;

    // ==== Getters and Setters ====

    fun string label() { return _label; }
    fun void label(string label) {
        label => _label;
        gLabel.text(label);
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_LABEL, @(0, 0, 0, 1)) => vec4 color;

        UIStyle.varFloat(UIStyle.VAR_LABEL_SIZE, 0.2) => float size;
        UIStyle.varString(UIStyle.VAR_LABEL_FONT, "") => string font;
        UIStyle.varFloat(UIStyle.VAR_LABEL_ANTIALIAS, 1) => float antialias;
        UIStyle.varFloat(UIStyle.VAR_LABEL_SPACING, 1.0) => float spacing;
        UIStyle.varString(UIStyle.VAR_LABEL_ALIGN, UIStyle.LEFT) => string align;
        UIStyle.varFloat(UIStyle.VAR_LABEL_CHARACTERS, Math.exp2(31)-1) $ int => int characters;
        UIStyle.varFloat(UIStyle.VAR_LABEL_MAX_WIDTH, 0.0) => float maxWidth;

        UIStyle.varVec2(UIStyle.VAR_LABEL_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_LABEL_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_LABEL_ROTATE, 0.0) => float rotate;

        gLabel.color(color);
        gLabel.size(size);
        gLabel.controlPoints(controlPoints);
        gLabel.font(font);
        gLabel.antialias(antialias);
        gLabel.spacing(spacing);
        gLabel.characters(characters);
        gLabel.maxWidth(maxWidth);

        if (align == UIStyle.CENTER) {
            gLabel.align(1);
        } else if (align == UIStyle.RIGHT) {
            gLabel.align(2);
        } else {
            gLabel.align(0);
        }

        this.posX(_pos.x);
        this.posY(_pos.y);
        this.posZ(zIndex);
        this.rotZ(rotate);
    }

    fun void update() {
        updateUI();
    }
}