@doc "Render an icon from Phosphor's icon library: https://phosphoricons.com/"
public class GIcon extends GMesh {
    me.dir() + "../assets/icons/" => string _iconsPath;
    FlatMaterial _mat;

    @doc "Default constructor for GIcon."
    fun GIcon() {
        true => _mat.transparent;
        _mat => this.mat;
        new PlaneGeometry() => this.geo;
    }

    @doc "Set the icon to be rendered."
    fun void icon(string name) {
        _iconsPath + name + ".png" => string path;
        TextureLoadDesc desc;
        true => desc.flip_y;
        Texture.load(path, desc) => _mat.colorMap;
    }

    @doc "Set the color of the icon."
    fun void color(vec3 c) { _mat.color(c); }
    @doc "Set the color of the icon."
    fun void color(vec4 c) { _mat.color(c); }
}