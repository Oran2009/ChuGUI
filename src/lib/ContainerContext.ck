public class ContainerContext {
    vec2 _pos;
    string _layout;
    float _spacing;
    float _padding;
    float _cursor;
    int _childCount;
    float _maxCrossSize;
    float _totalMainSize;

    fun void init(vec2 pos, string layout, float spacing, float padding) {
        pos => _pos;
        layout => _layout;
        spacing => _spacing;
        padding => _padding;
        padding => _cursor;
        0 => _childCount;
        0.0 => _maxCrossSize;
        0.0 => _totalMainSize;
    }

    fun vec2 nextPos() {
        if (_layout == "row") {
            return @(_pos.x + _cursor, _pos.y);
        } else {
            return @(_pos.x + _padding, _pos.y - _cursor);
        }
    }

    fun void advance(vec2 childSize) {
        if (_layout == "row") {
            childSize.x +=> _cursor;
            childSize.x +=> _totalMainSize;
            if (_childCount > 0) _spacing +=> _totalMainSize;
            Math.max(_maxCrossSize, childSize.y) => _maxCrossSize;
        } else {
            childSize.y +=> _cursor;
            childSize.y +=> _totalMainSize;
            if (_childCount > 0) _spacing +=> _totalMainSize;
            Math.max(_maxCrossSize, childSize.x) => _maxCrossSize;
        }
        _childCount++;
        // Add spacing after child size so next child's position includes the gap
        _spacing +=> _cursor;
    }

    fun vec2 totalSize() {
        if (_layout == "row") {
            return @(_totalMainSize + _padding * 2, _maxCrossSize + _padding * 2);
        } else {
            return @(_maxCrossSize + _padding * 2, _totalMainSize + _padding * 2);
        }
    }
}
