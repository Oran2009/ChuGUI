@import "../lib/UIUtil.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../gmeshes/GRect.ck"
@import "../UIStyle.ck"

public class Knob extends GComponent {
    GRect gKnob --> this;
    GRect gIndicator --> this;

    string _postfix;
    float _min;
    float _max;
    float _val;
    
    new MouseState(this, gKnob) @=> _state;

    vec3 _startMousePos;
    float _startValue;

    // ==== Getters and Setters ====

    fun string postfix() { return _postfix; }
    fun void postfix(string postfix) { postfix => _postfix; }

    fun float min() { return _min; }
    fun void min(float min) { min => _min; }

    fun float max() { return _max; }
    fun void max(float max) { max => _max; }

    fun float val() { return _val; }
    fun void val(float v) {
        Math.clampf(v, _min, _max) => _val;
        if (gKnob.size().x > 0) updateIndicator();
    }

    // ==== Interaction ====

    fun void drag(vec3 deltaPos) {
        UIStyle.varFloat(UIStyle.VAR_KNOB_SENSITIVITY, 1.0) => float sensitivity;
        (deltaPos.y + deltaPos.x) * sensitivity * (_max - _min) => float deltaValue;
        _startValue + deltaValue => float newVal;
        val(newVal);
    }

    // ==== Update ====

    fun void updateIndicator() {
        -0.75 * Math.PI => float angleMin;
        -2.25 * Math.PI => float angleMax;

        (_max != _min) ? (_val - _min) / (_max - _min) : 0.0 => float t;
        angleMin + t * (angleMax - angleMin) => float angle;

        UIStyle.varFloat(UIStyle.VAR_KNOB_INDICATOR_RADIUS, 0.35) => float indicatorRadius;
        gKnob.size().x / 2.0 * indicatorRadius => float len;
        len * Math.cos(angle) => gIndicator.posX;
        len * Math.sin(angle) => gIndicator.posY;
        
        gIndicator.rotZ(angle + Math.PI/2);
    }

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_KNOB, @(0.7, 0.7, 0.7, 1)) => vec4 knobColor;
        UIStyle.color(UIStyle.COL_KNOB_BORDER, @(0.2, 0.2, 0.2, 1)) => vec4 knobBorderColor;
        UIStyle.color(UIStyle.COL_KNOB_INDICATOR, @(0.2, 0.2, 0.2, 1)) => vec4 indicatorColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5))) => vec2 knobSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_RADIUS, UIStyle.varFloat(UIStyle.VAR_BORDER_RADIUS, 1.0))) => float knobBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_WIDTH, UIStyle.varFloat(UIStyle.VAR_BORDER_WIDTH, 0.1))) => float knobBorderWidth;
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_INDICATOR_SIZE, @(0.04, 0.15))) => vec2 indicatorSize;

        UIStyle.varFloat(UIStyle.VAR_KNOB_SCALE, UIStyle.varFloat(UIStyle.VAR_SCALE, 1.0)) => float scale;
        scale *=> knobSize;
        scale *=> indicatorSize;

        UIStyle.varVec2(UIStyle.VAR_KNOB_CONTROL_POINTS, UIStyle.varVec2(UIStyle.VAR_CONTROL_POINTS, @(0.5, 0.5))) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_KNOB_Z_INDEX, UIStyle.varFloat(UIStyle.VAR_Z_INDEX, 0)) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_KNOB_ROTATE, UIStyle.varFloat(UIStyle.VAR_ROTATE, 0)) => float rotate;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_KNOB_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_DISABLED, @(0.7, 0.7, 0.7, 1)) => indicatorColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_KNOB_PRESSED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_PRESSED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_PRESSED, indicatorColor) => indicatorColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_KNOB_HOVERED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_HOVERED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_HOVERED, indicatorColor) => indicatorColor;
        }

        gKnob.size(knobSize);
        gKnob.color(knobColor);
        gKnob.borderRadius(knobBorderRadius);
        gKnob.borderWidth(knobBorderWidth);
        gKnob.borderColor(knobBorderColor);

        gIndicator.size(indicatorSize);
        gIndicator.color(indicatorColor);
        gIndicator.borderRadius(indicatorSize.x / 2);
        gIndicator.borderWidth(0);

        applyLayout(knobSize, controlPoints, zIndex, rotate);
    }


    fun void update() {
        _state.update();

        if (!_disabled) {
            if (_state.dragging()) {
                _state.mouseWorld() => vec3 currentMousePos;

                if (_state.clicked()) {
                    currentMousePos => _startMousePos;
                    _val => _startValue;
                } else {
                    currentMousePos - _startMousePos => vec3 deltaPos;
                    drag(deltaPos);
                }
            }
        }

        updateUI();
    }
}

