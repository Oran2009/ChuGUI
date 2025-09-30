@import "lib/GComponent.ck"
@import "lib/MouseState.ck"
@import "UIStyle.ck"
@import "components/Rect.ck"
@import "components/Icon.ck"
@import "components/Label.ck"
@import "components/Button.ck"
@import "components/Slider.ck"
@import "components/Checkbox.ck"
@import "components/Input.ck"
@import "components/Dropdown.ck"
@import "components/ColorPicker.ck"
@import "components/Knob.ck"
@import "components/Meter.ck"
@import "components/Radio.ck"

@doc "ChuGUI is a flexible immediate-mode 2D GUI toolkit for ChuGL."
public class ChuGUI extends GGen {
    @doc "(hidden)"
    "0.1.0-alpha" => static string version;

    @doc "(hidden)"
    GComponent @ lastComponent;

    // ==== Pools ====

    @doc "(hidden)"
    Rect  rectPool[0];
    @doc "(hidden)"
    int rectCount;

    @doc "(hidden)"
    Icon  iconPool[0];
    @doc "(hidden)"
    int iconCount;

    @doc "(hidden)"
    Label labelPool[0];
    @doc "(hidden)"
    int labelCount;
    
    @doc "(hidden)"
    Meter meterPool[0];
    @doc "(hidden)"
    int meterCount;

    // ==== Maps ====
    
    @doc "(hidden)"
    MomentaryButton buttons[0];
    @doc "(hidden)"
    ToggleButton toggleBtns[0];

    @doc "(hidden)"
    Slider sliders[0];
    @doc "(hidden)"
    DiscreteSlider discreteSliders[0];

    @doc "(hidden)"
    Checkbox checkboxes[0];

    @doc "(hidden)"
    Input inputs[0];

    @doc "(hidden)"
    Dropdown dropdowns[0];

    @doc "(hidden)"
    ColorPicker colorPickers[0];

    @doc "(hidden)"
    Knob knobs[0];
    
    @doc "(hidden)"
    Radio radios[0];

    // ==== Frame Management ====

    @doc "(hidden)"
    int currentFrame;

    @doc "(hidden)"
    fun void resetFrame(GComponent components[]) {
        string keys[0];
        components.getKeys(keys);
        for (string k : keys) {
            components[k] @=> GComponent c;
            if (c != null) {
                c.frame(-1);
            }
        }
    }

    @doc "(hidden)"
    fun void cleanupPool(GComponent components[], int count) {
        for (count => int i; i < components.size(); i++) {
            components[i] @=> GComponent c;
            if (c == null || c.parent() == null) continue;
            c --< this;
        }
    }

    @doc "(hidden)"
    fun void cleanupMap(GComponent components[]) {
        string keys[0];
        components.getKeys(keys);
        for (string k : keys) {
            components[k] @=> GComponent c;
            if (c == null || c.parent() == null || c.frame() != -1) continue;
            c --< this;
        }
    }
    
    @doc "(hidden)"
    fun void update(float dt) {
        currentFrame++;
        (GG.fps() != 0) ? GG.fps() $ int : 60 %=> currentFrame;

        null => lastComponent;

        UIStyle.clearStacks();

        cleanupPool(rectPool, rectCount);
        cleanupPool(iconPool, iconCount);
        cleanupPool(labelPool, labelCount);
        cleanupPool(meterPool, meterCount);

        0 => rectCount;
        0 => iconCount;
        0 => labelCount;
        0 => meterCount;

        cleanupMap(buttons);
        cleanupMap(toggleBtns);
        cleanupMap(sliders);
        cleanupMap(discreteSliders);
        cleanupMap(checkboxes);
        cleanupMap(inputs);
        cleanupMap(dropdowns);
        cleanupMap(colorPickers);
        cleanupMap(knobs);
        cleanupMap(radios);

        resetFrame(buttons);
        resetFrame(toggleBtns);
        resetFrame(sliders);
        resetFrame(discreteSliders);
        resetFrame(checkboxes);
        resetFrame(inputs);
        resetFrame(dropdowns);
        resetFrame(colorPickers);
        resetFrame(knobs);
        resetFrame(radios);

        idStack.clear();
    }

