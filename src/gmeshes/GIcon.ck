@import "../lib/Cache.ck"

@doc "Render an icon"
public class GIcon extends GMesh {
    FlatMaterial _mat;
    Texture @ _tex;

    @doc "Default constructor for GIcon."
    fun GIcon() {
        _mat.transparent(true);
        _mat.sampler(TextureSampler.nearest());
        _mat => this.mat;
        new PlaneGeometry() => this.geo;
    }

    @doc "Set the icon to be rendered."
    fun void icon(string path) {
        if (path == "") return;
        IconCache.get(path) @=> Texture tex;
        if (tex == null) {
            TextureLoadDesc desc;
            true => desc.flip_y;
            Texture.load(path, desc) @=> tex;
            IconCache.set(path, tex);
        }
        tex @=> _tex;
        tex => _mat.colorMap;
    }

    @doc "Get the texture width in pixels, or 0 if no texture is loaded."
    fun int texWidth() { return _tex != null ? _tex.width() : 0; }

    @doc "Get the texture height in pixels, or 0 if no texture is loaded."
    fun int texHeight() { return _tex != null ? _tex.height() : 0; }

    @doc "Set the UV offset into the texture."
    fun void uvOffset(vec2 offset) { _mat.offset(offset); }

    @doc "Set the UV scale (region size) of the texture."
    fun void uvScale(vec2 scale) { _mat.scale(scale); }

    @doc "Set the color of the icon."
    fun void color(vec3 c) { _mat.color(c); }
    @doc "Set the color of the icon."
    fun void color(vec4 c) { _mat.color(c); }

    @doc "Set whether the icon is transparent or not."
    fun void transparent(int transparent) { _mat.transparent(transparent); }

    fun void sampler(TextureSampler sampler) { _mat.sampler(sampler); }

    @doc "Set the blend mode of the icon material."
    fun void blend(int mode) { _mat.blend(mode); }
}