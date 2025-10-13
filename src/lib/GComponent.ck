@import "UIGlobals.ck"
@import "MouseState.ck"
@import "../UIStyle.ck"

public class GComponent extends GGen {
    vec2 _pos;

    int _frame;
    
    false => int _disabled;

    MouseState _state;

    // ==== Getters and Setters ====

    fun int frame() { return _frame; }
    fun void frame(int frame) { frame => _frame; }

    fun GGen pos(vec2 pos) {
        if (UIGlobals.units == "WORLD") {
            pos => _pos;
        } else {
            GG.camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 worldPos;
            @(worldPos.x, worldPos.y) => _pos;
        }
        return this;
    }

    fun int disabled() { return _disabled; }
    fun void disabled(int disabled) {
        disabled => _disabled;
        _state.disabled(_disabled);
    }
}