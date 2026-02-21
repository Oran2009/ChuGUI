@import "ComponentStyleMap.ck"
@import "DebugStyles.ck"
@import "GComponent.ck"
@import "UIGlobals.ck"
@import "../UIStyle.ck"
@import "../components/Rect.ck"
@import "../components/Icon.ck"
@import "../components/Label.ck"
@import "../components/Meter.ck"
@import "../components/Separator.ck"
@import "../components/Button.ck"
@import "../components/Slider.ck"
@import "../components/Checkbox.ck"
@import "../components/Input.ck"
@import "../components/Dropdown.ck"
@import "../components/ColorPicker.ck"
@import "../components/Knob.ck"
@import "../components/Radio.ck"
@import "../components/Spinner.ck"

public class Debug {
    // ==== State ====

    // Static string options for combo editors (avoid per-frame allocation)
    static string _alignOptions[0];
    static string _layoutOptions[0];
    static string _samplerOptions[0];

    int _enabled;
    int _debugCalled;
    string _components[0];
    GComponent @ _componentRefs[0];
    string _componentTypes[0];
    int _debugMap[0];  // compId => 1 for O(1) lookup
    int _addCallCount;

    // Scenegraph state
    int _scenegraphSortAsc;
    string _sgTypes[0];
    string _sgKeys[0];
    float _sgZ[0];
    string _sgMapKeys[0];

    // ImGUI wrappers (reused across frames to avoid allocation)
    // Uses flat maps with compound keys: "compId/styleKey"
    UI_Float4 _colorWrappers[0];
    UI_Float _floatWrappers[0];
    UI_Float _sliderMins[0];
    UI_Float _sliderMaxs[0];
    UI_Float _vec2SliderMins[0];
    UI_Float _vec2SliderMaxs[0];
    UI_Float2 _vec2Wrappers[0];

    // Position overrides (world coords, keyed by compId)
    vec2 _posOverrides[0];
    int _posOverrideEnabled[0];
    UI_Float2 _posWrappers[0];
    UI_Float _posSliderMins[0];
    UI_Float _posSliderMaxs[0];

    // ==== Public API ====

    fun void frameReset() {
        _debugCalled => _enabled;
        false => _debugCalled;
    }

    fun int enabled() { return _enabled; }

    fun void add(string customId, GComponent @ comp, string compType, string compId,
                 int rectCount, int iconCount, int labelCount, int meterCount, int separatorCount) {
        if (comp == null) return;

        // For mapped components (with internal ID), use that ID
        // For pooled components, use type-specific counter (the count was already incremented)
        "" => string overrideId;
        if (compId != "") {
            compId => overrideId;
        } else {
            // Use type-specific counter for pooled components
            // The counter was already incremented after rendering, so subtract 1
            if (compType == "Rect") {
                compType + "_" + (rectCount - 1) => overrideId;
            } else if (compType == "Icon") {
                compType + "_" + (iconCount - 1) => overrideId;
            } else if (compType == "Label") {
                compType + "_" + (labelCount - 1) => overrideId;
            } else if (compType == "Meter") {
                compType + "_" + (meterCount - 1) => overrideId;
            } else if (compType == "Separator") {
                compType + "_" + (separatorCount - 1) => overrideId;
            } else {
                // Fallback for any other pooled types
                compType + "_" + _addCallCount => overrideId;
                _addCallCount++;
            }
        }

        // Override with custom ID if provided
        if (customId != "") {
            customId => overrideId;
        }

        // Check if already added (by override ID)
        if (_debugMap.isInMap(overrideId)) return;

        // Add to tracking arrays
        // Note: Create copies of strings to avoid reference issues
        "" + overrideId => string idCopy;
        "" + compType => string typeCopy;

        _components << idCopy;
        _componentRefs << comp;
        _componentTypes << typeCopy;
        1 => _debugMap[idCopy];

        // Initialize debug styles for this component
        DebugStyles.initComponent(idCopy, typeCopy);

        // Initialize position override from current component position
        if (!_posOverrides.isInMap(idCopy)) {
            comp._pos => _posOverrides[idCopy];
            0 => _posOverrideEnabled[idCopy];
        }
    }

    fun int isDebugging(string compId) {
        if (!_enabled) return false;
        return _debugMap.isInMap(compId);
    }

