@import "ComponentStyleMap.ck"
@import "DebugStyles.ck"
@import "GComponent.ck"
@import "../UIStyle.ck"

public class Debug {
    // ==== State ====

    int _enabled;
    string _components[0];
    GComponent @ _componentRefs[0];
    string _componentTypes[0];
    int _debugMap[0];  // compId => 1 for O(1) lookup
    int _addCallCount;

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

    fun void enabled(int e) {
        e => _enabled;
        if (e) {
            ComponentStyleMap.init();
        }
    }

    fun int enabled() { return _enabled; }

    fun void add(string customId, GComponent @ comp, string compType, string compId,
                 int rectCount, int iconCount, int labelCount, int meterCount) {
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

    // ==== Style Override Helpers (called by ChuGUI component methods) ====

    fun void applyOverrides(string compId, GComponent @ comp) {
        DebugStyles.applyOverrides(compId);
        // Apply position override
        if (_posOverrideEnabled.isInMap(compId) && _posOverrideEnabled[compId]) {
            comp.setPosWorld(_posOverrides[compId]);
        }
    }

    fun void popOverrides(string compId) {
        UIStyle.popColor(DebugStyles.countColorOverrides(compId));
        UIStyle.popVar(DebugStyles.countVarOverrides(compId));
    }

    // ==== Debug Panel Rendering ====

    fun void renderPanel() {
        if (!_enabled) return;

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
                ["LEFT", "CENTER", "RIGHT"] @=> string options[];
                0 => int currentIdx;
                if (val == "CENTER") 1 => currentIdx;
                else if (val == "RIGHT") 2 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("layout") >= 0) {
                ["column", "row"] @=> string options[];
                0 => int currentIdx;
                if (val == "row") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
                    DebugStyles.setStringEnabled(compId, key, true);
                    true => enabled.val;
                }
            } else if (key.find("sampler") >= 0) {
                ["NEAREST", "LINEAR"] @=> string options[];
                0 => int currentIdx;
                if (val == "LINEAR") 1 => currentIdx;

                UI_Int selectedIdx;
                currentIdx => selectedIdx.val;
                if (UI.combo(key, selectedIdx, options)) {
                    DebugStyles.setString(compId, key, options[selectedIdx.val()]);
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
        UI.drag("min##pos", sliderMin, 0.1, 0.0, 0.0, "%.2f", 0);
        UI.sameLine();
        UI.drag("max##pos", sliderMax, 0.1, 0.0, 0.0, "%.2f", 0);
        UI.popItemWidth();

        enabled.val() => int enabledInt;
        enabledInt => _posOverrideEnabled[compId];
    }
}
