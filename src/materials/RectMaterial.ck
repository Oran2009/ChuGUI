// Based on the GLSL code here: https://jsfiddle.net/felixmariotto/ozds3yxa/16/
public class RectMaterial extends Material {
    float _borderRadius, _borderWidth;
    vec2 _size;
    vec4 _color, _borderColor;
    vec2 _lightDir;
    float _bevelStrength;
    vec2 _shadowOffset;
    float _shadowBlur;
    vec4 _shadowColor;
    float _innerShadowWidth;
    vec2 _padding;

    // ---- Getters and Setters ----

    fun float borderRadius() { return _borderRadius; }
    fun void borderRadius(float r) { r => _borderRadius; update(); }

    fun float borderWidth() { return _borderWidth; }
    fun void borderWidth(float borderWidth) { borderWidth => _borderWidth; update(); }

    fun vec2 size() { return _size; }
    fun void size(vec2 s) { s => _size; update(); }
    
    fun vec4 color() { return _color; }
    fun void color(vec4 c) { c => _color; update(); }
    
    fun vec4 borderColor() { return _borderColor; }
    fun void borderColor(vec4 borderColor) { borderColor => _borderColor; update(); }

    fun vec2 lightDir() { return _lightDir; }
    fun void lightDir(vec2 v) { v => _lightDir; update(); }

    fun float bevelStrength() { return _bevelStrength; }
    fun void bevelStrength(float v) { v => _bevelStrength; update(); }

    fun vec2 shadowOffset() { return _shadowOffset; }
    fun void shadowOffset(vec2 v) { v => _shadowOffset; update(); }

    fun float shadowBlur() { return _shadowBlur; }
    fun void shadowBlur(float v) { v => _shadowBlur; update(); }

    fun vec4 shadowColor() { return _shadowColor; }
    fun void shadowColor(vec4 v) { v => _shadowColor; update(); }

    fun float innerShadowWidth() { return _innerShadowWidth; }
    fun void innerShadowWidth(float v) { v => _innerShadowWidth; update(); }

    fun vec2 padding() { return _padding; }
    fun void padding(vec2 v) { v => _padding; update(); }

    // ---- WGSL Functions ----