    // ==== ID ====

    @doc "(hidden)"
    string idStack[0];

    @doc "Push an ID onto the ID stack. Must be popped by calling popID()."
    fun void pushID(string id) {
        idStack << id;
    }
    @doc "Pop the last ID from the ID stack. Must be preceded by a pushID() call."
    fun void popID() {
        if (idStack.size()) {
            idStack.popBack();
        }
    }
    @doc "(hidden)"
    fun string getID() {
        string id;
        for (int i; i < idStack.size(); i++) {
            idStack[i] + "/" +=> id;
        }
        return id;
    }

    // ==== Util Functions ====

    @doc "Convert NDC size to world size."
    fun static vec2 NDCToWorldSize(vec2 ndcSize) {
        GG.camera().NDCToWorldPos(@(ndcSize.x, ndcSize.y, 0)) => vec3 worldPos;
        GG.camera().NDCToWorldPos(@(0, 0, 0)) => vec3 origin;
        return @(Math.fabs(worldPos.x - origin.x), Math.fabs(worldPos.y - origin.y));
    }

    @doc "Returns whether the last component rendered is hovered or not."
    fun int hovered() {
        return lastComponent._state.hovered();
    }

    // ==== Pooled Components (Stateless) ====
    
    // Rect
    @doc "Render a GRect at the given position in NDC coordinates."
    fun void rect(vec2 pos) {
        if (rectCount == rectPool.size()) rectPool << new Rect();
        rectPool[rectCount] @=> Rect rect;

        rect.pos(pos);

        if (rect.parent() == null) {
            rect --> this;
        }

        rect.frame(currentFrame);
        rect.update();
        rect @=> lastComponent;
        rectCount++;
    }

    // Icon
    @doc "Render a GIcon with the given image path at the given position in NDC coordinates."
    fun void icon(string iconPath, vec2 pos) {
        if (iconCount == iconPool.size()) iconPool << new Icon();
        iconPool[iconCount] @=> Icon icon;
        icon.icon(iconPath);

        icon.pos(pos);

        if (icon.parent() == null) {
            icon --> this;
        }

        icon.frame(currentFrame);
        icon.update();
        icon @=> lastComponent;
        iconCount++;
    }

    // Label
    @doc "Render a label at the given position in NDC coordinates."
    fun void label(string text, vec2 pos) {
        if (labelCount == labelPool.size()) labelPool << new Label();
        labelPool[labelCount] @=> Label label;
        label.label(text);

        label.pos(pos);

        if (label.parent() == null) {
            label --> this;
        }

        label.frame(currentFrame);
        label.update();
        label @=> lastComponent;
        labelCount++;
    }

    // Meter
    @doc "Render a meter at the given position in NDC coordinates."
    fun void meter(vec2 pos, float min, float max, float val) {
        if (meterCount == meterPool.size()) meterPool << new Meter();
        meterPool[meterCount] @=> Meter meter;
        meter.min(min);
        meter.max(max);
        meter.val(val);

        meter.pos(pos);

        if (meter.parent() == null) {
            meter --> this;
        }

        meter.frame(currentFrame);
        meter.update();
        meter @=> lastComponent;
        meterCount++;
    }

    // ==== Mapped Components (Stateful, Interactive) ====