    // Remove a component from the debug panel by its ID
    fun void remove(string compId) {
        if (!_debugMap.isInMap(compId)) return;
        // Rebuild parallel arrays without the removed entry
        string newComponents[0];
        GComponent @ newRefs[0];
        string newTypes[0];
        for (0 => int i; i < _components.size(); i++) {
            if (_components[i] != compId) {
                newComponents << _components[i];
                newRefs << _componentRefs[i];
                newTypes << _componentTypes[i];
            }
        }
        newComponents @=> _components;
        newRefs @=> _componentRefs;
        newTypes @=> _componentTypes;
        // Rebuild _debugMap (reassign fresh to avoid .clear() bug)
        int freshMap[0]; freshMap @=> _debugMap;
        for (string c : _components) { 1 => _debugMap[c]; }
        DebugStyles.clearComponent(compId);
    }

    // ==== Style Override Helpers (called by ChuGUI component methods) ====

    fun void applyOverrides(string compId, GComponent @ comp) {
        DebugStyles.applyOverrides(compId);
        // Apply position override
        if (_posOverrideEnabled.isInMap(compId) && _posOverrideEnabled[compId]) {
            comp.setPosWorld(_posOverrides[compId]);
        }
    }

    fun void popOverrides(string compId) {
        UIStyle.popColor(DebugStyles.lastColorPushCount(compId));
        UIStyle.popVar(DebugStyles.lastVarPushCount(compId));
    }

    // ==== Debug Panel Rendering ====

    fun void renderPanel() {
        true => _debugCalled;

        // Reset debugAdd call counter for next frame
        0 => _addCallCount;

        if (_components.size() == 0) return;

        UI.begin("ChuGUI Debug Panel");

        for (0 => int i; i < _components.size(); i++) {
            _components[i] => string compId;
            _componentTypes[i] => string compType;

            if (UI.treeNode(compType + ": " + compId)) {
                // Reset button
                if (UI.button("Reset All")) {
                    DebugStyles.clearComponent(compId);
                    DebugStyles.initComponent(compId, compType);
                    0 => _posOverrideEnabled[compId];
                    _componentRefs[i]._pos => _posOverrides[compId];
                }

                UI.separator();

                // Position section
                if (UI.treeNode("Position")) {
                    renderPosEditor(compId);
                    UI.treePop();
                }

                // Colors section
                ComponentStyleMap.getColorKeys(compType) @=> string colorKeys[];
                if (colorKeys.size() > 0 && UI.treeNode("Colors")) {
                    renderColorEditors(compId, colorKeys);
                    UI.treePop();
                }

                // Float variables section
                ComponentStyleMap.getFloatKeys(compType) @=> string floatKeys[];
                if (floatKeys.size() > 0 && UI.treeNode("Size & Layout")) {
                    renderFloatEditors(compId, floatKeys);
                    UI.treePop();
                }

                // Vec2 variables section
                ComponentStyleMap.getVec2Keys(compType) @=> string vec2Keys[];
                if (vec2Keys.size() > 0 && UI.treeNode("Dimensions")) {
                    renderVec2Editors(compId, vec2Keys);
                    UI.treePop();
                }

                // String variables section
                ComponentStyleMap.getStringKeys(compType) @=> string stringKeys[];
                if (stringKeys.size() > 0 && UI.treeNode("Options")) {
                    renderStringEditors(compId, stringKeys);
                    UI.treePop();
                }

                UI.treePop();
            }
        }

        UI.end();
    }

    // ==== Internal Render Helpers ====

    fun void renderColorEditors(string compId, string keys[]) {
        for (string key : keys) {
            compId + "/" + key => string wrapperKey;

            if (!_colorWrappers.isInMap(wrapperKey)) {
                new UI_Float4 @=> _colorWrappers[wrapperKey];
            }
            _colorWrappers[wrapperKey] @=> UI_Float4 wrapper;

            DebugStyles.getColor(compId, key) => vec4 col;
            wrapper.val(col);

            UI_Bool enabled;
            DebugStyles.isColorEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            if (UI.colorEdit(key, wrapper, UI_ColorEditFlags.AlphaBar)) {
                DebugStyles.setColor(compId, key, wrapper.val());
                DebugStyles.setColorEnabled(compId, key, 1);
                1 => enabled.val;
            }

            enabled.val() => int enabledInt;
            DebugStyles.setColorEnabled(compId, key, enabledInt);
        }
    }

