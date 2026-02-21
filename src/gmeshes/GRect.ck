// GRect.ck
@import "../materials/RectMaterial.ck"

@doc "GPlane with extra customizability."
public class GRect extends GMesh {
    vec2 _size;
    vec4 _color;
    vec4 _borderColor;
    float _borderRadius;
    float _borderWidth;
    float _inputBorderRadius;
    float _inputBorderWidth;
    RectMaterial _mat;
    PlaneGeometry _geo;

    @doc "Default constructor for GRect."
    fun GRect() {
        _mat.init();
       _mat => this.material;
        _geo.build(_size.x, _size.y, 1, 1);
        _geo => this.geo;
    }

    // ---- Getters and Setters ----

    @doc "Get the border radius (world-space value)."
    fun float borderRadius() { return _borderRadius; }
    @doc "Set the border radius (0..1 fraction of half the min dimension)."
    fun void borderRadius(float radius) {
        if (radius != radius) return; // NaN guard
        Math.clampf(radius, 0, 1) => radius;
        if (radius == _inputBorderRadius) return;
        radius => _inputBorderRadius;
        radius * Math.min(_size.x, _size.y) * 0.5 => _borderRadius;
        _mat.borderRadius(_borderRadius);
    }

    @doc "Get the border width (world-space value)."
    fun float borderWidth() { return _borderWidth; }
    @doc "Set the border width (0..1 fraction of half the min dimension)."
    fun void borderWidth(float borderWidth) {
        if (borderWidth != borderWidth) return; // NaN guard
        Math.clampf(borderWidth, 0, 1) => borderWidth;
        if (borderWidth == _inputBorderWidth) return;
        borderWidth => _inputBorderWidth;
        borderWidth * Math.min(_size.x, _size.y) * 0.5 => _borderWidth;
        _mat.borderWidth(_borderWidth);
    }

    @doc "Get the size."
    fun vec2 size() { return _size; }
    @doc "Set the size."
    fun void size(vec2 size) {
        if (size.x == _size.x && size.y == _size.y) return;
        size => _size;
        _mat.size(size);
        _geo.build(_size.x, _size.y, 1, 1);
        // Rescale borderRadius and borderWidth for new size
        _inputBorderRadius * Math.min(_size.x, _size.y) * 0.5 => _borderRadius;
        _mat.borderRadius(_borderRadius);
        _inputBorderWidth * Math.min(_size.x, _size.y) * 0.5 => _borderWidth;
        _mat.borderWidth(_borderWidth);
    }

    @doc "Get the color."
    fun vec4 color() { return _color; }
    @doc "Set the color."
    fun void color(vec4 c) {
        if (c.x == _color.x && c.y == _color.y && c.z == _color.z && c.w == _color.w) return;
        c => _color;
        _mat.color(c);
    }

    @doc "Get the border color."
    fun vec4 borderColor() { return _borderColor; }
    @doc "Set the border color."
    fun void borderColor(vec4 borderColor) {
        if (borderColor.x == _borderColor.x && borderColor.y == _borderColor.y && borderColor.z == _borderColor.z && borderColor.w == _borderColor.w) return;
        borderColor => _borderColor;
        _mat.borderColor(borderColor);
    }

    @doc "Set whether the rect is transparent or not."
    fun void transparent(int transparent) { _mat.transparent(transparent); }
}
