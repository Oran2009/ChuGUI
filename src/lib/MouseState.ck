@import "../gmeshes/GRect.ck"
@import "UIUtil.ck"

// TODO: CursorState is reserved for future cursor management.
// UI.setMouseCursor() cannot be called from GGen.update() because
// GGen callbacks run before the ImGUI frame starts.
public class CursorState {
}

public class MouseState {
    GGen _element;
    GRect _rect;

    int _disabled;

    int _mouseDown;
    int _mouseState;

    int _clicked;
    int _hovered;
    int _pressed;
    int _pressedLast;
    int _toggled;
    int _dragging;

    fun MouseState(GGen element, GRect rect) {
        element @=> _element;
        rect @=> _rect;
        // No longer register in constructor - register during update() instead
    }

    // ==== Getters and Setters ====

    fun GGen element() { return _element; }
    fun GRect rect() { return _rect; }

    fun void disabled(int disabled) { disabled => _disabled; }
    fun int disabled() { return _disabled; }

    fun vec3 mouseWorld() { return UIUtil.mouseWorld(); }
    fun int mouseDown() { return _mouseDown; }
    fun int mouseState() { return _mouseState; }

    fun int clicked() { return _clicked; }

    fun void hovered(int hovered) { hovered => _hovered; }
    fun int hovered() { return _hovered; }

    fun void pressed(int pressed) { pressed => _pressed; }
    fun int pressed() { return _pressed; }

    fun void toggled(int toggled) { toggled => _toggled; }
    fun int toggled() { return _toggled; }

    fun int dragging() { return _dragging; }

    // ==== Update ====

    fun void update() {
        UIUtil.hovered(_element, _rect) => _hovered;

        GWindow.mouseLeftDown() => _mouseDown;
        _mouseDown && _hovered => _clicked;

        GWindow.mouseLeft() => _mouseState;
        _hovered && _mouseState => _pressed;

        if (_mouseDown && _hovered) { true => _dragging; }
        if (!_mouseState) { false => _dragging; }

        if (_pressed && !_pressedLast) { !_toggled => _toggled; }

        _pressed => _pressedLast;
    }
}
