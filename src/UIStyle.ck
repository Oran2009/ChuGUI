@doc "ChuGUI's styling system."
public class UIStyle {
    // ==== Color Keys ====

    // Rect
    "rect"                        => static string COL_RECT;
    "rect.border"                 => static string COL_RECT_BORDER;

    // Icon
    "icon"                        => static string COL_ICON;

    // Label
    "label"                        => static string COL_LABEL;

    // Button
    "button"                      => static string COL_BUTTON;
    "button.hovered"              => static string COL_BUTTON_HOVERED;
    "button.pressed"              => static string COL_BUTTON_PRESSED;
    "button.disabled"             => static string COL_BUTTON_DISABLED;
    "button.text"                 => static string COL_BUTTON_TEXT;
    "button.text.hovered"         => static string COL_BUTTON_TEXT_HOVERED;
    "button.text.pressed"         => static string COL_BUTTON_TEXT_PRESSED;
    "button.text.disabled"        => static string COL_BUTTON_TEXT_DISABLED;
    "button.border"               => static string COL_BUTTON_BORDER;
    "button.border.hovered"       => static string COL_BUTTON_BORDER_HOVERED;
    "button.border.pressed"       => static string COL_BUTTON_BORDER_PRESSED;
    "button.border.disabled"      => static string COL_BUTTON_BORDER_DISABLED;
    "button.icon"                 => static string COL_BUTTON_ICON;
    "button.icon.hovered"         => static string COL_BUTTON_ICON_HOVERED;
    "button.icon.pressed"         => static string COL_BUTTON_ICON_PRESSED;
    "button.icon.disabled"        => static string COL_BUTTON_ICON_DISABLED;

    // Slider
    "slider.track"                  => static string COL_SLIDER_TRACK;
    "slider.track.hovered"          => static string COL_SLIDER_TRACK_HOVERED;
    "slider.track.pressed"          => static string COL_SLIDER_TRACK_PRESSED;
    "slider.track.disabled"         => static string COL_SLIDER_TRACK_DISABLED;
    "slider.track.border"           => static string COL_SLIDER_TRACK_BORDER;
    "slider.track.border.hovered"   => static string COL_SLIDER_TRACK_BORDER_HOVERED;
    "slider.track.border.pressed"   => static string COL_SLIDER_TRACK_BORDER_PRESSED;
    "slider.track.border.disabled"  => static string COL_SLIDER_TRACK_BORDER_DISABLED;
    "slider.handle"                 => static string COL_SLIDER_HANDLE;
    "slider.handle.hovered"         => static string COL_SLIDER_HANDLE_HOVERED;
    "slider.handle.pressed"         => static string COL_SLIDER_HANDLE_PRESSED;
    "slider.handle.disabled"        => static string COL_SLIDER_HANDLE_DISABLED;
    "slider.handle.border"          => static string COL_SLIDER_HANDLE_BORDER;
    "slider.handle.border.hovered"  => static string COL_SLIDER_HANDLE_BORDER_HOVERED;
    "slider.handle.border.pressed"  => static string COL_SLIDER_HANDLE_BORDER_PRESSED;
    "slider.handle.border.disabled" => static string COL_SLIDER_HANDLE_BORDER_DISABLED;
    "slider.tick"                   => static string COL_SLIDER_TICK;
    "slider.tick.hovered"           => static string COL_SLIDER_TICK_HOVERED;
    "slider.tick.pressed"           => static string COL_SLIDER_TICK_PRESSED;
    "slider.tick.disabled"          => static string COL_SLIDER_TICK_DISABLED;

    // Checkbox
    "checkbox"                    => static string COL_CHECKBOX;
    "checkbox.hovered"            => static string COL_CHECKBOX_HOVERED;
    "checkbox.pressed"            => static string COL_CHECKBOX_PRESSED;
    "checkbox.disabled"           => static string COL_CHECKBOX_DISABLED;
    "checkbox.border"             => static string COL_CHECKBOX_BORDER;
    "checkbox.border.hovered"     => static string COL_CHECKBOX_BORDER_HOVERED;
    "checkbox.border.pressed"     => static string COL_CHECKBOX_BORDER_PRESSED;
    "checkbox.border.disabled"    => static string COL_CHECKBOX_BORDER_DISABLED;
    "checkbox.icon"               => static string COL_CHECKBOX_ICON;

