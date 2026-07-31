@import "../lib/GComponent.ck"
@import "../lib/UIUtil.ck"
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

        UIStyle.varVec2(UIStyle.VAR_ICON_UV_OFFSET, @(0, 0)) => vec2 uvOffset;
        UIStyle.varVec2(UIStyle.VAR_ICON_UV_SCALE, @(1, 1)) => vec2 uvScale;

        // Get size: @(0,0) sentinel means use original texture dimensions
        UIStyle.varVec2(UIStyle.VAR_ICON_SIZE, @(0, 0)) => vec2 size;
        if (size.x == 0 && size.y == 0) {
            // Use effective (UV-cropped) dimensions for aspect ratio
            gIcon.texWidth() $ float * Math.fabs(uvScale.x) => float tw;
            gIcon.texHeight() $ float * Math.fabs(uvScale.y) => float th;
            if (UIGlobals.sizeUnits == "SCREEN") {
                // Screen mode: preserve pixel-perfect sizing
                UIUtil.screenToWorldSize(@(tw, th)) => size;
            } else {
                // WORLD/NDC: normalize so largest dimension = 1 unit,
                // preserving aspect ratio. Use scale to control final size.
                Math.max(tw, th) => float maxDim;
                if (maxDim > 0)
                    UIUtil.sizeToWorld(@(tw / maxDim, th / maxDim)) => size;
                else
                    UIUtil.sizeToWorld(@(1, 1)) => size;
            }
        } else {
            UIUtil.sizeToWorld(size) => size;
        }
        UIStyle.varFloat(UIStyle.VAR_ICON_SCALE, UIStyle.varFloat(UIStyle.VAR_SCALE, 1.0)) => float scale;
        scale *=> size;

        UIStyle.varFloat(UIStyle.VAR_ICON_TRANSPARENT, 1) $ int => int transparent;
        UIStyle.varString(UIStyle.VAR_ICON_SAMPLER, UIStyle.LINEAR) => string samplerOption;

        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP, -1) $ int => int wrap;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_U, TextureSampler.Wrap_Repeat) $ int => int wrapU;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_V, TextureSampler.Wrap_Repeat) $ int => int wrapV;
        UIStyle.varFloat(UIStyle.VAR_ICON_WRAP_W, TextureSampler.Wrap_Repeat) $ int => int wrapW;

        UIStyle.varVec2(UIStyle.VAR_ICON_CONTROL_POINTS, UIStyle.varVec2(UIStyle.VAR_CONTROL_POINTS, @(0.5, 0.5))) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_ICON_Z_INDEX, UIStyle.varFloat(UIStyle.VAR_Z_INDEX, 0.0)) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_ICON_ROTATE, UIStyle.varFloat(UIStyle.VAR_ROTATE, 0.0)) => float rotate;

        UIStyle.varFloat(UIStyle.VAR_ICON_BLEND_MODE, Material.BLEND_MODE_ALPHA) $ int => int blendMode;

        gIcon.sca(size);
        gIcon.color(color);
        gIcon.transparent(transparent);
        gIcon.blend(blendMode);
        gIcon.uvOffset(uvOffset);
        gIcon.uvScale(uvScale);

        samplerOption == UIStyle.NEAREST ? TextureSampler.nearest() : TextureSampler.linear() @=> TextureSampler sampler;
        wrapU => sampler.wrapU;
        wrapV => sampler.wrapV;
        wrapW => sampler.wrapW;
        if (wrap != -1) {
            wrap => sampler.wrapU => sampler.wrapV => sampler.wrapW;
        }
        gIcon.sampler(sampler);

        applyLayout(size, controlPoints, zIndex, rotate);
    }

    fun void update() {
        updateUI();
    }
}