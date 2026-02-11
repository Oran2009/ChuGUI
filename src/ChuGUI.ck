@import "lib/UIGlobals.ck"
@import "lib/GComponent.ck"
@import "lib/ContainerContext.ck"
@import "lib/MouseState.ck"
@import "lib/UIUtil.ck"
@import "lib/Debug.ck"
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
@import "components/Spinner.ck"
@import "components/Separator.ck"

@doc "ChuGUI is a flexible immediate-mode 2D GUI toolkit for ChuGL."
public class ChuGUI extends GGen {
    @doc "(hidden)"
    "0.2.0" => static string version;

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

    @doc "(hidden)"
    Separator separatorPool[0];
    @doc "(hidden)"
    int separatorCount;

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
    DiscreteKnob discreteKnobs[0];

    @doc "(hidden)"
    Radio radios[0];

    @doc "(hidden)"
    Spinner spinners[0];

    // ==== Debug ====

    @doc "(hidden)"
    Debug _debug;
    int _scenegraphSortAsc;
    @doc "(hidden)"
    string _lastComponentType;
    @doc "(hidden)"
    string _lastComponentId;

    // ==== Tooltip ====

    @doc "(hidden)"
    GRect _tooltipRect;
    @doc "(hidden)"
    GText _tooltipText;
    @doc "(hidden)"
    float _tooltipTimer;
    @doc "(hidden)"
    GComponent @ _tooltipTarget;
    @doc "(hidden)"
    int _tooltipVisible;

    // ==== Container Layout State ====

    @doc "(hidden)"
    ContainerContext _containerStack[0];

    // ==== Frame Management ====

    @doc "(hidden)"
    int currentFrame;

    @doc "(hidden)"
    string _mapKeys[0]; // Reusable scratch array to avoid per-frame allocations

    @doc "(hidden)"
    fun void cleanupPool(GComponent components[], int count) {
        for (count => int i; i < components.size(); i++) {
            components[i] @=> GComponent c;
            if (c == null || c.parent() == null) continue;
            c --< this;
        }
    }

    // Combined cleanup + reset in a single pass (halves getKeys() calls)
    @doc "(hidden)"
    fun void cleanupAndResetMap(GComponent components[]) {
        components.getKeys(_mapKeys);
        for (string k : _mapKeys) {
            components[k] @=> GComponent c;
            if (c == null) continue;
            if (c.parent() != null && c.frame() == -1) {
                c --< this;
            }
            c.frame(-1);
        }
    }

