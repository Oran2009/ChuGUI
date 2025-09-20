@import "../lib/Util.ck"
@import "../lib/MouseState.ck"
@import "../lib/GComponent.ck"
@import "../UIStyle.ck"
@import "../components/Slider.ck"

public class ColorPicker extends GComponent {
    GRect gPreviewRect --> this;
    Slider hueSlider --> this;
    Slider satSlider --> this;
    Slider valSlider --> this;
    GText hueLabel --> this;
    GText satLabel --> this;
    GText valLabel --> this;

    0 => float hue;        // 0..360
    1 => float saturation; // 0..1
    1 => float value;      // 0..1

    fun ColorPicker() {
        hueSlider.min(0);
        hueSlider.max(360);
        hueSlider.val(hue);

        satSlider.min(0);
        satSlider.max(1);
        satSlider.val(saturation);

        valSlider.min(0);
        valSlider.max(1);
        valSlider.val(value);

        hueLabel.text("H");
        satLabel.text("S");
        valLabel.text("V");
    }

    // ==== Getters and Setters ====

    fun void disabled(int disabled) {
        disabled => _disabled;
        if(hueSlider != null) hueSlider.disabled(disabled);
        if(satSlider != null) satSlider.disabled(disabled);
        if(valSlider != null) valSlider.disabled(disabled);
    }

    fun void color(vec3 rgb) {
        Color.rgb2hsv(rgb) => vec3 hsv;
        hsv.x => hue;
        hsv.y => saturation;
        hsv.z => value;
        updateUI();
    }
    fun vec3 color() {
        Color.hsv2rgb(@(hue, saturation, value)) => vec3 rgb;
        return @(rgb.x, rgb.y, rgb.z);
    }

    // ==== Update ====

    fun void updateUI() {
        UIStyle.varVec2(UIStyle.VAR_COLOR_PICKER_SIZE, @(2.0, 1.0)) => vec2 pickerSize;
        UIStyle.varVec2(UIStyle.VAR_COLOR_PICKER_CONTROL_POINTS, @(0.5, 0.5)) => vec2 controlPoints;

        pickerSize.x * 0.3 => float previewWidth;
        pickerSize.x * 0.7 => float sliderWidth;
        pickerSize.y / 3.0 => float sliderHeightSpacing;

        0.25 * pickerSize.x => float spacing;
        previewWidth + spacing + sliderWidth => float totalWidth;
        -totalWidth / 2 => float leftEdge;
        leftEdge + previewWidth / 2 => float previewX;
        leftEdge + previewWidth + spacing + sliderWidth / 2 => float sliderX;

        gPreviewRect.pos(@(previewX, 0, 0));
        gPreviewRect.size(@(previewWidth, pickerSize.y));
        gPreviewRect.borderRadius(0.1);
        gPreviewRect.borderWidth(0.1);

        pickerSize.y * 0.15 => float sliderTrackHeight;

        sliderTrackHeight * 1.5 => float sliderHandleSize;

        @(sliderWidth, sliderTrackHeight) => vec2 trackSize;
        @(sliderHandleSize, sliderHandleSize) => vec2 handleSize;

        hueSlider.pos(@(sliderX, sliderHeightSpacing, 0));
        hueSlider.gTrack.size(trackSize);
        hueSlider.gHandle.size(handleSize);

        satSlider.pos(@(sliderX, 0, 0));
        satSlider.gTrack.size(trackSize);
        satSlider.gHandle.size(handleSize);
        
        valSlider.pos(@(sliderX, -sliderHeightSpacing, 0));
        valSlider.gTrack.size(trackSize);
        valSlider.gHandle.size(handleSize);

        // Labels
        sliderTrackHeight * 1.0 => float letterSize;
        UIStyle.color(UIStyle.COL_COLOR_PICKER_LABEL, @(0,0,0,1)) => vec4 letterColor;

        previewX + previewWidth / 2 => float previewRightX;
        sliderX - sliderWidth / 2 - handleSize.x / 2 => float sliderTrackLeftX;

        (previewRightX + sliderTrackLeftX) / 2 => float labelX;

        hueLabel.color(letterColor);
        hueLabel.sca(letterSize);
        hueLabel.pos(@(labelX, sliderHeightSpacing, 0));

        satLabel.color(letterColor);
        satLabel.sca(letterSize);
        satLabel.pos(@(labelX, 0, 0));

        valLabel.color(letterColor);
        valLabel.sca(letterSize);
        valLabel.pos(@(labelX, -sliderHeightSpacing, 0));

        // Slider colors
        Color.hsv2rgb(@(hue, saturation, value)) => vec3 rgb;
        gPreviewRect.color(@(rgb.x, rgb.y, rgb.z, 1));

        Color.hsv2rgb(@(hue, 1, 1)) => vec3 hueColor;
        hueSlider.gTrack.color(@(hueColor.x, hueColor.y, hueColor.z, 1));
        hueSlider.updatePosition();

        Color.hsv2rgb(@(hue, 0, value)) => vec3 satStart;
        Color.hsv2rgb(@(hue, 1, value)) => vec3 satEnd;
        satSlider.gTrack.color(@((satStart.x + satEnd.x)*0.5, (satStart.y + satEnd.y)*0.5, (satStart.z + satEnd.z)*0.5, 1));
        satSlider.updatePosition();

        @(0,0,0) => vec3 valStart;
        Color.hsv2rgb(@(hue, saturation, 1)) => vec3 valEnd;
        valSlider.gTrack.color(@((valStart.x + valEnd.x)*0.5, (valStart.y + valEnd.y)*0.5, (valStart.z + valEnd.z)*0.5, 1));
        valSlider.updatePosition();

        hueSlider.val(hue);
        satSlider.val(saturation);
        valSlider.val(value);

        UIStyle.varFloat(UIStyle.VAR_COLOR_PICKER_Z_INDEX, 0.0) => float zIndex;
        UIStyle.varFloat(UIStyle.VAR_COLOR_PICKER_ROTATE, 0.0) => float rotate;


        (totalWidth + sliderHandleSize) * (0.5 - controlPoints.x) => float offsetX;
        pickerSize.y * (0.5 - controlPoints.y) => float offsetY;

        this.posX(_pos.x + offsetX);
        this.posY(_pos.y + offsetY);
        this.posZ(zIndex);
        gPreviewRect.rotX(rotate);
        hueSlider.rotX(rotate);
        satSlider.rotX(rotate);
        valSlider.rotX(rotate);
    }

    fun void update() {
        // Update sliders and get new values
        hueSlider.update();
        hueSlider.val() => hue;

        satSlider.update();
        satSlider.val() => saturation;

        valSlider.update();
        valSlider.val() => value;

        updateUI();
    }
}