    // Buttons
    @doc "Render a button with given label at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, vec2 pos) { return button(label, "", pos, false); }
    @doc "Render a button with given label at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, vec2 pos, int disabled) { return button(label, "", pos, disabled); }
    @doc "Render a button with given label and icon at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, string icon, vec2 pos) { return button(label, icon, pos, false); }
    @doc "Render a button with given label and icon at the given position in NDC coordinates; returns 1 if the button is clicked during the current frame."
    fun int button(string label, string icon, vec2 pos, int disabled) {
        label != "" ? label : icon => string key;
        getID() != "" ? getID() : key => string id;
        if (!buttons.isInMap(id)) {
            new MomentaryButton() @=> buttons[id];
        }
        buttons[id] @=> MomentaryButton b;
        b.label(label);
        b.icon(icon);
        b.disabled(disabled);

        b.pos(pos);
                
        if (b.parent() == null) { 
            b --> this; 
        }

        b.frame(currentFrame);
        b.update();
        b @=> lastComponent;
        return b.clicked();
    }

    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, vec2 pos, int toggled) { return toggleButton(label, "", pos, toggled, false); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, vec2 pos, int toggled, int disabled) { return toggleButton(label, "", pos, toggled, disabled); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, string icon, vec2 pos, int toggled) { return toggleButton(label, icon, pos, toggled, false); }
    @doc "Render a toggle button at the given position in NDC coordinates; returns 1 if the button is toggled during the current frame."
    fun int toggleButton(string label, string icon, vec2 pos, int toggled, int disabled) {
        label != "" ? label : icon => string key;
        getID() != "" ? getID() : key => string id;
        if (!toggleBtns.isInMap(id)) {
            new ToggleButton() @=> toggleBtns[id];
        }
        toggleBtns[id] @=> ToggleButton b;
        b.label(label);
        b.icon(icon);
        b.disabled(disabled);
        b.toggled(toggled);

        b.pos(pos);

        if (b.parent() == null) { 
            b --> this; 
        }

        b.frame(currentFrame);
        b.update();
        b @=> lastComponent;
        return b.toggled();
    }

    // Sliders
    @doc "Render a slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float slider(string id, vec2 pos, float min, float max, float val) { return slider(id, pos, min, max, val, false); }
    @doc "Render a slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float slider(string id, vec2 pos, float min, float max, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!sliders.isInMap(_id)) {
            new Slider() @=> sliders[_id];
        }
        sliders[_id] @=> Slider slider;
        slider.min(min);
        slider.max(max);
        slider.val(val);
        slider.disabled(disabled);

        slider.pos(pos);
        
        if (slider.parent() == null) {
            slider --> this; 
        }

        slider.frame(currentFrame);
        slider.update();
        slider @=> lastComponent;
        return slider.val();
    }

    @doc "Render a discrete slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float discreteSlider(string id, vec2 pos, float min, float max, int steps, float val) { return discreteSlider(id, pos, min, max, steps, val, false); }
    @doc "Render a discrete slider at the given position in NDC coordinates; returns the value at the current frame."
    fun float discreteSlider(string id, vec2 pos, float min, float max, int steps, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!discreteSliders.isInMap(_id)) {
            new DiscreteSlider() @=> discreteSliders[_id];
        }
        discreteSliders[_id] @=> DiscreteSlider slider;
        slider.min(min);
        slider.max(max);
        slider.val(val);
        slider.steps(steps);
        slider.disabled(disabled);

        slider.pos(pos);
        
        if (slider.parent() == null) {
            slider --> this;
        }
        
        slider.frame(currentFrame);
        slider.update();
        slider @=> lastComponent;
        return slider.val();
    }

    // Checkbox
    @doc "Render a checkbox at the given position in NDC coordinates; returns 1 if the checkbox is checked during the current frame."
    fun int checkbox(string id, vec2 pos, int checked) { return checkbox(id, pos, checked, false); }
    @doc "Render a checkbox at the given position in NDC coordinates; returns 1 if the checkbox is checked during the current frame."
    fun int checkbox(string id, vec2 pos, int checked, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!checkboxes.isInMap(_id)) {
            new Checkbox() @=> checkboxes[_id];
        }
        checkboxes[_id] @=> Checkbox checkbox;
        checkbox.disabled(disabled);
        checkbox.checked(checked);

        checkbox.pos(pos);

        if (checkbox.parent() == null) {
            checkbox --> this;
        }

        checkbox.frame(currentFrame);
        checkbox.update();
        checkbox @=> lastComponent;
        return checkbox.checked();
    }

    // Input
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value) { return input(label, pos, value, "", false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value, string placeholder) { return input(label, pos, value, placeholder, false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string label, vec2 pos, string value, string placeholder, int disabled) {
        getID() != "" ? getID() : label => string id;
        if (!inputs.isInMap(id)) {
            new Input() @=> inputs[id];
        }
        inputs[id] @=> Input input;
        input.value(value);
        input.placeholder(placeholder);
        input.disabled(disabled);

        input.pos(pos);

        if (input.parent() == null) {
            input --> this;
        }

        input.frame(currentFrame);
        input.update();
        input @=> lastComponent;
        return input.value();
    }

    // Dropdown
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string label, vec2 pos, string options[], int selectedIndex) { return dropdown(label, pos, options, selectedIndex, false); }
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string label, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : label => string id;
        if (!dropdowns.isInMap(id)) {
            new Dropdown() @=> dropdowns[id];
        }
        dropdowns[id] @=> Dropdown dropdown;
        dropdown.placeholder(label);
        dropdown.options(options);
        dropdown.disabled(disabled);
        dropdown.selectedIndex(selectedIndex);

        dropdown.pos(pos);

        if (dropdown.parent() == null) {
            dropdown --> this;
        }

        dropdown.frame(currentFrame);
        dropdown.update();
        dropdown @=> lastComponent;
        return dropdown.selectedIndex();
    }
    
    // Color Picker
    @doc "Render a color picker at the given position in NDC coordinates; returns the selected color at the current frame."
    fun vec3 colorPicker(string id, vec2 pos, vec3 color) { return colorPicker(id, pos, color, false); }
    @doc "Render a color picker at the given position in NDC coordinates; returns the selected color at the current frame."
    fun vec3 colorPicker(string id, vec2 pos, vec3 color, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!colorPickers.isInMap(_id)) {
            new ColorPicker() @=> colorPickers[_id];
        }
        colorPickers[_id] @=> ColorPicker colorPicker;
        colorPicker.color(color);
        colorPicker.disabled(disabled);

        colorPicker.pos(pos);

        if (colorPicker.parent() == null) {
            colorPicker --> this;
        }

        colorPicker.frame(currentFrame);
        colorPicker.update();
        colorPicker @=> lastComponent;
        return colorPicker.color();
    }

    // Knob
    @doc "Render a knob at the given position in NDC coordinates; returns the value at the current frame."
    fun float knob(string id, vec2 pos, float min, float max, float val) { return knob(id, pos, min, max, val, false); }
    @doc "Render a knob at the given position in NDC coordinates; returns the value at the current frame."
    fun float knob(string id, vec2 pos, float min, float max, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!knobs.isInMap(_id)) {
            new Knob() @=> knobs[_id];
        }
        knobs[_id] @=> Knob knob;
        knob.min(min);
        knob.max(max);
        knob.val(val);
        knob.disabled(disabled);

        knob.pos(pos);

        if (knob.parent() == null) {
            knob --> this;
        }

        knob.frame(currentFrame);
        knob.update();
        knob @=> lastComponent;
        return knob.val();
    }

    // Radio
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex) { return radio(groupId, pos, options, selectedIndex, false); }
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : groupId => string id;
        if (!radios.isInMap(id)) {
            new Radio() @=> radios[id];
        }
        radios[id] @=> Radio radio;
        radio.options(options);
        radio.selectedIndex(selectedIndex);
        radio.disabled(disabled);

        radio.pos(pos);

        if (radio.parent() == null) {
            radio --> this;
        }

        radio.frame(currentFrame);
        radio.update();
        radio @=> lastComponent;
        return radio.selectedIndex();
    }

    // ==== Provided Icons ====

    me.dir() + "assets/icons/" => string iconDir;

    static string ARROW_RIGHT;
    iconDir + "arrow-right.png" => ARROW_RIGHT;
    static string ARROW_LEFT;
    iconDir + "arrow-left.png" => ARROW_LEFT;
    static string ARROW_DOWN;
    iconDir + "arrow-down.png" => ARROW_DOWN;
    static string ARROW_UP;
    iconDir + "arrow-up.png" => ARROW_UP;
    static string X;
    iconDir + "x.png" => X;
    static string PLUS;
    iconDir + "plus.png" => PLUS;
    static string MINUS;
    iconDir + "minus.png" => MINUS;
    static string USER;
    iconDir + "user.png" => USER;
    static string GEAR;
    iconDir + "gear.png" => GEAR;
    static string CHECK;
    iconDir + "check.png" => CHECK;
    static string SEARCH;
    iconDir + "magnifying-glass.png" => SEARCH;
}