    @doc "(hidden)"
    fun void update(float dt) {
        currentFrame++;

        GG.fps() $ int => int fps;
        (fps != 0) ? fps : 60 %=> currentFrame;

        null => lastComponent;

        UIStyle.clearStacks();
        UIUtil.cacheMousePos();
        CursorState.update();
        CursorState.clearStates();

        cleanupPool(rectPool, rectCount);
        cleanupPool(iconPool, iconCount);
        cleanupPool(labelPool, labelCount);
        cleanupPool(meterPool, meterCount);
        cleanupPool(separatorPool, separatorCount);

        0 => rectCount;
        0 => iconCount;
        0 => labelCount;
        0 => meterCount;
        0 => separatorCount;

        // 12 map traversals: inherent to ChucK's lack of generic map types.
        // Scratch array _mapKeys is reused (no per-frame allocation).
        cleanupAndResetMap(buttons);
        cleanupAndResetMap(toggleBtns);
        cleanupAndResetMap(sliders);
        cleanupAndResetMap(discreteSliders);
        cleanupAndResetMap(checkboxes);
        cleanupAndResetMap(inputs);
        cleanupAndResetMap(dropdowns);
        cleanupAndResetMap(colorPickers);
        cleanupAndResetMap(knobs);
        cleanupAndResetMap(discreteKnobs);
        cleanupAndResetMap(radios);
        cleanupAndResetMap(spinners);

        idStack.clear();
        _containerStack.clear();

        // Detach tooltip if it wasn't shown last frame
        if (!_tooltipVisible) {
            if (_tooltipRect.parent() != null) _tooltipRect --< this;
            if (_tooltipText.parent() != null) _tooltipText --< this;
        }
        false => _tooltipVisible;
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

    // ==== Globals ====

    @doc "Set the unit system for both positions and sizes of components. ChuGUI.NDC, ChuGUI.WORLD, or ChuGUI.SCREEN."
    fun void units(string unit) {
        unit => UIGlobals.sizeUnits;
        unit => UIGlobals.posUnits;
    }

    @doc "Set the unit system for the size of components. ChuGUI.NDC, ChuGUI.WORLD, or ChuGUI.SCREEN."
    fun void sizeUnits(string unit) {
        unit => UIGlobals.sizeUnits;
    }

    @doc "Set the unit system for the position of components. ChuGUI.NDC, ChuGUI.WORLD, or ChuGUI.SCREEN."
    fun void posUnits(string unit) {
        unit => UIGlobals.posUnits;
    }

    @doc "Enable or disable gamma correction on the output pass. For 2D UI with sRGB colors (typical), disable gamma to avoid washed-out colors. Default is true (ChuGL default)."
    fun void gammaCorrection(int enabled) {
        GG.outputPass().gamma(enabled);
    }

    @doc "Get the current gamma correction state."
    fun int gammaCorrection() {
        return GG.outputPass().gamma();
    }

    // ==== UIUtil Functions ====

    @doc "Convert NDC size to world size."
    fun static vec2 NDCToWorldSize(vec2 ndcSize) {
        return UIUtil.NDCToWorldSize(ndcSize);
    }

    @doc "Convert world size to NDC size."
    fun static vec2 worldToNDCSize(vec2 worldSize) {
        return UIUtil.worldToNDCSize(worldSize);
    }

    @doc "Returns whether the last component rendered is hovered or not."
    fun int hovered() {
        return lastComponent._state.hovered();
    }

    @doc "Show a tooltip on hover for the last rendered component. Must be the very next ChuGUI call after the target component with no intervening render calls (e.g. rect(), button(), label()). The tooltip attaches to whatever lastComponent is at the time of this call. Appears after a configurable delay (UIStyle.VAR_TOOLTIP_DELAY)."
    fun void tooltip(string text) {
        if (lastComponent == null) return;
        if (!lastComponent._state.hovered()) {
            // Not hovering — if this was our target, reset
            if (lastComponent == _tooltipTarget) {
                0.0 => _tooltipTimer;
                null @=> _tooltipTarget;
            }
            return;
        }

        // Hovering — check if target changed
        if (lastComponent != _tooltipTarget) {
            lastComponent @=> _tooltipTarget;
            0.0 => _tooltipTimer;
        }

        // Accumulate timer
        GG.fps() => float fps;
        _tooltipTimer + (1.0 / ((fps > 0) ? fps : 60.0)) => _tooltipTimer;

        // Check delay
        UIStyle.varFloat(UIStyle.VAR_TOOLTIP_DELAY, 0.5) => float delay;
        if (_tooltipTimer < delay) return;

        // Show tooltip — read all style values
        UIStyle.color(UIStyle.COL_TOOLTIP, @(0.15, 0.15, 0.15, 0.95)) => vec4 bgColor;
        UIStyle.color(UIStyle.COL_TOOLTIP_TEXT, @(1, 1, 1, 1)) => vec4 textColor;
        UIStyle.color(UIStyle.COL_TOOLTIP_BORDER, @(0.3, 0.3, 0.3, 1)) => vec4 borderColor;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_TOOLTIP_TEXT_SIZE, 0.12)) => float textSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_TOOLTIP_PADDING, 0.03)) => float padding;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_TOOLTIP_BORDER_RADIUS, 0.02)) => float borderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_TOOLTIP_BORDER_WIDTH, 0)) => float borderWidth;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_TOOLTIP_GAP, 0.03)) => float gap;
        UIStyle.varFloat(UIStyle.VAR_TOOLTIP_Z_INDEX, 1.0) => float zIndex;
        UIStyle.varString(UIStyle.VAR_TOOLTIP_FONT, UIStyle.varString(UIStyle.VAR_FONT, "")) => string font;

        // Size the background
        text.length() $ float * textSize * 0.6 + padding * 2 => float bgWidth;
        textSize + padding * 2 => float bgHeight;

        // Position relative to the component
        _tooltipTarget.posWorld() => vec3 compPos;
        _tooltipTarget.computedSize() => vec2 compSize;
        UIStyle.varString(UIStyle.VAR_TOOLTIP_POSITION, UIStyle.BOTTOM) => string position;
        compPos.x => float tipX;
        compPos.y => float tipY;
        if (position == UIStyle.TOP) {
            compPos.y + compSize.y / 2.0 + gap + bgHeight / 2.0 => tipY;
        } else if (position == UIStyle.BOTTOM) {
            compPos.y - compSize.y / 2.0 - gap - bgHeight / 2.0 => tipY;
        } else if (position == UIStyle.LEFT) {
            compPos.x - compSize.x / 2.0 - gap - bgWidth / 2.0 => tipX;
        } else if (position == UIStyle.RIGHT) {
            compPos.x + compSize.x / 2.0 + gap + bgWidth / 2.0 => tipX;
        }

        // Configure rect
        _tooltipRect.size(@(bgWidth, bgHeight));
        _tooltipRect.color(bgColor);
        _tooltipRect.borderRadius(borderRadius);
        _tooltipRect.borderWidth(borderWidth);
        _tooltipRect.borderColor(borderColor);
        _tooltipRect.posX(tipX);
        _tooltipRect.posY(tipY);
        _tooltipRect.posZ(zIndex);

        // Configure text
        _tooltipText.text(text);
        _tooltipText.font(font);
        _tooltipText.color(textColor);
        _tooltipText.size(textSize);
        _tooltipText.controlPoints(@(0.5, 0.5));
        _tooltipText.posX(tipX);
        _tooltipText.posY(tipY);
        _tooltipText.posZ(zIndex + 0.1);

        // Attach
        if (_tooltipRect.parent() == null) _tooltipRect --> this;
        if (_tooltipText.parent() == null) _tooltipText --> this;
        true => _tooltipVisible;
    }

    // ==== Container Layout ====

    @doc "Begin a row container at the given position. Children are laid out left-to-right."
    fun void beginRow(vec2 pos) { _beginContainer(pos, "row"); }
    @doc "Begin a row container using the parent container's cursor position."
    fun void beginRow() { _beginContainer("row"); }

    @doc "Begin a column container at the given position. Children are laid out top-to-bottom."
    fun void beginColumn(vec2 pos) { _beginContainer(pos, "column"); }
    @doc "Begin a column container using the parent container's cursor position."
    fun void beginColumn() { _beginContainer("column"); }

    @doc "(hidden)"
    fun void _beginContainer(vec2 pos, string layout) {
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_CONTAINER_SPACING, 0.1)) => float spacing;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_CONTAINER_PADDING, 0.0)) => float padding;

        vec2 worldPos;
        if (_containerStack.size() > 0) {
            _containerStack[_containerStack.size()-1].nextPos() => worldPos;
        } else {
            if (UIGlobals.posUnits == "WORLD") {
                pos => worldPos;
            } else if (UIGlobals.posUnits == "SCREEN") {
                UIUtil.screenToWorldPos(pos) => worldPos;
            } else {
                GG.camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 wp;
                @(wp.x, wp.y) => worldPos;
            }
        }

        ContainerContext ctx;
        ctx.init(worldPos, layout, spacing, padding);
        _containerStack << ctx;

        if (layout == "row") {
            UIStyle.pushVar(UIStyle.VAR_CONTROL_POINTS,
                UIStyle.varVec2(UIStyle.VAR_CONTAINER_CONTROL_POINTS, @(0, 0.5)));  // left, vertically centered
        } else {
            UIStyle.pushVar(UIStyle.VAR_CONTROL_POINTS,
                UIStyle.varVec2(UIStyle.VAR_CONTAINER_CONTROL_POINTS, @(0, 1)));    // left, top-aligned
        }
    }

    @doc "(hidden)"
    fun void _beginContainer(string layout) {
        _beginContainer(@(0, 0), layout);
    }

    @doc "End a row container."
    fun void endRow() { _endContainer(); }
    @doc "End a column container."
    fun void endColumn() { _endContainer(); }

    @doc "(hidden)"
    fun void _endContainer() {
        if (_containerStack.size() == 0) return;

        _containerStack[_containerStack.size()-1] @=> ContainerContext ctx;
        ctx.totalSize() => vec2 totalSize;
        _containerStack.popBack();

        UIStyle.popVar();

        if (_containerStack.size() > 0) {
            _containerStack[_containerStack.size()-1].advance(totalSize);
        }
    }

    @doc "(hidden)"
    fun int _containerSetPos(GComponent @ comp) {
        if (_containerStack.size() == 0) return false;
        _containerStack[_containerStack.size()-1].nextPos() => vec2 worldPos;
        comp.setPosWorld(worldPos);
        return true;
    }

    @doc "(hidden)"
    fun void _containerAdvance(GComponent @ comp) {
        if (_containerStack.size() == 0) return;
        _containerStack[_containerStack.size()-1].advance(comp.computedSize());
    }

    // ==== Debug Panel ====

    @doc "Enable or disable the debug panel."
    fun void debugEnabled(int enabled) { _debug.enabled(enabled); }

    @doc "Returns whether the debug panel is enabled."
    fun int debugEnabled() { return _debug.enabled(); }

    @doc "Add the last rendered component to the debug panel with an auto-generated ID."
    fun void debugAdd() { debugAdd(""); }

    @doc "Add the last rendered component to the debug panel with a custom ID."
    fun void debugAdd(string customId) {
        _debug.add(customId, lastComponent, _lastComponentType, _lastComponentId,
                    rectCount, iconCount, labelCount, meterCount);
    }

    @doc "Render the debug panel. Call this each frame when debug mode is enabled."
    fun void debug() { _debug.renderPanel(); }

    // ==== Scenegraph Debug View ====

    @doc "Render the scenegraph debug view. Call this each frame when debug mode is enabled."
    fun void debugScenegraph() {
        if (!_debug.enabled()) return;

        // Collect all active components into sortable arrays
        string sTypes[0];
        string sKeys[0];
        float sZ[0];

        for (0 => int i; i < rectCount; i++) {
            sTypes << "Rect"; sKeys << "" + i; sZ << rectPool[i].posZ();
        }
        for (0 => int i; i < iconCount; i++) {
            sTypes << "Icon"; sKeys << "" + i; sZ << iconPool[i].posZ();
        }
        for (0 => int i; i < labelCount; i++) {
            sTypes << "Label"; sKeys << "" + i; sZ << labelPool[i].posZ();
        }
        for (0 => int i; i < meterCount; i++) {
            sTypes << "Meter"; sKeys << "" + i; sZ << meterPool[i].posZ();
        }
        for (0 => int i; i < separatorCount; i++) {
            sTypes << "Separator"; sKeys << "" + i; sZ << separatorPool[i].posZ();
        }

        string btnKeys[0];
        buttons.getKeys(btnKeys);
        for (string k : btnKeys) {
            if (buttons[k].parent() == null) continue;
            sTypes << "Button"; sKeys << k; sZ << buttons[k].posZ();
        }

        string toggleKeys[0];
        toggleBtns.getKeys(toggleKeys);
        for (string k : toggleKeys) {
            if (toggleBtns[k].parent() == null) continue;
            sTypes << "ToggleButton"; sKeys << k; sZ << toggleBtns[k].posZ();
        }

        string sliderKeys[0];
        sliders.getKeys(sliderKeys);
        for (string k : sliderKeys) {
            if (sliders[k].parent() == null) continue;
            sTypes << "Slider"; sKeys << k; sZ << sliders[k].posZ();
        }

        string discreteSliderKeys[0];
        discreteSliders.getKeys(discreteSliderKeys);
        for (string k : discreteSliderKeys) {
            if (discreteSliders[k].parent() == null) continue;
            sTypes << "DiscreteSlider"; sKeys << k; sZ << discreteSliders[k].posZ();
        }

        string checkboxKeys[0];
        checkboxes.getKeys(checkboxKeys);
        for (string k : checkboxKeys) {
            if (checkboxes[k].parent() == null) continue;
            sTypes << "Checkbox"; sKeys << k; sZ << checkboxes[k].posZ();
        }

        string inputKeys[0];
        inputs.getKeys(inputKeys);
        for (string k : inputKeys) {
            if (inputs[k].parent() == null) continue;
            sTypes << "Input"; sKeys << k; sZ << inputs[k].posZ();
        }

        string dropdownKeys[0];
        dropdowns.getKeys(dropdownKeys);
        for (string k : dropdownKeys) {
            if (dropdowns[k].parent() == null) continue;
            sTypes << "Dropdown"; sKeys << k; sZ << dropdowns[k].posZ();
        }

        string colorPickerKeys[0];
        colorPickers.getKeys(colorPickerKeys);
        for (string k : colorPickerKeys) {
            if (colorPickers[k].parent() == null) continue;
            sTypes << "ColorPicker"; sKeys << k; sZ << colorPickers[k].posZ();
        }

        string knobKeys[0];
        knobs.getKeys(knobKeys);
        for (string k : knobKeys) {
            if (knobs[k].parent() == null) continue;
            sTypes << "Knob"; sKeys << k; sZ << knobs[k].posZ();
        }

        string discreteKnobKeys[0];
        discreteKnobs.getKeys(discreteKnobKeys);
        for (string k : discreteKnobKeys) {
            if (discreteKnobs[k].parent() == null) continue;
            sTypes << "DiscreteKnob"; sKeys << k; sZ << discreteKnobs[k].posZ();
        }

        string radioKeys[0];
        radios.getKeys(radioKeys);
        for (string k : radioKeys) {
            if (radios[k].parent() == null) continue;
            sTypes << "Radio"; sKeys << k; sZ << radios[k].posZ();
        }

        string spinnerKeys[0];
        spinners.getKeys(spinnerKeys);
        for (string k : spinnerKeys) {
            if (spinners[k].parent() == null) continue;
            sTypes << "Spinner"; sKeys << k; sZ << spinners[k].posZ();
        }

        sZ.size() => int n;

        // Insertion sort by z-index
        for (1 => int i; i < n; i++) {
            sZ[i] => float zVal;
            sTypes[i] => string tVal;
            sKeys[i] => string kVal;
            i - 1 => int j;
            while (j >= 0 && ((_scenegraphSortAsc && sZ[j] > zVal) ||
                              (!_scenegraphSortAsc && sZ[j] < zVal))) {
                sZ[j] => sZ[j+1];
                sTypes[j] => sTypes[j+1];
                sKeys[j] => sKeys[j+1];
                j--;
            }
            zVal => sZ[j+1];
            tVal => sTypes[j+1];
            kVal => sKeys[j+1];
        }

        UI.begin("ChuGUI Scenegraph");

        UI.text("Active Components: " + n);
        UI.text("Frame: " + currentFrame);
        UI.text("Position Units: " + UIGlobals.posUnits + "  |  Size Units: " + UIGlobals.sizeUnits);

        UI_Bool sortAscBool;
        _scenegraphSortAsc => sortAscBool.val;
        if (UI.checkbox("Sort by Z-index ascending", sortAscBool)) {
            sortAscBool.val() => _scenegraphSortAsc;
        }

        UI.separator();

        // Render sorted components
        for (0 => int i; i < n; i++) {
            sTypes[i] => string type;
            sKeys[i] => string key;

            if (type == "Rect") {
                Std.atoi(key) => int idx;
                if (UI.treeNode(type + ": " + type + "_" + key + "##" + i)) {
                    UI.text("Pos (World): (" + rectPool[idx].posX() + ", " + rectPool[idx].posY() + ")");
                    UI.text("Z-Index: " + rectPool[idx].posZ());
                    UI.text("Rotation: " + rectPool[idx].rotZ());
                    UI.text("Hovered: " + (rectPool[idx]._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Icon") {
                Std.atoi(key) => int idx;
                if (UI.treeNode(type + ": " + type + "_" + key + "##" + i)) {
                    UI.text("Pos (World): (" + iconPool[idx].posX() + ", " + iconPool[idx].posY() + ")");
                    UI.text("Z-Index: " + iconPool[idx].posZ());
                    UI.text("Rotation: " + iconPool[idx].rotZ());
                    UI.text("Path: " + iconPool[idx]._icon);
                    UI.treePop();
                }
            } else if (type == "Label") {
                Std.atoi(key) => int idx;
                if (UI.treeNode(type + ": " + type + "_" + key + "##" + i)) {
                    UI.text("Pos (World): (" + labelPool[idx].posX() + ", " + labelPool[idx].posY() + ")");
                    UI.text("Z-Index: " + labelPool[idx].posZ());
                    UI.text("Rotation: " + labelPool[idx].rotZ());
                    UI.text("Text: " + labelPool[idx]._label);
                    UI.treePop();
                }
            } else if (type == "Meter") {
                Std.atoi(key) => int idx;
                if (UI.treeNode(type + ": " + type + "_" + key + "##" + i)) {
                    UI.text("Pos (World): (" + meterPool[idx].posX() + ", " + meterPool[idx].posY() + ")");
                    UI.text("Z-Index: " + meterPool[idx].posZ());
                    UI.text("Rotation: " + meterPool[idx].rotZ());
                    UI.text("Value: " + meterPool[idx].val() + " [" + meterPool[idx].min() + ", " + meterPool[idx].max() + "]");
                    UI.treePop();
                }
            } else if (type == "Button") {
                buttons[key] @=> MomentaryButton b;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + b.posX() + ", " + b.posY() + ")");
                    UI.text("Z-Index: " + b.posZ());
                    UI.text("Rotation: " + b.rotZ());
                    UI.text("Label: " + b.label());
                    UI.text("Icon: " + b.icon());
                    UI.text("Disabled: " + (b.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (b._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "ToggleButton") {
                toggleBtns[key] @=> ToggleButton tb;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + tb.posX() + ", " + tb.posY() + ")");
                    UI.text("Z-Index: " + tb.posZ());
                    UI.text("Rotation: " + tb.rotZ());
                    UI.text("Label: " + tb.label());
                    UI.text("Icon: " + tb.icon());
                    UI.text("Toggled: " + (tb.toggled() ? "Yes" : "No"));
                    UI.text("Disabled: " + (tb.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (tb._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Slider") {
                sliders[key] @=> Slider s;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + s.posX() + ", " + s.posY() + ")");
                    UI.text("Z-Index: " + s.posZ());
                    UI.text("Rotation: " + s.rotZ());
                    UI.text("Value: " + s.val());
                    UI.text("Range: [" + s.min() + ", " + s.max() + "]");
                    UI.text("Disabled: " + (s.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (s._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "DiscreteSlider") {
                discreteSliders[key] @=> DiscreteSlider ds;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + ds.posX() + ", " + ds.posY() + ")");
                    UI.text("Z-Index: " + ds.posZ());
                    UI.text("Rotation: " + ds.rotZ());
                    UI.text("Value: " + ds.val());
                    UI.text("Range: [" + ds.min() + ", " + ds.max() + "]");
                    UI.text("Steps: " + ds.steps());
                    UI.text("Disabled: " + (ds.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (ds._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Checkbox") {
                checkboxes[key] @=> Checkbox c;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + c.posX() + ", " + c.posY() + ")");
                    UI.text("Z-Index: " + c.posZ());
                    UI.text("Rotation: " + c.rotZ());
                    UI.text("Checked: " + (c.checked() ? "Yes" : "No"));
                    UI.text("Disabled: " + (c.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (c._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Input") {
                inputs[key] @=> Input inp;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + inp.posX() + ", " + inp.posY() + ")");
                    UI.text("Z-Index: " + inp.posZ());
                    UI.text("Rotation: " + inp.rotZ());
                    UI.text("Value: " + inp.value());
                    UI.text("Placeholder: " + inp.placeholder());
                    UI.text("Focused: " + (inp.focused() ? "Yes" : "No"));
                    UI.text("Disabled: " + (inp.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (inp._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Dropdown") {
                dropdowns[key] @=> Dropdown d;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + d.posX() + ", " + d.posY() + ")");
                    UI.text("Z-Index: " + d.posZ());
                    UI.text("Rotation: " + d.rotZ());
                    UI.text("Selected Index: " + d.selectedIndex());
                    UI.text("Open: " + (d._open ? "Yes" : "No"));
                    UI.text("Disabled: " + (d.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (d._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "ColorPicker") {
                colorPickers[key] @=> ColorPicker cp;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + cp.posX() + ", " + cp.posY() + ")");
                    UI.text("Z-Index: " + cp.posZ());
                    UI.text("Rotation: " + cp.rotZ());
                    cp.color() => vec3 col;
                    UI.text("Color RGB: (" + col.x + ", " + col.y + ", " + col.z + ")");
                    UI.text("Disabled: " + (cp.disabled() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Knob") {
                knobs[key] @=> Knob kb;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + kb.posX() + ", " + kb.posY() + ")");
                    UI.text("Z-Index: " + kb.posZ());
                    UI.text("Rotation: " + kb.rotZ());
                    UI.text("Value: " + kb.val());
                    UI.text("Range: [" + kb.min() + ", " + kb.max() + "]");
                    UI.text("Disabled: " + (kb.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (kb._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "DiscreteKnob") {
                discreteKnobs[key] @=> DiscreteKnob dk;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + dk.posX() + ", " + dk.posY() + ")");
                    UI.text("Z-Index: " + dk.posZ());
                    UI.text("Rotation: " + dk.rotZ());
                    UI.text("Value: " + dk.val());
                    UI.text("Range: [" + dk.min() + ", " + dk.max() + "]");
                    UI.text("Steps: " + dk.steps());
                    UI.text("Disabled: " + (dk.disabled() ? "Yes" : "No"));
                    UI.text("Hovered: " + (dk._state.hovered() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Separator") {
                Std.atoi(key) => int idx;
                if (UI.treeNode(type + ": " + type + "_" + key + "##" + i)) {
                    UI.text("Pos (World): (" + separatorPool[idx].posX() + ", " + separatorPool[idx].posY() + ")");
                    UI.text("Z-Index: " + separatorPool[idx].posZ());
                    UI.text("Rotation: " + separatorPool[idx].rotZ());
                    UI.treePop();
                }
            } else if (type == "Radio") {
                radios[key] @=> Radio r;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + r.posX() + ", " + r.posY() + ")");
                    UI.text("Z-Index: " + r.posZ());
                    UI.text("Rotation: " + r.rotZ());
                    UI.text("Selected Index: " + r.selectedIndex());
                    UI.text("Disabled: " + (r.disabled() ? "Yes" : "No"));
                    UI.treePop();
                }
            } else if (type == "Spinner") {
                spinners[key] @=> Spinner sp;
                if (UI.treeNode(type + ": " + key + "##" + i)) {
                    UI.text("ID: " + key);
                    UI.text("Pos (World): (" + sp.posX() + ", " + sp.posY() + ")");
                    UI.text("Z-Index: " + sp.posZ());
                    UI.text("Rotation: " + sp.rotZ());
                    UI.text("Value: " + sp.val());
                    UI.text("Range: [" + sp.min() + ", " + sp.max() + "]");
                    UI.text("Disabled: " + (sp.disabled() ? "Yes" : "No"));
                    UI.treePop();
                }
            }
        }

        UI.end();
    }

    // ==== Pooled Components (Stateless) ====
    
    // Rect
    @doc "Render a GRect at the given position in NDC coordinates."
    fun void rect(vec2 pos) {
        if (rectCount == rectPool.size()) rectPool << new Rect();
        rectPool[rectCount] @=> Rect rect;

        if (!_containerSetPos(rect)) { rect.pos(pos); }

        if (rect.parent() == null) {
            rect --> this;
        }

        // Calculate debug ID for this rect (before incrementing count)
        "Rect_" + rectCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(debugId)) {
            _debug.applyOverrides(debugId, rect);
        }

        rect.frame(currentFrame);
        rect.update();

        // Pop debug overrides
        if (_debug.isDebugging(debugId)) {
            _debug.popOverrides(debugId);
        }

        _containerAdvance(rect);

        rect @=> lastComponent;
        "Rect" => _lastComponentType;
        "" => _lastComponentId;
        rectCount++;
    }

    // Icon
    @doc "Render a GIcon with the given image path at the given position in NDC coordinates."
    fun void icon(string iconPath, vec2 pos) {
        if (iconCount == iconPool.size()) iconPool << new Icon();
        iconPool[iconCount] @=> Icon icon;
        icon.icon(iconPath);

        if (!_containerSetPos(icon)) { icon.pos(pos); }

        if (icon.parent() == null) {
            icon --> this;
        }

        // Calculate debug ID for this icon (before incrementing count)
        "Icon_" + iconCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(debugId)) {
            _debug.applyOverrides(debugId, icon);
        }

        icon.frame(currentFrame);
        icon.update();

        // Pop debug overrides
        if (_debug.isDebugging(debugId)) {
            _debug.popOverrides(debugId);
        }

        _containerAdvance(icon);

        icon @=> lastComponent;
        "Icon" => _lastComponentType;
        "" => _lastComponentId;
        iconCount++;
    }

    // Label
    @doc "Render a label at the given position in NDC coordinates."
    fun void label(string text, vec2 pos) {
        if (labelCount == labelPool.size()) labelPool << new Label();
        labelPool[labelCount] @=> Label label;
        label.label(text);

        if (!_containerSetPos(label)) { label.pos(pos); }

        if (label.parent() == null) {
            label --> this;
        }

        // Calculate debug ID for this label (before incrementing count)
        "Label_" + labelCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(debugId)) {
            _debug.applyOverrides(debugId, label);
        }

        label.frame(currentFrame);
        label.update();

        // Pop debug overrides
        if (_debug.isDebugging(debugId)) {
            _debug.popOverrides(debugId);
        }

        _containerAdvance(label);

        label @=> lastComponent;
        "Label" => _lastComponentType;
        "" => _lastComponentId;
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

        if (!_containerSetPos(meter)) { meter.pos(pos); }

        if (meter.parent() == null) {
            meter --> this;
        }

        // Calculate debug ID for this meter (before incrementing count)
        "Meter_" + meterCount => string debugId;

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(debugId)) {
            _debug.applyOverrides(debugId, meter);
        }

        meter.frame(currentFrame);
        meter.update();

        // Pop debug overrides
        if (_debug.isDebugging(debugId)) {
            _debug.popOverrides(debugId);
        }

        _containerAdvance(meter);

        meter @=> lastComponent;
        "Meter" => _lastComponentType;
        "" => _lastComponentId;
        meterCount++;
    }

    // Separator
    @doc "Render a separator at the given position."
    fun void separator(vec2 pos) {
        if (separatorCount == separatorPool.size()) separatorPool << new Separator();
        separatorPool[separatorCount] @=> Separator sep;

        if (!_containerSetPos(sep)) { sep.pos(pos); }

        if (sep.parent() == null) {
            sep --> this;
        }

        "Separator_" + separatorCount => string debugId;

        if (_debug.isDebugging(debugId)) {
            _debug.applyOverrides(debugId, sep);
        }

        sep.frame(currentFrame);
        sep.update();

        if (_debug.isDebugging(debugId)) {
            _debug.popOverrides(debugId);
        }

        _containerAdvance(sep);

        sep @=> lastComponent;
        "Separator" => _lastComponentType;
        "" => _lastComponentId;
        separatorCount++;
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

        if (!_containerSetPos(b)) { b.pos(pos); }

        if (b.parent() == null) {
            b --> this;
        }

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(id)) {
            _debug.applyOverrides(id, b);
        }

        b.frame(currentFrame);
        b.update();

        // Pop debug overrides
        if (_debug.isDebugging(id)) {
            _debug.popOverrides(id);
        }

        _containerAdvance(b);

        b @=> lastComponent;
        "Button" => _lastComponentType;
        id => _lastComponentId;
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

        if (!_containerSetPos(b)) { b.pos(pos); }

        if (b.parent() == null) {
            b --> this;
        }

        // Apply debug overrides if component is being debugged
        if (_debug.isDebugging(id)) {
            _debug.applyOverrides(id, b);
        }

        b.frame(currentFrame);
        b.update();

        // Pop debug overrides
        if (_debug.isDebugging(id)) {
            _debug.popOverrides(id);
        }

        _containerAdvance(b);

        b @=> lastComponent;
        "Button" => _lastComponentType;
        id => _lastComponentId;
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

        if (!_containerSetPos(slider)) { slider.pos(pos); }

        if (slider.parent() == null) {
            slider --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, slider);
        }

        slider.frame(currentFrame);
        slider.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(slider);

        slider @=> lastComponent;
        "Slider" => _lastComponentType;
        _id => _lastComponentId;
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

        if (!_containerSetPos(slider)) { slider.pos(pos); }

        if (slider.parent() == null) {
            slider --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, slider);
        }

        slider.frame(currentFrame);
        slider.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(slider);

        slider @=> lastComponent;
        "Slider" => _lastComponentType;
        _id => _lastComponentId;
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

        if (!_containerSetPos(checkbox)) { checkbox.pos(pos); }

        if (checkbox.parent() == null) {
            checkbox --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, checkbox);
        }

        checkbox.frame(currentFrame);
        checkbox.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(checkbox);

        checkbox @=> lastComponent;
        "Checkbox" => _lastComponentType;
        _id => _lastComponentId;
        return checkbox.checked();
    }

    // Input
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string id, vec2 pos, string value) { return input(id, pos, value, "", false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string id, vec2 pos, string value, string placeholder) { return input(id, pos, value, placeholder, false); }
    @doc "Render an input field at the given position in NDC coordinates; returns the input at the current frame."
    fun string input(string id, vec2 pos, string value, string placeholder, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!inputs.isInMap(_id)) {
            new Input() @=> inputs[_id];
        }
        inputs[_id] @=> Input input;
        input.value(value);
        input.placeholder(placeholder);
        input.disabled(disabled);

        if (!_containerSetPos(input)) { input.pos(pos); }

        if (input.parent() == null) {
            input --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, input);
        }

        input.frame(currentFrame);
        input.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(input);

        input @=> lastComponent;
        "Input" => _lastComponentType;
        _id => _lastComponentId;
        return input.value();
    }

    // Dropdown
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string id, vec2 pos, string options[], int selectedIndex) { return dropdown(id, pos, options, selectedIndex, false); }
    @doc "Render a dropdown at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int dropdown(string id, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!dropdowns.isInMap(_id)) {
            new Dropdown() @=> dropdowns[_id];
        }
        dropdowns[_id] @=> Dropdown dropdown;
        dropdown.placeholder(id);
        dropdown.options(options);
        dropdown.disabled(disabled);
        dropdown.selectedIndex(selectedIndex);

        if (!_containerSetPos(dropdown)) { dropdown.pos(pos); }

        if (dropdown.parent() == null) {
            dropdown --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, dropdown);
        }

        dropdown.frame(currentFrame);
        dropdown.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(dropdown);

        dropdown @=> lastComponent;
        "Dropdown" => _lastComponentType;
        _id => _lastComponentId;
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

        if (!_containerSetPos(colorPicker)) { colorPicker.pos(pos); }

        if (colorPicker.parent() == null) {
            colorPicker --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, colorPicker);
        }

        colorPicker.frame(currentFrame);
        colorPicker.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(colorPicker);

        colorPicker @=> lastComponent;
        "ColorPicker" => _lastComponentType;
        _id => _lastComponentId;
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

        if (!_containerSetPos(knob)) { knob.pos(pos); }

        if (knob.parent() == null) {
            knob --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, knob);
        }

        knob.frame(currentFrame);
        knob.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(knob);

        knob @=> lastComponent;
        "Knob" => _lastComponentType;
        _id => _lastComponentId;
        return knob.val();
    }

    // Discrete Knob
    @doc "Render a discrete knob at the given position; returns the value at the current frame."
    fun float discreteKnob(string id, vec2 pos, float min, float max, int steps, float val) { return discreteKnob(id, pos, min, max, steps, val, false); }
    @doc "Render a discrete knob at the given position; returns the value at the current frame."
    fun float discreteKnob(string id, vec2 pos, float min, float max, int steps, float val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!discreteKnobs.isInMap(_id)) {
            new DiscreteKnob() @=> discreteKnobs[_id];
        }
        discreteKnobs[_id] @=> DiscreteKnob dk;
        dk.min(min);
        dk.max(max);
        dk.val(val);
        dk.steps(steps);
        dk.disabled(disabled);

        if (!_containerSetPos(dk)) { dk.pos(pos); }

        if (dk.parent() == null) {
            dk --> this;
        }

        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, dk);
        }

        dk.frame(currentFrame);
        dk.update();

        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(dk);

        dk @=> lastComponent;
        "DiscreteKnob" => _lastComponentType;
        _id => _lastComponentId;
        return dk.val();
    }

    // Radio
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex) { return radio(groupId, pos, options, selectedIndex, false); }
    @doc "Render a radio group at the given position in NDC coordinates; returns the selected option at the current frame."
    fun int radio(string groupId, vec2 pos, string options[], int selectedIndex, int disabled) {
        getID() != "" ? getID() : groupId => string _id;
        if (!radios.isInMap(_id)) {
            new Radio() @=> radios[_id];
        }
        radios[_id] @=> Radio radio;
        radio.options(options);
        radio.selectedIndex(selectedIndex);
        radio.disabled(disabled);

        if (!_containerSetPos(radio)) { radio.pos(pos); }

        if (radio.parent() == null) {
            radio --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, radio);
        }

        radio.frame(currentFrame);
        radio.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(radio);

        radio @=> lastComponent;
        "Radio" => _lastComponentType;
        _id => _lastComponentId;
        return radio.selectedIndex();
    }

    // Spinner
    @doc "Render a spinner at the given position in NDC coordinates; returns the value at the current frame."
    fun int spinner(string id, vec2 pos, int min, int max, int val) { return spinner(id, pos, min, max, val, false); }
    @doc "Render a spinner at the given position in NDC coordinates; returns the value at the current frame."
    fun int spinner(string id, vec2 pos, int min, int max, int val, int disabled) {
        getID() != "" ? getID() : id => string _id;
        if (!spinners.isInMap(_id)) {
            new Spinner() @=> spinners[_id];
        }
        spinners[_id] @=> Spinner spinner;
        spinner.min(min);
        spinner.val(val);
        spinner.max(max);
        spinner.disabled(disabled);

        if (!_containerSetPos(spinner)) { spinner.pos(pos); }

        if (spinner.parent() == null) {
            spinner --> this;
        }

        // Apply debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.applyOverrides(_id, spinner);
        }

        spinner.frame(currentFrame);
        spinner.update();

        // Pop debug overrides
        if (_debug.isDebugging(_id)) {
            _debug.popOverrides(_id);
        }

        _containerAdvance(spinner);

        spinner @=> lastComponent;
        "Spinner" => _lastComponentType;
        _id => _lastComponentId;
        return spinner.val();
    }

    // ==== Position-less Overloads (for use inside containers) ====

    // Pooled
    @doc "Render a GRect. Position determined by container layout."
    fun void rect() { rect(@(0, 0)); }
    @doc "Render a GIcon. Position determined by container layout."
    fun void icon(string iconPath) { icon(iconPath, @(0, 0)); }
    @doc "Render a label. Position determined by container layout."
    fun void label(string text) { label(text, @(0, 0)); }
    @doc "Render a meter. Position determined by container layout."
    fun void meter(float min, float max, float val) { meter(@(0, 0), min, max, val); }
    @doc "Render a separator. Position determined by container layout."
    fun void separator() { separator(@(0, 0)); }

    // Button
    @doc "Render a button. Position determined by container layout."
    fun int button(string label) { return button(label, "", @(0, 0), false); }
    @doc "Render a button. Position determined by container layout."
    fun int button(string label, int disabled) { return button(label, "", @(0, 0), disabled); }
    @doc "Render a button with icon. Position determined by container layout."
    fun int button(string label, string icon) { return button(label, icon, @(0, 0), false); }
    @doc "Render a button with icon. Position determined by container layout."
    fun int button(string label, string icon, int disabled) { return button(label, icon, @(0, 0), disabled); }

    // Toggle Button
    @doc "Render a toggle button. Position determined by container layout."
    fun int toggleButton(string label, int toggled) { return toggleButton(label, "", @(0, 0), toggled, false); }
    @doc "Render a toggle button. Position determined by container layout."
    fun int toggleButton(string label, int toggled, int disabled) { return toggleButton(label, "", @(0, 0), toggled, disabled); }
    @doc "Render a toggle button with icon. Position determined by container layout."
    fun int toggleButton(string label, string icon, int toggled) { return toggleButton(label, icon, @(0, 0), toggled, false); }
    @doc "Render a toggle button with icon. Position determined by container layout."
    fun int toggleButton(string label, string icon, int toggled, int disabled) { return toggleButton(label, icon, @(0, 0), toggled, disabled); }

    // Slider
    @doc "Render a slider. Position determined by container layout."
    fun float slider(string id, float min, float max, float val) { return slider(id, @(0, 0), min, max, val, false); }
    @doc "Render a slider. Position determined by container layout."
    fun float slider(string id, float min, float max, float val, int disabled) { return slider(id, @(0, 0), min, max, val, disabled); }

    // Discrete Slider
    @doc "Render a discrete slider. Position determined by container layout."
    fun float discreteSlider(string id, float min, float max, int steps, float val) { return discreteSlider(id, @(0, 0), min, max, steps, val, false); }
    @doc "Render a discrete slider. Position determined by container layout."
    fun float discreteSlider(string id, float min, float max, int steps, float val, int disabled) { return discreteSlider(id, @(0, 0), min, max, steps, val, disabled); }

    // Checkbox
    @doc "Render a checkbox. Position determined by container layout."
    fun int checkbox(string id, int checked) { return checkbox(id, @(0, 0), checked, false); }
    @doc "Render a checkbox. Position determined by container layout."
    fun int checkbox(string id, int checked, int disabled) { return checkbox(id, @(0, 0), checked, disabled); }

    // Input
    @doc "Render an input. Position determined by container layout."
    fun string input(string id, string value) { return input(id, @(0, 0), value, "", false); }
    @doc "Render an input. Position determined by container layout."
    fun string input(string id, string value, string placeholder) { return input(id, @(0, 0), value, placeholder, false); }
    @doc "Render an input. Position determined by container layout."
    fun string input(string id, string value, string placeholder, int disabled) { return input(id, @(0, 0), value, placeholder, disabled); }

    // Dropdown
    @doc "Render a dropdown. Position determined by container layout."
    fun int dropdown(string id, string options[], int selectedIndex) { return dropdown(id, @(0, 0), options, selectedIndex, false); }
    @doc "Render a dropdown. Position determined by container layout."
    fun int dropdown(string id, string options[], int selectedIndex, int disabled) { return dropdown(id, @(0, 0), options, selectedIndex, disabled); }

    // Color Picker
    @doc "Render a color picker. Position determined by container layout."
    fun vec3 colorPicker(string id, vec3 color) { return colorPicker(id, @(0, 0), color, false); }
    @doc "Render a color picker. Position determined by container layout."
    fun vec3 colorPicker(string id, vec3 color, int disabled) { return colorPicker(id, @(0, 0), color, disabled); }

    // Knob
    @doc "Render a knob. Position determined by container layout."
    fun float knob(string id, float min, float max, float val) { return knob(id, @(0, 0), min, max, val, false); }
    @doc "Render a knob. Position determined by container layout."
    fun float knob(string id, float min, float max, float val, int disabled) { return knob(id, @(0, 0), min, max, val, disabled); }

    // Discrete Knob
    @doc "Render a discrete knob. Position determined by container layout."
    fun float discreteKnob(string id, float min, float max, int steps, float val) { return discreteKnob(id, @(0, 0), min, max, steps, val, false); }
    @doc "Render a discrete knob. Position determined by container layout."
    fun float discreteKnob(string id, float min, float max, int steps, float val, int disabled) { return discreteKnob(id, @(0, 0), min, max, steps, val, disabled); }

    // Radio
    @doc "Render a radio group. Position determined by container layout."
    fun int radio(string groupId, string options[], int selectedIndex) { return radio(groupId, @(0, 0), options, selectedIndex, false); }
    @doc "Render a radio group. Position determined by container layout."
    fun int radio(string groupId, string options[], int selectedIndex, int disabled) { return radio(groupId, @(0, 0), options, selectedIndex, disabled); }

    // Spinner
    @doc "Render a spinner. Position determined by container layout."
    fun int spinner(string id, int min, int max, int val) { return spinner(id, @(0, 0), min, max, val, false); }
    @doc "Render a spinner. Position determined by container layout."
    fun int spinner(string id, int min, int max, int val, int disabled) { return spinner(id, @(0, 0), min, max, val, disabled); }

    // ==== Spacer ====

    @doc "Advance the current container cursor by the given amount (in current size units). No visual output."
    fun void spacer(float size) {
        if (_containerStack.size() == 0) return;
        UIUtil.sizeToWorld(size) => float worldSize;
        _containerStack[_containerStack.size()-1].advance(@(worldSize, worldSize));
    }

    // Enums
    "NDC" => static string NDC;
    "WORLD" => static string WORLD;
    "SCREEN" => static string SCREEN;

    // ==== Provided Icons ====

    @doc "(hidden)"
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