    // Input
    "input"                       => static string COL_INPUT;
    "input.hovered"               => static string COL_INPUT_HOVERED;
    "input.focused"               => static string COL_INPUT_FOCUSED;
    "input.disabled"              => static string COL_INPUT_DISABLED;
    "input.text"                  => static string COL_INPUT_TEXT;
    "input.text.disabled"         => static string COL_INPUT_TEXT_DISABLED;
    "input.border"                => static string COL_INPUT_BORDER;
    "input.border.hovered"        => static string COL_INPUT_BORDER_HOVERED;
    "input.border.focused"        => static string COL_INPUT_BORDER_FOCUSED;
    "input.border.disabled"       => static string COL_INPUT_BORDER_DISABLED;
    "input.placeholder"           => static string COL_INPUT_PLACEHOLDER;
    "input.cursor"                => static string COL_INPUT_CURSOR;

    // Dropdown
    "dropdown"                      => static string COL_DROPDOWN;
    "dropdown.hovered"              => static string COL_DROPDOWN_HOVERED;
    "dropdown.open"                 => static string COL_DROPDOWN_OPEN;
    "dropdown.disabled"             => static string COL_DROPDOWN_DISABLED;
    "dropdown.border"               => static string COL_DROPDOWN_BORDER;
    "dropdown.border.hovered"       => static string COL_DROPDOWN_BORDER_HOVERED;
    "dropdown.border.open"          => static string COL_DROPDOWN_BORDER_OPEN;
    "dropdown.border.disabled"      => static string COL_DROPDOWN_BORDER_DISABLED;
    "dropdown.text"                 => static string COL_DROPDOWN_TEXT;
    "dropdown.text.hovered"         => static string COL_DROPDOWN_TEXT_HOVERED;
    "dropdown.text.open"            => static string COL_DROPDOWN_TEXT_OPEN;
    "dropdown.text.disabled"        => static string COL_DROPDOWN_TEXT_DISABLED;
    "dropdown.arrow"                => static string COL_DROPDOWN_ARROW;
    "dropdown.item"                 => static string COL_DROPDOWN_ITEM;
    "dropdown.item.hovered"         => static string COL_DROPDOWN_ITEM_HOVERED;
    "dropdown.item.selected"        => static string COL_DROPDOWN_ITEM_SELECTED;
    "dropdown.item.border"          => static string COL_DROPDOWN_ITEM_BORDER;
    "dropdown.item.border.hovered"  => static string COL_DROPDOWN_ITEM_BORDER_HOVERED;
    "dropdown.item.border.selected" => static string COL_DROPDOWN_ITEM_BORDER_SELECTED;
    "dropdown.item.text"            => static string COL_DROPDOWN_ITEM_TEXT;
    "dropdown.item.text.hovered"    => static string COL_DROPDOWN_ITEM_TEXT_HOVERED;
    "dropdown.item.text.selected"   => static string COL_DROPDOWN_ITEM_TEXT_SELECTED;

    // Color Picker
    "color_picker.label"            => static string COL_COLOR_PICKER_LABEL;

    // Knob
    "knob"                        => static string COL_KNOB;
    "knob.hovered"                => static string COL_KNOB_HOVERED;
    "knob.pressed"                => static string COL_KNOB_PRESSED;
    "knob.disabled"               => static string COL_KNOB_DISABLED;
    "knob.border"                 => static string COL_KNOB_BORDER;
    "knob.border.hovered"         => static string COL_KNOB_BORDER_HOVERED;
    "knob.border.pressed"         => static string COL_KNOB_BORDER_PRESSED;
    "knob.border.disabled"        => static string COL_KNOB_BORDER_DISABLED;
    "knob.indicator"              => static string COL_KNOB_INDICATOR;
    "knob.indicator.hovered"      => static string COL_KNOB_INDICATOR_HOVERED;
    "knob.indicator.pressed"      => static string COL_KNOB_INDICATOR_PRESSED;
    "knob.indicator.disabled"     => static string COL_KNOB_INDICATOR_DISABLED;

    // Meter
    "meter.track"                 => static string COL_METER_TRACK;
    "meter.fill"                  => static string COL_METER_FILL;
    "meter.track.border"          => static string COL_METER_TRACK_BORDER;

    // Radio
    "radio.option"                => static string COL_RADIO_OPTION;
    "radio.option.hovered"        => static string COL_RADIO_OPTION_HOVERED;
    "radio.option.pressed"        => static string COL_RADIO_OPTION_PRESSED;
    "radio.option.disabled"       => static string COL_RADIO_OPTION_DISABLED;

    "radio.border"                => static string COL_RADIO_BORDER;
    "radio.border.hovered"        => static string COL_RADIO_BORDER_HOVERED;
    "radio.border.pressed"        => static string COL_RADIO_BORDER_PRESSED;
    "radio.border.disabled"       => static string COL_RADIO_BORDER_DISABLED;