    fun void getDefaultSliderRange(string key, float currentVal, UI_Float minW, UI_Float maxW) {
        if (key.find("transparent") >= 0 || key.find("antialias") >= 0 ||
            key.find("border_radius") >= 0 || key.find("border_width") >= 0 ||
            key.find("check_width") >= 0) {
            0.0 => minW.val;
            1.0 => maxW.val;
        } else if (key.find("blend_mode") >= 0) {
            0.0 => minW.val;
            5.0 => maxW.val;
        } else if (key.find("wrap") >= 0) {
            0.0 => minW.val;
            2.0 => maxW.val;
        } else if (key.find("rotate") >= 0) {
            -360.0 => minW.val;
            360.0 => maxW.val;
        } else if (key.find("z_index") >= 0) {
            -10.0 => minW.val;
            10.0 => maxW.val;
        } else if (key.find("characters") >= 0) {
            0.0 => minW.val;
            100.0 => maxW.val;
        } else if (key.find("max_width") >= 0) {
            0.0 => minW.val;
            10.0 => maxW.val;
        } else if (key.find("spacing") >= 0 || key.find("padding") >= 0) {
            0.0 => minW.val;
            2.0 => maxW.val;
        } else if (key.find("ratio") >= 0 || key.find("radius") >= 0) {
            0.0 => minW.val;
            1.0 => maxW.val;
        } else if (key.find("delay") >= 0 || key.find("rate") >= 0) {
            1.0 => minW.val;
            60.0 => maxW.val;
        } else if (key.find("size") >= 0) {
            0.0 => minW.val;
            5.0 => maxW.val;
        } else {
            -10.0 => minW.val;
            10.0 => maxW.val;
        }

        if (currentVal < minW.val()) currentVal => minW.val;
        if (currentVal > maxW.val()) currentVal => maxW.val;
    }

    fun void getDefaultVec2SliderRange(string key, vec2 currentVal, UI_Float minW, UI_Float maxW) {
        if (key.find("control_points") >= 0) {
            0.0 => minW.val;
            1.0 => maxW.val;
        } else if (key.find("size") >= 0) {
            0.0 => minW.val;
            5.0 => maxW.val;
        } else {
            -10.0 => minW.val;
            10.0 => maxW.val;
        }

        Math.min(currentVal.x, currentVal.y) => float lower;
        Math.max(currentVal.x, currentVal.y) => float upper;
        if (lower < minW.val()) lower => minW.val;
        if (upper > maxW.val()) upper => maxW.val;
    }

    fun void renderFloatEditors(string compId, string keys[]) {
        for (string key : keys) {
            compId + "/" + key => string wrapperKey;

            if (!_floatWrappers.isInMap(wrapperKey)) {
                new UI_Float @=> _floatWrappers[wrapperKey];
            }
            _floatWrappers[wrapperKey] @=> UI_Float wrapper;

            DebugStyles.getFloat(compId, key) => wrapper.val;

            if (!_sliderMins.isInMap(wrapperKey)) {
                new UI_Float @=> _sliderMins[wrapperKey];
                new UI_Float @=> _sliderMaxs[wrapperKey];
                getDefaultSliderRange(key, wrapper.val(), _sliderMins[wrapperKey], _sliderMaxs[wrapperKey]);
            }
            _sliderMins[wrapperKey] @=> UI_Float sliderMin;
            _sliderMaxs[wrapperKey] @=> UI_Float sliderMax;

            UI_Bool enabled;
            DebugStyles.isFloatEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            0 => int changed;
            UI.slider(key, wrapper, sliderMin.val(), sliderMax.val()) => changed;

            UI.pushItemWidth(80.0);
            UI.drag("min##" + key, sliderMin, 0.1, 0.0, 0.0, "%.2f", 0);
            UI.sameLine();
            UI.drag("max##" + key, sliderMax, 0.1, 0.0, 0.0, "%.2f", 0);
            UI.popItemWidth();

            if (changed) {
                DebugStyles.setFloat(compId, key, wrapper.val());
                DebugStyles.setFloatEnabled(compId, key, true);
                true => enabled.val;
            }

            DebugStyles.setFloatEnabled(compId, key, enabled.val());
        }
    }

