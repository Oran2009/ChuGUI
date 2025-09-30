@import "../lib/Cache.ck"

@doc "Render an icon"
public class GIcon extends GMesh {
    FlatMaterial _mat;

    @doc "Default constructor for GIcon."
    fun GIcon() {
        true => _mat.transparent;
        _mat => this.mat;
        new PlaneGeometry() => this.geo;
    }

    @doc "Set the icon to be rendered."
    fun void icon(string path) {
        IconCache.get(path) @=> Texture tex;
        if (tex == null) {
            TextureLoadDesc desc;
            true => desc.flip_y;
            Texture.load(path, desc) @=> tex;
            IconCache.set(path, tex);
        }
        tex => _mat.colorMap;
    }

    @doc "Set the color of the icon."
    fun void color(vec3 c) { _mat.color(c); }
    @doc "Set the color of the icon."
    fun void color(vec4 c) { _mat.color(c); }
}