    "radio.selected"              => static string COL_RADIO_SELECTED;
    "radio.label"                 => static string COL_RADIO_LABEL;
    "radio.label.hovered"         => static string COL_RADIO_LABEL_HOVERED;
    "radio.label.pressed"         => static string COL_RADIO_LABEL_PRESSED;
    "radio.label.disabled"        => static string COL_RADIO_LABEL_DISABLED;

    // ==== Var Keys ====

    // Rect
    "rect.control_points"         => static string VAR_RECT_CONTROL_POINTS;
    "rect.size"                   => static string VAR_RECT_SIZE;
    "rect.border_radius"          => static string VAR_RECT_BORDER_RADIUS;
    "rect.border_width"           => static string VAR_RECT_BORDER_WIDTH;
    "rect.z_index"                => static string VAR_RECT_Z_INDEX;
    "rect.rotate"                 => static string VAR_RECT_ROTATE;

    // Icon
    "icon.control_points"         => static string VAR_ICON_CONTROL_POINTS;
    "icon.size"                   => static string VAR_ICON_SIZE;
    "icon.z_index"                => static string VAR_ICON_Z_INDEX;
    "icon.rotate"                 => static string VAR_ICON_ROTATE;

    // Label
    "label.control_points"         => static string VAR_LABEL_CONTROL_POINTS;
    "label.size"                   => static string VAR_LABEL_SIZE;
    "label.font"                   => static string VAR_LABEL_FONT;
    "label.antialias"              => static string VAR_LABEL_ANTIALIAS;
    "label.spacing"                => static string VAR_LABEL_SPACING;
    "label.z_index"                => static string VAR_LABEL_Z_INDEX;
    "label.rotate"                 => static string VAR_LABEL_ROTATE;

    // Button
    "button.control_points"       => static string VAR_BUTTON_CONTROL_POINTS;
    "button.size"                 => static string VAR_BUTTON_SIZE;
    "button.text_size"            => static string VAR_BUTTON_TEXT_SIZE;
    "button.border_radius"        => static string VAR_BUTTON_BORDER_RADIUS;
    "button.border_width"         => static string VAR_BUTTON_BORDER_WIDTH;
    "button.font"                 => static string VAR_BUTTON_FONT;
    "button.rotate"               => static string VAR_BUTTON_ROTATE;
    "button.z_index"              => static string VAR_BUTTON_Z_INDEX;
    "button.icon_size"            => static string VAR_BUTTON_ICON_SIZE;
    "button.icon_position"        => static string VAR_BUTTON_ICON_POSITION;

    // Slider
    "slider.control_points"       => static string VAR_SLIDER_CONTROL_POINTS;
    "slider.track_size"           => static string VAR_SLIDER_TRACK_SIZE;
    "slider.track_border_radius"  => static string VAR_SLIDER_TRACK_BORDER_RADIUS;
    "slider.track_border_width"   => static string VAR_SLIDER_TRACK_BORDER_WIDTH;
    "slider.handle_size"          => static string VAR_SLIDER_HANDLE_SIZE;
    "slider.handle_border_radius" => static string VAR_SLIDER_HANDLE_BORDER_RADIUS;
    "slider.handle_border_width"  => static string VAR_SLIDER_HANDLE_BORDER_WIDTH;
    "slider.tick_size"            => static string VAR_SLIDER_TICK_SIZE;
    "slider.rotate"               => static string VAR_SLIDER_ROTATE;
    "slider.z_index"              => static string VAR_SLIDER_Z_INDEX;

    // Checkbox
    "checkbox.control_points"     => static string VAR_CHECKBOX_CONTROL_POINTS;
    "checkbox.size"               => static string VAR_CHECKBOX_SIZE;
    "checkbox.border_radius"      => static string VAR_CHECKBOX_BORDER_RADIUS;
    "checkbox.border_width"       => static string VAR_CHECKBOX_BORDER_WIDTH;
    "checkbox.icon"               => static string VAR_CHECKBOX_ICON;
    "checkbox.icon_size"          => static string VAR_CHECKBOX_ICON_SIZE;
    "checkbox.check_width"        => static string VAR_CHECKBOX_CHECK_WIDTH;
    "checkbox.z_index"            => static string VAR_CHECKBOX_Z_INDEX;
    "checkbox.rotate"             => static string VAR_CHECKBOX_ROTATE;