    fun void renderVec2Editors(string compId, string keys[]) {
        for (string key : keys) {
            compId + "/" + key => string wrapperKey;

            if (!_vec2Wrappers.isInMap(wrapperKey)) {
                new UI_Float2 @=> _vec2Wrappers[wrapperKey];
            }
            _vec2Wrappers[wrapperKey] @=> UI_Float2 wrapper;

            DebugStyles.getVec2(compId, key) => vec2 val;
            wrapper.val(val);

            if (!_vec2SliderMins.isInMap(wrapperKey)) {
                new UI_Float @=> _vec2SliderMins[wrapperKey];
                new UI_Float @=> _vec2SliderMaxs[wrapperKey];
                getDefaultVec2SliderRange(key, val, _vec2SliderMins[wrapperKey], _vec2SliderMaxs[wrapperKey]);
            }
            _vec2SliderMins[wrapperKey] @=> UI_Float sliderMin;
            _vec2SliderMaxs[wrapperKey] @=> UI_Float sliderMax;

            UI_Bool enabled;
            DebugStyles.isVec2Enabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            if (UI.drag(key, wrapper, 0.01, sliderMin.val(), sliderMax.val(), "%.3f", 0)) {
                wrapper.val() => vec2 newVal;

                DebugStyles.setVec2(compId, key, newVal);
                DebugStyles.setVec2Enabled(compId, key, true);
                true => enabled.val;
            }

            UI.pushItemWidth(80.0);
            UI.drag("min##" + key, sliderMin, 0.1, 0.0, 0.0, "%.2f", 0);
            UI.sameLine();
            UI.drag("max##" + key, sliderMax, 0.1, 0.0, 0.0, "%.2f", 0);
            UI.popItemWidth();

            DebugStyles.setVec2Enabled(compId, key, enabled.val());
        }
    }