    fun void init() {
        // WGSL vertex shader
        "
            #include FRAME_UNIFORMS
            #include DRAW_UNIFORMS
            #include STANDARD_VERTEX_INPUT

            struct VertexOutput {
                @builtin(position) position : vec4<f32>,
                @location(0) v_uv : vec2<f32>,
            };

            @vertex 
            fn vs_main(in : VertexInput) -> VertexOutput {
                var out : VertexOutput;
                let u_draw : DrawUniforms = u_draw_instances[in.instance];
                
                out.v_uv = in.uv;
                out.position = (u_frame.projection * u_frame.view * u_draw.model) * vec4<f32>(in.position, 1.0);
                
                return out;
            }
        " => string vert;

        // WGSL fragment shader
        "
            #include FRAME_UNIFORMS
            #include DRAW_UNIFORMS

            struct FragmentInput {
                @location(0) v_uv : vec2<f32>,
            };

            @group(1) @binding(0) var<uniform> u_borderRadius : f32;
            @group(1) @binding(1) var<uniform> u_borderWidth : f32;
            @group(1) @binding(2) var<uniform> u_size : vec2<f32>;
            @group(1) @binding(3) var<uniform> u_color : vec4<f32>;
            @group(1) @binding(4) var<uniform> u_borderColor : vec4<f32>;
            @group(1) @binding(5) var<uniform> u_lightDir : vec2<f32>;
            @group(1) @binding(6) var<uniform> u_bevelStrength : f32;
            @group(1) @binding(7) var<uniform> u_shadowOffset : vec2<f32>;
            @group(1) @binding(8) var<uniform> u_shadowBlur : f32;
            @group(1) @binding(9) var<uniform> u_shadowColor : vec4<f32>;
            @group(1) @binding(10) var<uniform> u_innerShadowWidth : f32;
            @group(1) @binding(11) var<uniform> u_padding : vec2<f32>;

            fn sdRoundedBox(p: vec2<f32>, b: vec2<f32>, r: f32) -> f32 {
                let q = abs(p) - b + vec2<f32>(r);
                return length(max(q, vec2<f32>(0.0))) + min(max(q.x, q.y), 0.0) - r;
            }

            fn getEdgeDist(uv: vec2<f32>) -> f32 {
                let totalSize = u_size + 2.0 * u_padding;
                let p = (uv * 2.0 - 1.0) * totalSize * 0.5;
                return sdRoundedBox(p, u_size * 0.5, u_borderRadius);
            }

            @fragment
            fn fs_main(in : FragmentInput) -> @location(0) vec4<f32> {
                let edgeDist = getEdgeDist(in.v_uv);

                // Drop shadow (rendered behind main shape)
                var shadowAlpha = 0.0;
                if (u_shadowBlur > 0.0 || (u_shadowOffset.x != 0.0 || u_shadowOffset.y != 0.0)) {
                    let shadowUV = in.v_uv - u_shadowOffset / (u_size + 2.0 * u_padding);
                    let shadowDist = getEdgeDist(shadowUV);
                    shadowAlpha = smoothstep(u_shadowBlur, 0.0, shadowDist) * u_shadowColor.a;
                }

                // Outside the rect
                if (edgeDist > 0.0) {
                    if (shadowAlpha > 0.0) {
                        return vec4<f32>(u_shadowColor.rgb, shadowAlpha);
                    }
                    discard;
                }

                // Base color (border vs fill)
                var finalColor = u_color;
                if (edgeDist * -1.0 < u_borderWidth) {
                    finalColor = u_borderColor;
                }

                // Bevel effect — sample SDF at offsets for smooth gradient,
                // restrict to edge band to avoid interior crease artifacts
                if (u_bevelStrength != 0.0 && length(u_lightDir) > 0.001) {
                    let eps = 1.0 / 256.0;
                    let dx = getEdgeDist(in.v_uv + vec2<f32>(eps, 0.0)) - getEdgeDist(in.v_uv - vec2<f32>(eps, 0.0));
                    let dy = getEdgeDist(in.v_uv + vec2<f32>(0.0, eps)) - getEdgeDist(in.v_uv - vec2<f32>(0.0, eps));
                    let gradLen = sqrt(dx * dx + dy * dy);
                    if (gradLen > 0.001) {
                        let gradient = vec2<f32>(dx, dy) / gradLen;
                        let lighting = dot(gradient, normalize(u_lightDir)) * u_bevelStrength;
                        // Fade bevel from full at edge to zero inside
                        let bevelWidth = max(u_borderRadius, min(u_size.x, u_size.y) * 0.15);
                        let bevelMask = 1.0 - smoothstep(0.0, bevelWidth, -edgeDist);
                        let adjusted = lighting * bevelMask;
                        finalColor = vec4<f32>(
                            clamp(finalColor.r + adjusted, 0.0, 1.0),
                            clamp(finalColor.g + adjusted, 0.0, 1.0),
                            clamp(finalColor.b + adjusted, 0.0, 1.0),
                            finalColor.a
                        );
                    }
                }

                // Inner shadow — darken near edges, not to pure black
                if (u_innerShadowWidth > 0.0) {
                    let innerFactor = smoothstep(0.0, u_innerShadowWidth, -edgeDist);
                    let shadowDarken = mix(0.4, 1.0, innerFactor);
                    finalColor = vec4<f32>(
                        finalColor.rgb * shadowDarken,
                        finalColor.a
                    );
                }

                return finalColor;
            }
        " => string frag;

        ShaderDesc desc;
        vert => desc.vertexCode;
        frag => desc.fragmentCode;
        0 => desc.lit;

        new Shader(desc) => shader;

        update();
    }

    fun void update() {
        uniformFloat(0, _borderRadius);
        uniformFloat(1, _borderWidth);
        uniformFloat2(2, _size);
        uniformFloat4(3, _color);
        uniformFloat4(4, _borderColor);
        uniformFloat2(5, _lightDir);
        uniformFloat(6, _bevelStrength);
        uniformFloat2(7, _shadowOffset);
        uniformFloat(8, _shadowBlur);
        uniformFloat4(9, _shadowColor);
        uniformFloat(10, _innerShadowWidth);
        uniformFloat2(11, _padding);
    }
}