    // Input
    "input.control_points"        => static string VAR_INPUT_CONTROL_POINTS;
    "input.size"                  => static string VAR_INPUT_SIZE;
    "input.text_size"             => static string VAR_INPUT_TEXT_SIZE;
    "input.border_radius"         => static string VAR_INPUT_BORDER_RADIUS;
    "input.border_width"          => static string VAR_INPUT_BORDER_WIDTH;
    "input.font"                  => static string VAR_INPUT_FONT;
    "input.z_index"               => static string VAR_INPUT_Z_INDEX;
    "input.rotate"                => static string VAR_INPUT_ROTATE;

    // Dropdown
    "dropdown.control_points"     => static string VAR_DROPDOWN_CONTROL_POINTS;
    "dropdown.size"               => static string VAR_DROPDOWN_SIZE;
    "dropdown.text_size"          => static string VAR_DROPDOWN_TEXT_SIZE;
    "dropdown.border_radius"      => static string VAR_DROPDOWN_BORDER_RADIUS;
    "dropdown.border_width"       => static string VAR_DROPDOWN_BORDER_WIDTH;
    "dropdown.font"               => static string VAR_DROPDOWN_FONT;
    "dropdown.z_index"            => static string VAR_DROPDOWN_Z_INDEX;
    "dropdown.rotate"             => static string VAR_DROPDOWN_ROTATE;

    // Color Picker
    "color_picker.control_points" => static string VAR_COLOR_PICKER_CONTROL_POINTS;
    "color_picker.size"           => static string VAR_COLOR_PICKER_SIZE;
    "color_picker.z_index"        => static string VAR_COLOR_PICKER_Z_INDEX;
    "color_picker.rotate"         => static string VAR_COLOR_PICKER_ROTATE;

    // Knob
    "knob.control_points"         => static string VAR_KNOB_CONTROL_POINTS;
    "knob.size"                   => static string VAR_KNOB_SIZE;
    "knob.border_radius"          => static string VAR_KNOB_BORDER_RADIUS;
    "knob.border_width"           => static string VAR_KNOB_BORDER_WIDTH;
    "knob.indicator_size"         => static string VAR_KNOB_INDICATOR_SIZE;
    "knob.z_index"                => static string VAR_KNOB_Z_INDEX;
    "knob.rotate"                 => static string VAR_KNOB_ROTATE;

    // Meter
    "meter.control_points"        => static string VAR_METER_CONTROL_POINTS;
    "meter.size"                  => static string VAR_METER_SIZE;
    "meter.border_radius"         => static string VAR_METER_BORDER_RADIUS;
    "meter.border_width"          => static string VAR_METER_BORDER_WIDTH;
    "meter.z_index"               => static string VAR_METER_Z_INDEX;
    "meter.rotate"                => static string VAR_METER_ROTATE;

    // Radio
    "radio.control_points"        => static string VAR_RADIO_CONTROL_POINTS;
    "radio.spacing"               => static string VAR_RADIO_SPACING;
    "radio.size"                  => static string VAR_RADIO_SIZE;
    "radio.layout"                => static string VAR_RADIO_LAYOUT; // "column" or "row"
    "radio.border_radius"         => static string VAR_RADIO_BORDER_RADIUS;
    "radio.border_width"          => static string VAR_RADIO_BORDER_WIDTH;
    "radio.label_spacing"         => static string VAR_RADIO_LABEL_SPACING;
    "radio.label_size"            => static string VAR_RADIO_LABEL_SIZE;
    "radio.font"                  => static string VAR_RADIO_FONT;
    "radio.z_index"               => static string VAR_RADIO_Z_INDEX;
    "radio.rotate"                => static string VAR_RADIO_ROTATE;

    // ==== Internal Stacks and Value Arrays ====

    @doc "(hidden)"
    static vec4        colorStacks[0][0];
    @doc "(hidden)"
    static string      colorOrder[0];

    @doc "(hidden)"
    static float       floatStacks[0][0];
    @doc "(hidden)"
    static vec2        vec2Stacks[0][0];
    @doc "(hidden)"
    static vec3        vec3Stacks[0][0];
    @doc "(hidden)"
    static string      stringStacks[0][0];
    @doc "(hidden)"
    static string      varOrder[0];

    @doc "(hidden)"
    fun static void clearStacks() {
        // clear color stacks
        colorOrder.clear();
        string colorKeys[0];
        colorStacks.getKeys(colorKeys);
        for (string k : colorKeys) {
            colorStacks[k].clear();
        }
        // clear var stacks
        varOrder.clear();
        string varKeys[0];
        floatStacks.getKeys(varKeys);
        for (string k : varKeys) floatStacks[k].clear();
        vec2Stacks.getKeys(varKeys);
        for (string k : varKeys) vec2Stacks[k].clear();
        vec3Stacks.getKeys(varKeys);
        for (string k : varKeys) vec3Stacks[k].clear();
        stringStacks.getKeys(varKeys);
        for (string k : varKeys) stringStacks[k].clear();
    }