    fun void renderStringEditors(string compId, string keys[]) {
        for (string key : keys) {
            DebugStyles.getString(compId, key) => string val;

            UI_Bool enabled;
            DebugStyles.isStringEnabled(compId, key) => enabled.val;
            UI.checkbox("##en_" + key, enabled);
            UI.sameLine();

            if (key.find("align") >= 0 || key.find("position") >= 0) {
                if (_alignOptions.size() == 0) { ["LEFT", "CENTER", "RIGHT"] @=> _alignOptions; }
                0 => int currentIdx;
                if (val == "CENTER") 1 => currentIdx;
                else if (val == "RIGHT") 2 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, _alignOptions)) {
                    DebugStyles.setString(compId, key, _alignOptions[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("layout") >= 0) {
                if (_layoutOptions.size() == 0) { ["column", "row"] @=> _layoutOptions; }
                0 => int currentIdx;
                if (val == "row") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, _layoutOptions)) {
                    DebugStyles.setString(compId, key, _layoutOptions[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("sampler") >= 0) {
                if (_samplerOptions.size() == 0) { ["NEAREST", "LINEAR"] @=> _samplerOptions; }
                0 => int currentIdx;
                if (val == "LINEAR") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, _samplerOptions)) {
                    DebugStyles.setString(compId, key, _samplerOptions[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else {
                UI_String wrapper;
                val => wrapper.val;
                if (UI.inputText(key, wrapper)) {
                    DebugStyles.setString(compId, key, wrapper.val());
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            }

            DebugStyles.setStringEnabled(compId, key, enabled.val());
        }
    }

    fun void renderPosEditor(string compId) {
        if (!_posWrappers.isInMap(compId)) {
            new UI_Float2 @=> _posWrappers[compId];
        }
        _posWrappers[compId] @=> UI_Float2 wrapper;

        _posOverrides[compId] => vec2 pos;
        wrapper.val(pos);

        if (!_posSliderMins.isInMap(compId)) {
            new UI_Float @=> _posSliderMins[compId];
            new UI_Float @=> _posSliderMaxs[compId];
            Math.min(pos.x, pos.y) => float lower;
            Math.max(pos.x, pos.y) => float upper;
            Math.min(lower, -5.0) => _posSliderMins[compId].val;
            Math.max(upper, 5.0) => _posSliderMaxs[compId].val;
        }
        _posSliderMins[compId] @=> UI_Float sliderMin;
        _posSliderMaxs[compId] @=> UI_Float sliderMax;

        UI_Bool enabled;
        _posOverrideEnabled.isInMap(compId) && _posOverrideEnabled[compId] => enabled.val;
        UI.checkbox("##en_pos", enabled);
        UI.sameLine();

        if (UI.drag("pos (World)", wrapper, 0.01, sliderMin.val(), sliderMax.val(), "%.3f", 0)) {
            wrapper.val() => vec2 newPos;
            newPos => _posOverrides[compId];
            1 => _posOverrideEnabled[compId];
            true => enabled.val;
        }

        UI.pushItemWidth(80.0);
        UI.drag("min##pos_" + compId, sliderMin, 0.1, 0.0, 0.0, "%.2f", 0);
        UI.sameLine();
        UI.drag("max##pos_" + compId, sliderMax, 0.1, 0.0, 0.0, "%.2f", 0);
        UI.popItemWidth();

        enabled.val() => int enabledInt;
        enabledInt => _posOverrideEnabled[compId];
    }

    // ==== Scenegraph Rendering ====

    fun void renderScenegraph(
        Rect rectPool[], int rectCount,
        Icon iconPool[], int iconCount,
        Label labelPool[], int labelCount,
        Meter meterPool[], int meterCount,
        Separator separatorPool[], int separatorCount,
        MomentaryButton buttons[],
        ToggleButton toggleBtns[],
        Slider sliders[],
        DiscreteSlider discreteSliders[],
        Checkbox checkboxes[],
        Input inputs[],
        Dropdown dropdowns[],
        ColorPicker colorPickers[],
        Knob knobs[],
        DiscreteKnob discreteKnobs[],
        Radio radios[],
        Spinner spinners[],
        int currentFrame
    ) {
        // Reuse member arrays to avoid per-frame allocation
        _sgTypes.clear(); _sgKeys.clear(); _sgZ.clear();
        _sgTypes @=> string sTypes[];
        _sgKeys @=> string sKeys[];
        _sgZ @=> float sZ[];

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

        // Reuse _sgMapKeys scratch array for all getKeys calls
        buttons.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (buttons[k].parent() == null) continue;
            sTypes << "Button"; sKeys << k; sZ << buttons[k].posZ();
        }

        toggleBtns.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (toggleBtns[k].parent() == null) continue;
            sTypes << "ToggleButton"; sKeys << k; sZ << toggleBtns[k].posZ();
        }

        sliders.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (sliders[k].parent() == null) continue;
            sTypes << "Slider"; sKeys << k; sZ << sliders[k].posZ();
        }

        discreteSliders.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (discreteSliders[k].parent() == null) continue;
            sTypes << "DiscreteSlider"; sKeys << k; sZ << discreteSliders[k].posZ();
        }

        checkboxes.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (checkboxes[k].parent() == null) continue;
            sTypes << "Checkbox"; sKeys << k; sZ << checkboxes[k].posZ();
        }

        inputs.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (inputs[k].parent() == null) continue;
            sTypes << "Input"; sKeys << k; sZ << inputs[k].posZ();
        }

        dropdowns.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (dropdowns[k].parent() == null) continue;
            sTypes << "Dropdown"; sKeys << k; sZ << dropdowns[k].posZ();
        }

        colorPickers.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (colorPickers[k].parent() == null) continue;
            sTypes << "ColorPicker"; sKeys << k; sZ << colorPickers[k].posZ();
        }

        knobs.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (knobs[k].parent() == null) continue;
            sTypes << "Knob"; sKeys << k; sZ << knobs[k].posZ();
        }

        discreteKnobs.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (discreteKnobs[k].parent() == null) continue;
            sTypes << "DiscreteKnob"; sKeys << k; sZ << discreteKnobs[k].posZ();
        }

        radios.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
            if (radios[k].parent() == null) continue;
            sTypes << "Radio"; sKeys << k; sZ << radios[k].posZ();
        }

        spinners.getKeys(_sgMapKeys);
        for (string k : _sgMapKeys) {
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
}