public class DiscreteKnob extends Knob {
    true => int recreateTicks;
    2 => int _steps;
    GRect ticks[0];

    // ==== Getters and Setters ====

    fun int steps() { return _steps; }
    fun void steps(int s) {
        if (s < 2) 2 => s;
        s != _steps => recreateTicks;
        s => _steps;
    }

    // ==== Display ====

    fun void createTicks() {
        gKnob.size().x / 2.0 => float knobRadius;
        if (knobRadius <= 0.0) return;

        for (0 => int i; i < ticks.size(); i++) {
            ticks[i] --< this;
        }
        ticks.clear();

        -0.75 * Math.PI => float angleMin;
        -2.25 * Math.PI => float angleMax;
        gKnob.borderWidth() => float borderW;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_TICK_RADIUS, 0.0)) => float tickGap;
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_TICK_SIZE, @(0.04, 0.12))) => vec2 tickSize;
        knobRadius - borderW - tickSize.y / 2.0 - tickGap => float tickDist;

        UIStyle.color(UIStyle.COL_KNOB_TICK, @(0.2, 0.2, 0.2, 1)) => vec4 tickColor;

        for (0 => int i; i < _steps; i++) {
            GRect tick;
            tick.size(tickSize);
            tick.color(tickColor);
            tick.borderRadius(tickSize.x / 2.0);
            tick.borderWidth(0);

            i $ float / (_steps - 1) => float t;
            angleMin + t * (angleMax - angleMin) => float angle;

            tick.posX(tickDist * Math.cos(angle));
            tick.posY(tickDist * Math.sin(angle));
            tick.posZ(0.05);
            tick.rotZ(angle + Math.PI / 2.0);

            tick --> this;
            ticks << tick;
        }
    }

    fun void snapToNearestStep() {
        (_max != _min) ? (_val - _min) / (_max - _min) : 0.0 => float norm;
        norm * (_steps - 1) => float stepFloat;
        Math.round(stepFloat) $ int => int nearestStep;
        Math.clampi(nearestStep, 0, _steps - 1) => nearestStep;

        nearestStep $ float / (_steps - 1) => float snappedNorm;
        _min + snappedNorm * (_max - _min) => float snappedVal;

        snappedVal => _val;
        updateIndicator();
    }

    // ==== Interaction ====

    fun void drag(vec3 deltaPos) {
        UIStyle.varFloat(UIStyle.VAR_KNOB_SENSITIVITY, 1.0) => float sensitivity;
        (deltaPos.y + deltaPos.x) * sensitivity * (_max - _min) => float deltaValue;
        _startValue + deltaValue => float newVal;
        Math.clampf(newVal, _min, _max) => newVal;

        (_max != _min) ? (newVal - _min) / (_max - _min) : 0.0 => float norm;
        Math.round(norm * (_steps - 1)) $ int => int nearestStep;
        Math.clampi(nearestStep, 0, _steps - 1) => nearestStep;

        nearestStep $ float / (_steps - 1) => float snappedNorm;
        _min + snappedNorm * (_max - _min) => _val;
        updateIndicator();
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.color(UIStyle.COL_KNOB, @(0.7, 0.7, 0.7, 1)) => vec4 knobColor;
        UIStyle.color(UIStyle.COL_KNOB_BORDER, @(0.2, 0.2, 0.2, 1)) => vec4 knobBorderColor;
        UIStyle.color(UIStyle.COL_KNOB_INDICATOR, @(0.2, 0.2, 0.2, 1)) => vec4 indicatorColor;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_SIZE, @(0.5, 0.5))) => vec2 knobSize;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_RADIUS, UIStyle.varFloat(UIStyle.VAR_BORDER_RADIUS, 1.0))) => float knobBorderRadius;
        UIUtil.sizeToWorld(UIStyle.varFloat(UIStyle.VAR_KNOB_BORDER_WIDTH, UIStyle.varFloat(UIStyle.VAR_BORDER_WIDTH, 0.1))) => float knobBorderWidth;
        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_INDICATOR_SIZE, @(0.04, 0.15))) => vec2 indicatorSize;

        UIStyle.varFloat(UIStyle.VAR_KNOB_SCALE, UIStyle.varFloat(UIStyle.VAR_SCALE, 1.0)) => float scale;
        scale *=> knobSize;
        scale *=> indicatorSize;

        UIStyle.varVec2(UIStyle.VAR_KNOB_CONTROL_POINTS, UIStyle.varVec2(UIStyle.VAR_CONTROL_POINTS, @(0.5, 0.5))) => vec2 controlPoints;
        UIStyle.varFloat(UIStyle.VAR_KNOB_Z_INDEX, UIStyle.varFloat(UIStyle.VAR_Z_INDEX, 0)) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_KNOB_ROTATE, UIStyle.varFloat(UIStyle.VAR_ROTATE, 0)) => float rotate;

        UIUtil.sizeToWorld(UIStyle.varVec2(UIStyle.VAR_KNOB_TICK_SIZE, @(0.04, 0.12))) => vec2 tickSize;
        scale *=> tickSize;
        UIStyle.color(UIStyle.COL_KNOB_TICK, @(0.2, 0.2, 0.2, 1)) => vec4 tickColor;

        if (_disabled) {
            UIStyle.color(UIStyle.COL_KNOB_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_DISABLED, @(0.7, 0.7, 0.7, 1)) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_DISABLED, @(0.7, 0.7, 0.7, 1)) => indicatorColor;
            UIStyle.color(UIStyle.COL_KNOB_TICK_DISABLED, tickColor) => tickColor;
        } else if (_state.pressed()) {
            UIStyle.color(UIStyle.COL_KNOB_PRESSED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_PRESSED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_PRESSED, indicatorColor) => indicatorColor;
            UIStyle.color(UIStyle.COL_KNOB_TICK_PRESSED, tickColor) => tickColor;
        } else if (_state.hovered()) {
            UIStyle.color(UIStyle.COL_KNOB_HOVERED, knobColor) => knobColor;
            UIStyle.color(UIStyle.COL_KNOB_BORDER_HOVERED, knobBorderColor) => knobBorderColor;
            UIStyle.color(UIStyle.COL_KNOB_INDICATOR_HOVERED, indicatorColor) => indicatorColor;
            UIStyle.color(UIStyle.COL_KNOB_TICK_HOVERED, tickColor) => tickColor;
        }

        gKnob.size(knobSize);
        gKnob.color(knobColor);
        gKnob.borderRadius(knobBorderRadius);
        gKnob.borderWidth(knobBorderWidth);
        gKnob.borderColor(knobBorderColor);

        gIndicator.size(indicatorSize);
        gIndicator.color(indicatorColor);
        gIndicator.borderRadius(indicatorSize.x / 2);
        gIndicator.borderWidth(0);

        if (recreateTicks) {
            createTicks();
            snapToNearestStep();
            false => recreateTicks;
        }

        for (0 => int i; i < ticks.size(); i++) {
            ticks[i].size(tickSize);
            ticks[i].color(tickColor);
        }

        applyLayout(knobSize, controlPoints, zIndex, rotate);
    }

    fun void update() {
        _state.update();

        if (!_disabled) {
            if (_state.dragging()) {
                _state.mouseWorld() => vec3 currentMousePos;

                if (_state.clicked()) {
                    currentMousePos => _startMousePos;
                    _val => _startValue;
                } else {
                    currentMousePos - _startMousePos => vec3 deltaPos;
                    drag(deltaPos);
                }
            }
        }

        updateUI();
    }
}