    // ==== Color API ====

    @doc "Push a temporary override for a color style key onto the stack. Must be popped by calling popColor()."
    fun static void pushColor(string key, vec3 v) {
        pushColor(key, @(v.x, v.y, v.z, 1.0));
    }
    @doc "Push a temporary override for a color style key onto the stack. Must be popped by calling popColor()."
    fun static void pushColor(string key, vec4 v) {
        if (!colorStacks.isInMap(key)) { vec4 s[0] @=> colorStacks[key]; }
        colorStacks[key] << v;
        colorOrder << key;
    }
    @doc "Pop the last color style override. Must be preceded by a pushColor() call."
    fun static void popColor() {
        if (colorOrder.size() == 0) return;
        colorOrder[colorOrder.size() - 1] => string key;
        colorOrder.popBack();
        if (colorStacks.isInMap(key) && colorStacks[key].size() > 0) colorStacks[key].popBack();
    }
    @doc "Pop the last 'count' color style overrides. Must be preceded by 'count' pushStyleColor() calls."
    fun static void popColor(int count) {
        for (0 => int i; i < count; i++) {
            popColor();
        }
    }

    @doc "Get the color value for a color style key, returning a fallback value if not set."
    fun static vec4 color(string key, vec3 fallback) { return color(key, @(fallback.x, fallback.y, fallback.z, 1.0)); }
    @doc "Get the color value for a color style key, returning a fallback value if not set."
    fun static vec4 color(string key, vec4 fallback) {
        if (colorStacks.isInMap(key) && colorStacks[key].size() > 0)
            return colorStacks[key][colorStacks[key].size() - 1];
        return fallback;
    }

    // ==== Var API ====

    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, float v) {
        if (!floatStacks.isInMap(key)) { float s[0] @=> floatStacks[key]; }
        floatStacks[key] << v;
        varOrder << key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, vec2 v) {
        if (!vec2Stacks.isInMap(key)) { vec2 s[0] @=> vec2Stacks[key]; }
        vec2Stacks[key] << v;
        varOrder << key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, vec3 v) {
        if (!vec3Stacks.isInMap(key)) { vec3 s[0] @=> vec3Stacks[key]; }
        vec3Stacks[key] << v;
        varOrder << key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, string v) {
        if (!stringStacks.isInMap(key)) { string s[0] @=> stringStacks[key]; }
        stringStacks[key] << v;
        varOrder << key;
    }

    @doc "Pop the last variable style override. Must be preceded by a pushVar() call."
    fun static void popVar() {
        if (varOrder.size() == 0) return;
        varOrder[varOrder.size() - 1] => string key;
        varOrder.popBack();
        if (floatStacks.isInMap(key) && floatStacks[key].size() > 0) floatStacks[key].popBack();
        else if (vec2Stacks.isInMap(key) && vec2Stacks[key].size() > 0) vec2Stacks[key].popBack();
        else if (vec3Stacks.isInMap(key) && vec3Stacks[key].size() > 0) vec3Stacks[key].popBack();
        else if (stringStacks.isInMap(key) && stringStacks[key].size() > 0) stringStacks[key].popBack();
    }
    @doc "Pop the last 'count' variable style overrides. Must be preceded by 'count' pushVar() calls."
    fun static void popVar(int count) {
        for (0 => int i; i < count; i++) {
            popVar();
        }
    }

    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static float varFloat(string key, float fallback) {
        if (floatStacks.isInMap(key) && floatStacks[key].size() > 0)
            return floatStacks[key][floatStacks[key].size() - 1];
        return fallback;
    }
    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static vec2 varVec2(string key, vec2 fallback) {
        if (vec2Stacks.isInMap(key) && vec2Stacks[key].size() > 0)
            return vec2Stacks[key][vec2Stacks[key].size() - 1];
        return fallback;
    }
    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static vec3 varVec3(string key, vec3 fallback) {
        if (vec3Stacks.isInMap(key) && vec3Stacks[key].size() > 0)
            return vec3Stacks[key][vec3Stacks[key].size() - 1];
        return fallback;
    }
    @doc "Get the value for a variable style key, returning a fallback value if not set."
    fun static string varString(string key, string fallback) {
        if (stringStacks.isInMap(key) && stringStacks[key].size() > 0)
            return stringStacks[key][stringStacks[key].size() - 1];
        return fallback;
    }
}