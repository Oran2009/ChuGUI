@doc "ChuGUI's styling system."
public class UIStyle {
    // ==== Enums ====

    "NEAREST" => static string NEAREST;
    "LINEAR" => static string LINEAR;

    "LEFT" => static string LEFT;
    "RIGHT" => static string RIGHT;
    "CENTER" => static string CENTER;
    "TOP" => static string TOP;
    "BOTTOM" => static string BOTTOM;

    // ==== Color Keys ====

    // Rect
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "rect"                        => static string COL_RECT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "rect.border"                 => static string COL_RECT_BORDER;

    // Icon
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "icon"                        => static string COL_ICON;

    // Label
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "label"                        => static string COL_LABEL;

    // Tooltip
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.15, 0.15, 0.15, 0.95)."
    "tooltip"                      => static string COL_TOOLTIP;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "tooltip.text"                 => static string COL_TOOLTIP_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.3, 0.3, 0.3, 1)."
    "tooltip.border"               => static string COL_TOOLTIP_BORDER;

    // Button
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "button"                      => static string COL_BUTTON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with half alpha."
    "button.hovered"              => static string COL_BUTTON_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with quarter alpha."
    "button.pressed"              => static string COL_BUTTON_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 0.5)."
    "button.disabled"             => static string COL_BUTTON_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "button.text"                 => static string COL_BUTTON_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "button.text.hovered"         => static string COL_BUTTON_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "button.text.pressed"         => static string COL_BUTTON_TEXT_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "button.text.disabled"        => static string COL_BUTTON_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "button.border"               => static string COL_BUTTON_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "button.border.hovered"       => static string COL_BUTTON_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "button.border.pressed"       => static string COL_BUTTON_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "button.border.disabled"      => static string COL_BUTTON_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits text color."
    "button.icon"                 => static string COL_BUTTON_ICON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base icon color."
    "button.icon.hovered"         => static string COL_BUTTON_ICON_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base icon color."
    "button.icon.pressed"         => static string COL_BUTTON_ICON_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base icon color."
    "button.icon.disabled"        => static string COL_BUTTON_ICON_DISABLED;

    // Slider
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "slider.track"                  => static string COL_SLIDER_TRACK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base track color."
    "slider.track.hovered"          => static string COL_SLIDER_TRACK_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base track color."
    "slider.track.pressed"          => static string COL_SLIDER_TRACK_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "slider.track.disabled"         => static string COL_SLIDER_TRACK_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "slider.track.border"           => static string COL_SLIDER_TRACK_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base track border color."
    "slider.track.border.hovered"   => static string COL_SLIDER_TRACK_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base track border color."
    "slider.track.border.pressed"   => static string COL_SLIDER_TRACK_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "slider.track.border.disabled"  => static string COL_SLIDER_TRACK_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "slider.handle"                 => static string COL_SLIDER_HANDLE;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base handle color."
    "slider.handle.hovered"         => static string COL_SLIDER_HANDLE_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base handle color."
    "slider.handle.pressed"         => static string COL_SLIDER_HANDLE_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "slider.handle.disabled"        => static string COL_SLIDER_HANDLE_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "slider.handle.border"          => static string COL_SLIDER_HANDLE_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base handle border color."
    "slider.handle.border.hovered"  => static string COL_SLIDER_HANDLE_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base handle border color."
    "slider.handle.border.pressed"  => static string COL_SLIDER_HANDLE_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "slider.handle.border.disabled" => static string COL_SLIDER_HANDLE_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.2, 0.2, 1)."
    "slider.tick"                   => static string COL_SLIDER_TICK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "slider.tick.hovered"           => static string COL_SLIDER_TICK_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "slider.tick.pressed"           => static string COL_SLIDER_TICK_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "slider.tick.disabled"          => static string COL_SLIDER_TICK_DISABLED;

    // Checkbox
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "checkbox"                    => static string COL_CHECKBOX;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with half alpha."
    "checkbox.hovered"            => static string COL_CHECKBOX_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "checkbox.disabled"           => static string COL_CHECKBOX_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.3, 0.3, 0.3, 1)."
    "checkbox.border"             => static string COL_CHECKBOX_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "checkbox.border.hovered"     => static string COL_CHECKBOX_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "checkbox.border.disabled"    => static string COL_CHECKBOX_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color. Applied when checkbox is checked."
    "checkbox.checked"            => static string COL_CHECKBOX_CHECKED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color. Applied when checkbox is checked."
    "checkbox.border.checked"     => static string COL_CHECKBOX_BORDER_CHECKED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "checkbox.icon"               => static string COL_CHECKBOX_ICON;

    // Input
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "input"                       => static string COL_INPUT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "input.hovered"               => static string COL_INPUT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "input.focused"               => static string COL_INPUT_FOCUSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "input.disabled"              => static string COL_INPUT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "input.text"                  => static string COL_INPUT_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "input.text.disabled"         => static string COL_INPUT_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.3, 0.3, 0.3, 1)."
    "input.border"                => static string COL_INPUT_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "input.border.hovered"        => static string COL_INPUT_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "input.border.focused"        => static string COL_INPUT_BORDER_FOCUSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "input.border.disabled"       => static string COL_INPUT_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits text color with reduced alpha."
    "input.placeholder"           => static string COL_INPUT_PLACEHOLDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "input.cursor"                => static string COL_INPUT_CURSOR;

    // Dropdown
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.5, 0.5, 0.5, 1)."
    "dropdown"                      => static string COL_DROPDOWN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with half alpha."
    "dropdown.hovered"              => static string COL_DROPDOWN_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "dropdown.open"                 => static string COL_DROPDOWN_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color."
    "dropdown.disabled"             => static string COL_DROPDOWN_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "dropdown.border"               => static string COL_DROPDOWN_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "dropdown.border.hovered"       => static string COL_DROPDOWN_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "dropdown.border.open"          => static string COL_DROPDOWN_BORDER_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "dropdown.border.disabled"      => static string COL_DROPDOWN_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "dropdown.text"                 => static string COL_DROPDOWN_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "dropdown.text.hovered"         => static string COL_DROPDOWN_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "dropdown.text.open"            => static string COL_DROPDOWN_TEXT_OPEN;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "dropdown.text.disabled"        => static string COL_DROPDOWN_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits text color."
    "dropdown.arrow"                => static string COL_DROPDOWN_ARROW;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits dropdown base color."
    "dropdown.item"                 => static string COL_DROPDOWN_ITEM;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item color with half alpha."
    "dropdown.item.hovered"         => static string COL_DROPDOWN_ITEM_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item color."
    "dropdown.item.selected"        => static string COL_DROPDOWN_ITEM_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits dropdown border color."
    "dropdown.item.border"          => static string COL_DROPDOWN_ITEM_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item border color."
    "dropdown.item.border.hovered"  => static string COL_DROPDOWN_ITEM_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item border color."
    "dropdown.item.border.selected" => static string COL_DROPDOWN_ITEM_BORDER_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits dropdown text color."
    "dropdown.item.text"            => static string COL_DROPDOWN_ITEM_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item text color."
    "dropdown.item.text.hovered"    => static string COL_DROPDOWN_ITEM_TEXT_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits item text color."
    "dropdown.item.text.selected"   => static string COL_DROPDOWN_ITEM_TEXT_SELECTED;

    // Knob
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "knob"                        => static string COL_KNOB;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base knob color."
    "knob.hovered"                => static string COL_KNOB_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base knob color."
    "knob.pressed"                => static string COL_KNOB_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "knob.disabled"               => static string COL_KNOB_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.2, 0.2, 1)."
    "knob.border"                 => static string COL_KNOB_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "knob.border.hovered"         => static string COL_KNOB_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border color."
    "knob.border.pressed"         => static string COL_KNOB_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "knob.border.disabled"        => static string COL_KNOB_BORDER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.2, 0.2, 1)."
    "knob.indicator"              => static string COL_KNOB_INDICATOR;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base indicator color."
    "knob.indicator.hovered"      => static string COL_KNOB_INDICATOR_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base indicator color."
    "knob.indicator.pressed"      => static string COL_KNOB_INDICATOR_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "knob.indicator.disabled"     => static string COL_KNOB_INDICATOR_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.2, 0.2, 1)."
    "knob.tick"                   => static string COL_KNOB_TICK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "knob.tick.hovered"           => static string COL_KNOB_TICK_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "knob.tick.pressed"           => static string COL_KNOB_TICK_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base tick color."
    "knob.tick.disabled"          => static string COL_KNOB_TICK_DISABLED;

    // Meter
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.8, 0.8, 0.8, 1)."
    "meter.track"                 => static string COL_METER_TRACK;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.8, 0.2, 1)."
    "meter.fill"                  => static string COL_METER_FILL;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.5, 0.5, 0.5, 1)."
    "meter.track.border"          => static string COL_METER_TRACK_BORDER;

    // Radio
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(1, 1, 1, 1)."
    "radio.option"                => static string COL_RADIO_OPTION;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with half alpha."
    "radio.option.hovered"        => static string COL_RADIO_OPTION_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base color with quarter alpha."
    "radio.option.pressed"        => static string COL_RADIO_OPTION_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.9, 0.9, 0.9, 1)."
    "radio.option.disabled"       => static string COL_RADIO_OPTION_DISABLED;

    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.3, 0.3, 0.3, 1)."
    "radio.border"                => static string COL_RADIO_BORDER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border with half alpha."
    "radio.border.hovered"        => static string COL_RADIO_BORDER_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base border with quarter alpha."
    "radio.border.pressed"        => static string COL_RADIO_BORDER_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.7, 0.7, 0.7, 1)."
    "radio.border.disabled"       => static string COL_RADIO_BORDER_DISABLED;

    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.2, 0.2, 0.8, 1)."
    "radio.selected"              => static string COL_RADIO_SELECTED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "radio.label"                 => static string COL_RADIO_LABEL;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base label color."
    "radio.label.hovered"         => static string COL_RADIO_LABEL_HOVERED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base label color."
    "radio.label.pressed"         => static string COL_RADIO_LABEL_PRESSED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.5, 0.5, 0.5, 1)."
    "radio.label.disabled"        => static string COL_RADIO_LABEL_DISABLED;

    // Spinner
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits from button styles."
    "spinner"                     => static string COL_SPINNER;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 1)."
    "spinner.text"                => static string COL_SPINNER_TEXT;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base spinner color."
    "spinner.disabled"            => static string COL_SPINNER_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base text color."
    "spinner.text.disabled"       => static string COL_SPINNER_TEXT_DISABLED;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits from button styles."
    "spinner.button"              => static string COL_SPINNER_BUTTON;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Inherits base button color."
    "spinner.button.disabled"     => static string COL_SPINNER_BUTTON_DISABLED;

    // Separator
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0.3, 0.3, 0.3, 1)."
    "separator"                   => static string COL_SEPARATOR;
    @doc "Apply with pushColor(), using a vec3 or vec4 value. Default @(0, 0, 0, 0)."
    "separator.border"            => static string COL_SEPARATOR_BORDER;

    // ==== Var Keys ====

    // Global (apply to all components; overridden by component-specific keys)
    @doc "Apply with pushVar(). Global z_index for all components; overridden by component-specific z_index. Default 0."
    "z_index"                     => static string VAR_Z_INDEX;
    @doc "Apply with pushVar(). Global rotation for all components; overridden by component-specific rotate. Default 0."
    "rotate"                      => static string VAR_ROTATE;
    @doc "Apply with pushVar(). Global control points for all components; overridden by component-specific control_points. Default @(0.5, 0.5)."
    "control_points"              => static string VAR_CONTROL_POINTS;
    @doc "Apply with pushVar(). Global border radius; overridden by component-specific border_radius. Default 0."
    "border_radius"               => static string VAR_BORDER_RADIUS;
    @doc "Apply with pushVar(). Global border width; overridden by component-specific border_width. Default 0."
    "border_width"                => static string VAR_BORDER_WIDTH;
    @doc "Apply with pushVar(). Global font; overridden by component-specific font. Default \"\" (system font)."
    "font"                        => static string VAR_FONT;
    @doc "Apply with pushVar(). Global scale multiplier for all components; overridden by component-specific scale. Default 1.0."
    "scale"                       => static string VAR_SCALE;

    // Rect
    @doc "Apply with pushVar(), using an int value. Default 0 (opaque)."
    "rect.transparent"            => static string VAR_RECT_TRANSPARENT;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "rect.control_points"         => static string VAR_RECT_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.3, 0.3)."
    "rect.size"                   => static string VAR_RECT_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "rect.border_radius"          => static string VAR_RECT_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "rect.border_width"           => static string VAR_RECT_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "rect.z_index"                => static string VAR_RECT_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "rect.rotate"                 => static string VAR_RECT_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for rect size. Falls back to VAR_SCALE. Default 1.0."
    "rect.scale"                  => static string VAR_RECT_SCALE;

    // Icon
    @doc "Apply with pushVar(), using an int value. Default 1 (transparent)."
    "icon.transparent"            => static string VAR_ICON_TRANSPARENT;
    @doc "Apply with pushVar(), using UIStyle.NEAREST or UIStyle.LINEAR. Default UIStyle.LINEAR."
    "icon.sampler"                => static string VAR_ICON_SAMPLER;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp. Default -1 (not set; per-axis wraps used instead)."
    "icon.wrap"                 => static string VAR_ICON_WRAP;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp. Default Wrap_Repeat."
    "icon.wrap_u"                 => static string VAR_ICON_WRAP_U;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp. Default Wrap_Repeat."
    "icon.wrap_v"                 => static string VAR_ICON_WRAP_V;
    @doc "Apply with pushVar(), using TextureSampler.Wrap_Repeat, TextureSampler.Wrap_Mirror, or TextureSampler.Wrap_Clamp. Default Wrap_Repeat."
    "icon.wrap_w"                 => static string VAR_ICON_WRAP_W;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "icon.control_points"         => static string VAR_ICON_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. @(0, 0) means auto-size from texture dimensions."
    "icon.size"                   => static string VAR_ICON_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "icon.z_index"                => static string VAR_ICON_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "icon.rotate"                 => static string VAR_ICON_ROTATE;
    @doc "Apply with pushVar(), using Material.BLEND_MODE_ALPHA (0), BLEND_MODE_REPLACE (1), BLEND_MODE_ADD (2), BLEND_MODE_SUBTRACT (3), BLEND_MODE_MULTIPLY (4), or BLEND_MODE_SCREEN (5). Default BLEND_MODE_ALPHA."
    "icon.blend_mode"             => static string VAR_ICON_BLEND_MODE;
    @doc "Apply with pushVar(), using a vec2 value. UV offset into the texture. Default @(0, 0)."
    "icon.uv_offset"              => static string VAR_ICON_UV_OFFSET;
    @doc "Apply with pushVar(), using a vec2 value. UV scale (region size) of the texture. Default @(1, 1) (full texture)."
    "icon.uv_scale"               => static string VAR_ICON_UV_SCALE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for icon size. Falls back to VAR_SCALE. Default 1.0."
    "icon.scale"                  => static string VAR_ICON_SCALE;

    // Label
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "label.control_points"        => static string VAR_LABEL_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a float value. Default 0.2."
    "label.size"                  => static string VAR_LABEL_SIZE;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "label.font"                  => static string VAR_LABEL_FONT;
    @doc "Apply with pushVar(), using a float value. Default 1."
    "label.antialias"             => static string VAR_LABEL_ANTIALIAS;
    @doc "Apply with pushVar(), using a float value. Default 1.0."
    "label.spacing"               => static string VAR_LABEL_SPACING;
    @doc "Apply with pushVar(), using UIStyle.LEFT, UIStyle.CENTER, or UIStyle.RIGHT. Default UIStyle.LEFT."
    "label.align"                 => static string VAR_LABEL_ALIGN;
    @doc "Apply with pushVar(), using an int value. Default INT_MAX (no limit)."
    "label.characters"            => static string VAR_LABEL_CHARACTERS;
    @doc "Apply with pushVar(), using a float value. Default 0.0 (no text wrap)."
    "label.max_width"             => static string VAR_LABEL_MAX_WIDTH;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "label.z_index"               => static string VAR_LABEL_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "label.rotate"                => static string VAR_LABEL_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for label size. Falls back to VAR_SCALE. Default 1.0."
    "label.scale"                 => static string VAR_LABEL_SCALE;

    // Button
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "button.control_points"       => static string VAR_BUTTON_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3, 0.5)."
    "button.size"                 => static string VAR_BUTTON_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0.2."
    "button.text_size"            => static string VAR_BUTTON_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "button.border_radius"        => static string VAR_BUTTON_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "button.border_width"         => static string VAR_BUTTON_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "button.font"                 => static string VAR_BUTTON_FONT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "button.rotate"               => static string VAR_BUTTON_ROTATE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "button.z_index"              => static string VAR_BUTTON_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default matches text size."
    "button.icon_size"            => static string VAR_BUTTON_ICON_SIZE;
    @doc "Apply with pushVar(), using UIStyle.LEFT or UIStyle.RIGHT. Default UIStyle.LEFT."
    "button.icon_position"        => static string VAR_BUTTON_ICON_POSITION;
    @doc "Apply with pushVar(), using a float value. Factor of button height for icon-text spacing. Default 0.2."
    "button.icon_spacing"         => static string VAR_BUTTON_ICON_SPACING;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all button sizes. Falls back to VAR_SCALE. Default 1.0."
    "button.scale"                => static string VAR_BUTTON_SCALE;

    // Slider
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "slider.control_points"       => static string VAR_SLIDER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3.5, 0.2)."
    "slider.track_size"           => static string VAR_SLIDER_TRACK_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.track_border_radius"  => static string VAR_SLIDER_TRACK_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.track_border_width"   => static string VAR_SLIDER_TRACK_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.3, 0.3)."
    "slider.handle_size"          => static string VAR_SLIDER_HANDLE_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.handle_border_radius" => static string VAR_SLIDER_HANDLE_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.handle_border_width"  => static string VAR_SLIDER_HANDLE_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.05, 0.2)."
    "slider.tick_size"            => static string VAR_SLIDER_TICK_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.rotate"               => static string VAR_SLIDER_ROTATE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "slider.z_index"              => static string VAR_SLIDER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all slider sizes. Falls back to VAR_SCALE. Default 1.0."
    "slider.scale"                => static string VAR_SLIDER_SCALE;

    // Checkbox
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "checkbox.control_points"     => static string VAR_CHECKBOX_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.3, 0.3)."
    "checkbox.size"               => static string VAR_CHECKBOX_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "checkbox.border_radius"      => static string VAR_CHECKBOX_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "checkbox.border_width"       => static string VAR_CHECKBOX_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value that denotes the image path. Default check.png."
    "checkbox.icon"               => static string VAR_CHECKBOX_ICON;
    @doc "Apply with pushVar(), using a float value. Default matches checkbox size."
    "checkbox.icon_size"          => static string VAR_CHECKBOX_ICON_SIZE;
    @doc "Apply with pushVar(), using a float value. Default matches checkbox border width."
    "checkbox.check_width"        => static string VAR_CHECKBOX_CHECK_WIDTH;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "checkbox.z_index"            => static string VAR_CHECKBOX_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "checkbox.rotate"             => static string VAR_CHECKBOX_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for checkbox size. Falls back to VAR_SCALE. Default 1.0."
    "checkbox.scale"              => static string VAR_CHECKBOX_SCALE;

    // Input
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "input.control_points"        => static string VAR_INPUT_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3, 0.4)."
    "input.size"                  => static string VAR_INPUT_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0.15."
    "input.text_size"             => static string VAR_INPUT_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_RADIUS, then 0.1."
    "input.border_radius"         => static string VAR_INPUT_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_WIDTH, then 0.05."
    "input.border_width"          => static string VAR_INPUT_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "input.font"                  => static string VAR_INPUT_FONT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "input.z_index"               => static string VAR_INPUT_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "input.rotate"                => static string VAR_INPUT_ROTATE;
    @doc "Apply with pushVar(), using a float value. Text left padding from field edge. Default 0.05."
    "input.text_padding"          => static string VAR_INPUT_TEXT_PADDING;
    @doc "Apply with pushVar(), using a float value. Character width as a fraction of text size for cursor positioning. Default 0.6."
    "input.char_width_ratio"      => static string VAR_INPUT_CHAR_WIDTH_RATIO;
    @doc "Apply with pushVar(), using a float value. Frames before key repeat starts. Default 20."
    "input.key_repeat_delay"      => static string VAR_INPUT_KEY_REPEAT_DELAY;
    @doc "Apply with pushVar(), using a float value. Frames between key repeats. Default 5."
    "input.key_repeat_rate"       => static string VAR_INPUT_KEY_REPEAT_RATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all input sizes. Falls back to VAR_SCALE. Default 1.0."
    "input.scale"                 => static string VAR_INPUT_SCALE;

    // Dropdown
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "dropdown.control_points"     => static string VAR_DROPDOWN_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3, 0.4)."
    "dropdown.size"               => static string VAR_DROPDOWN_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0.2."
    "dropdown.text_size"          => static string VAR_DROPDOWN_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "dropdown.border_radius"      => static string VAR_DROPDOWN_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_WIDTH, then 0.1."
    "dropdown.border_width"       => static string VAR_DROPDOWN_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "dropdown.font"               => static string VAR_DROPDOWN_FONT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "dropdown.z_index"            => static string VAR_DROPDOWN_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "dropdown.rotate"             => static string VAR_DROPDOWN_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all dropdown sizes. Falls back to VAR_SCALE. Default 1.0."
    "dropdown.scale"              => static string VAR_DROPDOWN_SCALE;

    // Color Picker
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "color_picker.control_points" => static string VAR_COLOR_PICKER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(2.0, 1.0)."
    "color_picker.size"           => static string VAR_COLOR_PICKER_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "color_picker.z_index"        => static string VAR_COLOR_PICKER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "color_picker.rotate"         => static string VAR_COLOR_PICKER_ROTATE;
    @doc "Apply with pushVar(), using a float value. Preview rect width as a fraction of total width. Default 0.3."
    "color_picker.preview_ratio"  => static string VAR_COLOR_PICKER_PREVIEW_RATIO;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for color picker size. Falls back to VAR_SCALE. Default 1.0."
    "color_picker.scale"          => static string VAR_COLOR_PICKER_SCALE;

    // Knob
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "knob.control_points"         => static string VAR_KNOB_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "knob.size"                   => static string VAR_KNOB_SIZE;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_RADIUS, then 1.0."
    "knob.border_radius"          => static string VAR_KNOB_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_WIDTH, then 0.1."
    "knob.border_width"           => static string VAR_KNOB_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.04, 0.15)."
    "knob.indicator_size"         => static string VAR_KNOB_INDICATOR_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "knob.z_index"                => static string VAR_KNOB_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "knob.rotate"                 => static string VAR_KNOB_ROTATE;
    @doc "Apply with pushVar(), using a float value. Indicator position as a fraction of knob radius. Default 0.35."
    "knob.indicator_radius"       => static string VAR_KNOB_INDICATOR_RADIUS;
    @doc "Apply with pushVar(), using a vec2 value. Size of tick marks on DiscreteKnob. Default @(0.04, 0.12)."
    "knob.tick_size"              => static string VAR_KNOB_TICK_SIZE;
    @doc "Apply with pushVar(), using a float value. Tick gap from knob edge as fraction of knob radius. Default 0."
    "knob.tick_radius"            => static string VAR_KNOB_TICK_RADIUS;
    @doc "Apply with pushVar(), using a float value. Drag sensitivity multiplier. Default 1.0."
    "knob.sensitivity"            => static string VAR_KNOB_SENSITIVITY;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all knob sizes. Falls back to VAR_SCALE. Default 1.0."
    "knob.scale"                  => static string VAR_KNOB_SCALE;

    // Meter
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "meter.control_points"        => static string VAR_METER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3.0, 0.3)."
    "meter.size"                  => static string VAR_METER_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "meter.border_radius"         => static string VAR_METER_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_WIDTH, then 0.05."
    "meter.border_width"          => static string VAR_METER_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "meter.z_index"               => static string VAR_METER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "meter.rotate"                => static string VAR_METER_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for meter size. Falls back to VAR_SCALE. Default 1.0."
    "meter.scale"                 => static string VAR_METER_SCALE;

    // Radio
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "radio.control_points"        => static string VAR_RADIO_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a float value. Default 0.4."
    "radio.spacing"               => static string VAR_RADIO_SPACING;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.3, 0.3)."
    "radio.size"                  => static string VAR_RADIO_SIZE;
    @doc "Apply with pushVar(), using a string value of 'column' or 'row'. Default 'column'."
    "radio.layout"                => static string VAR_RADIO_LAYOUT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "radio.border_radius"         => static string VAR_RADIO_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Falls back to VAR_BORDER_WIDTH, then 0.1."
    "radio.border_width"          => static string VAR_RADIO_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value. Default 0.1."
    "radio.label_spacing"         => static string VAR_RADIO_LABEL_SPACING;
    @doc "Apply with pushVar(), using a float value. Default 0.2."
    "radio.label_size"            => static string VAR_RADIO_LABEL_SIZE;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "radio.font"                  => static string VAR_RADIO_FONT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "radio.z_index"               => static string VAR_RADIO_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "radio.rotate"                => static string VAR_RADIO_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all radio sizes. Falls back to VAR_SCALE. Default 1.0."
    "radio.scale"                 => static string VAR_RADIO_SCALE;

    // Spinner
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "spinner.control_points"      => static string VAR_SPINNER_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a vec2 value. Default @(3.0, 0.5)."
    "spinner.size"                => static string VAR_SPINNER_SIZE;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.25, 0.25)."
    "spinner.button_size"        => static string VAR_SPINNER_BUTTON_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0.2."
    "spinner.text_size"           => static string VAR_SPINNER_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0.1."
    "spinner.spacing"             => static string VAR_SPINNER_SPACING;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "spinner.font"                  => static string VAR_SPINNER_FONT;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "spinner.z_index"             => static string VAR_SPINNER_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "spinner.rotate"              => static string VAR_SPINNER_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for all spinner sizes. Falls back to VAR_SCALE. Default 1.0."
    "spinner.scale"               => static string VAR_SPINNER_SCALE;

    // Container
    @doc "Apply with pushVar(), using a float value. Spacing between children in a container. Default 0.1."
    "container.spacing"           => static string VAR_CONTAINER_SPACING;
    @doc "Apply with pushVar(), using a float value. Inner padding of a container. Default 0."
    "container.padding"           => static string VAR_CONTAINER_PADDING;
    @doc "Apply with pushVar(), using a vec2 value. Control points for container positioning. Default @(0.5, 0.5)."
    "container.control_points"    => static string VAR_CONTAINER_CONTROL_POINTS;

    // Tooltip
    @doc "Apply with pushVar(), using a float value. Font size for tooltip text. Default 0.12."
    "tooltip.text_size"           => static string VAR_TOOLTIP_TEXT_SIZE;
    @doc "Apply with pushVar(), using a float value. Inner padding around tooltip text. Default 0.03."
    "tooltip.padding"             => static string VAR_TOOLTIP_PADDING;
    @doc "Apply with pushVar(), using a float value. Corner radius. Default 0.02."
    "tooltip.border_radius"       => static string VAR_TOOLTIP_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Border width. Default 0."
    "tooltip.border_width"        => static string VAR_TOOLTIP_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a float value. Hover delay in seconds before showing tooltip. Default 0.5."
    "tooltip.delay"               => static string VAR_TOOLTIP_DELAY;
    @doc "Apply with pushVar(), using a float value. Z-index for tooltip. Default 1.0."
    "tooltip.z_index"             => static string VAR_TOOLTIP_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Gap between component and tooltip. Default 0.03."
    "tooltip.gap"                 => static string VAR_TOOLTIP_GAP;
    @doc "Apply with pushVar(), using a string value. Default \"\" (system font)."
    "tooltip.font"                => static string VAR_TOOLTIP_FONT;
    @doc "Apply with pushVar(), using a string value. Position of tooltip relative to component: UIStyle.TOP, UIStyle.BOTTOM, UIStyle.LEFT, UIStyle.RIGHT. Default UIStyle.BOTTOM."
    "tooltip.position"            => static string VAR_TOOLTIP_POSITION;
    @doc "Apply with pushVar(), using a float value. Character width as fraction of text size for tooltip width estimation. Default 0.6."
    "tooltip.char_width_ratio"    => static string VAR_TOOLTIP_CHAR_WIDTH_RATIO;

    // Separator
    @doc "Apply with pushVar(), using a vec2 value. Default @(1.0, 0.02)."
    "separator.size"              => static string VAR_SEPARATOR_SIZE;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "separator.border_radius"     => static string VAR_SEPARATOR_BORDER_RADIUS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "separator.border_width"      => static string VAR_SEPARATOR_BORDER_WIDTH;
    @doc "Apply with pushVar(), using a vec2 value. Default @(0.5, 0.5)."
    "separator.control_points"    => static string VAR_SEPARATOR_CONTROL_POINTS;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "separator.z_index"           => static string VAR_SEPARATOR_Z_INDEX;
    @doc "Apply with pushVar(), using a float value. Default 0."
    "separator.rotate"            => static string VAR_SEPARATOR_ROTATE;
    @doc "Apply with pushVar(), using a float value. Uniform scale multiplier for separator size. Falls back to VAR_SCALE. Default 1.0."
    "separator.scale"             => static string VAR_SEPARATOR_SCALE;

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
    static string      stringStacks[0][0];
    @doc "(hidden)"
    static string      varOrder[0];

    @doc "(hidden)"
    fun static void clearStacks() {
        colorOrder.clear();
        // Reassign fresh arrays — .clear() does not remove associative entries in ChucK
        vec4 freshColor[0][0]; freshColor @=> colorStacks;
        varOrder.clear();
        float freshFloat[0][0]; freshFloat @=> floatStacks;
        vec2 freshVec2[0][0]; freshVec2 @=> vec2Stacks;
        string freshString[0][0]; freshString @=> stringStacks;
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
    @doc "Pop the last 'count' color style overrides. Must be preceded by 'count' pushColor() calls."
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
        varOrder << "f:" + key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, vec2 v) {
        if (!vec2Stacks.isInMap(key)) { vec2 s[0] @=> vec2Stacks[key]; }
        vec2Stacks[key] << v;
        varOrder << "v:" + key;
    }
    @doc "Push a temporary override for a variable style key onto the stack. Must be popped by calling popVar()."
    fun static void pushVar(string key, string v) {
        if (!stringStacks.isInMap(key)) { string s[0] @=> stringStacks[key]; }
        stringStacks[key] << v;
        varOrder << "s:" + key;
    }

    @doc "Pop the last variable style override. Must be preceded by a pushVar() call."
    fun static void popVar() {
        if (varOrder.size() == 0) return;
        varOrder[varOrder.size() - 1] => string entry;
        varOrder.popBack();
        entry.substring(0, 2) => string type;
        entry.substring(2) => string key;
        if (type == "f:" && floatStacks.isInMap(key) && floatStacks[key].size() > 0) floatStacks[key].popBack();
        else if (type == "v:" && vec2Stacks.isInMap(key) && vec2Stacks[key].size() > 0) vec2Stacks[key].popBack();
        else if (type == "s:" && stringStacks.isInMap(key) && stringStacks[key].size() > 0) stringStacks[key].popBack();
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
    fun static string varString(string key, string fallback) {
        if (stringStacks.isInMap(key) && stringStacks[key].size() > 0)
            return stringStacks[key][stringStacks[key].size() - 1];
        return fallback;
    }
}
