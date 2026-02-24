@import "UIGlobals.ck"
@import "MouseState.ck"
@import "RayUtil.ck"
@import "../UIStyle.ck"

public class GComponent extends GGen {
    vec2 _pos;

    int _frame;

    false => int _disabled;

    MouseState _state;

    // Reference to owning ChuGUI panel (set when component is attached)
    GGen @ _panel;

    fun GGen panel() { return _panel; }
    fun void panel(GGen p) { p @=> _panel; }

    // 3D mode flag (set by the panel each frame)
    int _is3D;

    fun int is3D() { return _is3D; }
    fun void is3D(int v) { v => _is3D; }

    // ==== Getters and Setters ====

    fun int frame() { return _frame; }
    fun void frame(int frame) { frame => _frame; }

    fun GGen pos(vec2 pos) {
        if (UIGlobals.posUnits == "WORLD") {
            pos => _pos;
        } else if (_is3D && _panel != null) {
            // 3D mode: project NDC point onto panel's plane
            GG.scene().camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 nearNDC;
            GG.scene().camera().NDCToWorldPos(@(pos.x, pos.y, 1)) => vec3 farNDC;
            @(farNDC.x - nearNDC.x, farNDC.y - nearNDC.y, farNDC.z - nearNDC.z) => vec3 dir;
            RayUtil.normalize3(dir) => dir;

            _panel.posWorld() => vec3 panelPos;
            _panel.forward() => vec3 normal;
            _panel.right() => vec3 right;
            _panel.up() => vec3 up;

            RayUtil.rayPlaneT(nearNDC, dir, panelPos, normal) => float t;
            if (t > 0) {
                @(nearNDC.x + t * dir.x,
                  nearNDC.y + t * dir.y,
                  nearNDC.z + t * dir.z) => vec3 hitWorld;
                RayUtil.worldToLocal2D(hitWorld, panelPos, right, up) => _pos;
            } else {
                pos => _pos;  // fallback
            }
        } else {
            // Original flat mode
            GG.scene().camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 worldPos;
            @(worldPos.x, worldPos.y) => _pos;
        }
        return this;
    }

    fun int disabled() { return _disabled; }
    fun void disabled(int disabled) {
        disabled => _disabled;
        _state.disabled(_disabled);
    }

    // ==== Layout Helpers ====

    // Calculate position offset based on size and control points
    // Control points define where the origin is within the bounding box:
    // (0,0)=bottom-left, (0.5,0.5)=center, (1,1)=top-right
    fun vec2 controlPointOffset(vec2 size, vec2 controlPoints) {
        return @(size.x * (0.5 - controlPoints.x), size.y * (0.5 - controlPoints.y));
    }

    // Apply final position with control point offset, z-index, and rotation
    fun void applyLayout(vec2 size, vec2 controlPoints, float zIndex, float rotate) {
        controlPointOffset(size, controlPoints) => vec2 offset;
        this.posX(_pos.x + offset.x);
        this.posY(_pos.y + offset.y);
        this.posZ(zIndex);
        this.rotZ(rotate);
    }
}