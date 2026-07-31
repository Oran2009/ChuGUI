# ChuGUI v0.2.0 Codebase Audit

## I. Confirmed Bugs (ALL FIXED in v0.2.0)

### 1. CursorState.update() called O(N^2) per frame -- FIXED
CursorState.update() is now a no-op. MouseState.update() only registers as active via CursorState.registerActive().

### 2. Checkbox icon detach/reattach every frame -- FIXED
Now uses conditional check: only attach/detach when checked state actually changes.

### 3. Knob & Slider divide-by-zero when min == max -- FIXED
Both now guard with `(_max != _min) ? ... : 0.0`.

### 4. Input cursor blink divides by GG.fps() directly -- FIXED
Now uses `(fps > 0) ? fps : 60.0` guard.

### 5. Input.frameCount is static and shared across instances -- FIXED
Changed from `static int frameCount` to instance variable `int frameCount`.

### 6. ColorPicker uses rotX instead of rotZ -- FIXED
Sub-components no longer apply individual rotation; the whole ColorPicker uses `applyLayout()` with `rotZ`.

### 7. Dropdown has no click-outside-to-close behavior -- FIXED
Clicking outside the field and items now closes the dropdown.

### 8. Meter divide-by-zero in fill border radius -- FIXED
`fillRadAbs / Math.min(fillW, innerH)` produced Infinity/NaN when meter value near minimum. Now uses `Math.max(0.001, ...)` guard.

### 9. Input cursor re-attaches/detaches every blink frame -- FIXED
Same pattern as old Checkbox bug (#2). Now uses conditional `if (gCursor.parent() == null)` before attaching.

### 10. Input key repeat state stale across focus cycles -- FIXED
`lastKey` and `frameCount` now reset when focus is lost, preventing burst of key repeats on refocus.

### 11. Spinner missing min()/max() getters -- FIXED
Added getter methods. debugScenegraph no longer accesses private `_min`/`_max` fields.

### 12. GComponent disabled() null-pointer on uninitialized _state -- FIXED
Base class `_state` is never initialized; `disabled()` now guards with null check.

---

## II. Performance Concerns

### 1. Style stack clearing allocates arrays every frame -- FIXED
**File:** `ChuGUI.ck`
`cleanupAndResetMap()` now reuses a single scratch array `_mapKeys` for all 12 map traversals. No per-frame allocation.

### 2. Collision detection recomputed per-component per-frame -- PARTIALLY FIXED
Mouse world position is now cached once per frame via `UIUtil.cacheMousePos()`, eliminating repeated `screenCoordToWorldPos` calls. Per-component trig for rotation remains (necessary for rotated components).

### 3. Dropdown item attachment/detachment every frame when open -- FIXED
Now checks `if (r.parent() == null) r --> this;` before attaching.

### 4. No dirty-flag pattern for component properties
All components reapply all styles unconditionally every frame even if nothing changed. A dirty flag on style changes could skip redundant GPU state updates. This is an inherent design choice of immediate-mode GUI -- acceptable for current component counts.

---

## III. Code Quality Issues

### Magic numbers not exposed to styling system
**Status: FIXED** -- All values now exposed as style variables:
- `UIStyle.VAR_BUTTON_ICON_SPACING` (default 0.2)
- `UIStyle.VAR_INPUT_CHAR_WIDTH_RATIO` (default 0.6)
- `UIStyle.VAR_INPUT_TEXT_PADDING` (default 0.05)
- `UIStyle.VAR_INPUT_KEY_REPEAT_DELAY` (default 20)
- `UIStyle.VAR_INPUT_KEY_REPEAT_RATE` (default 5)
- `UIStyle.VAR_KNOB_INDICATOR_RADIUS` (default 0.35)
- `UIStyle.VAR_COLOR_PICKER_PREVIEW_RATIO` (default 0.3)

### Duplicated state-color pattern
The disabled/pressed/hovered color selection pattern is repeated in 7+ components. Each component has different state semantics (pressed vs toggled vs focused vs open) and different numbers of colors, making extraction complex without generics. Accepted as-is for readability.

### Button/Input text width estimation
`textSize * label.length() * 0.5` (Button.ck) and `textSize * charWidthRatio` (Input.ck) assume monospace fonts. Requires font metrics API from ChuGL to fix properly. Character width ratio is now configurable via `UIStyle.VAR_INPUT_CHAR_WIDTH_RATIO`.

### isDebugging() is O(N) linear scan
**Status: FIXED** -- Debug.isDebugging() now uses an `int _debugMap[0]` associative array for O(1) lookup. The `add()` duplicate check also uses the same map.

---

## IV. Feature Requests

### High Value
- ~~**Auto-layout / containers** -- vertical/horizontal stacking, padding, margins~~ **DONE** (beginColumn/endColumn, beginRow/endRow, nested containers)
- ~~**Input: copy/paste support** (Ctrl+C/V)~~ **BLOCKED** (ChuGL does not expose clipboard API)
- ~~**Input: text selection/highlighting**~~ **BLOCKED** (GText has no text measurement or substring coloring API)
- ~~**Tooltip component** -- show text on hover~~ **DONE** (gui.tooltip("text") with configurable delay, styling, z-index)
- ~~**Scrollable container / list view**~~ **BLOCKED** (ChuGL lacks scissor/clip rect API, scroll wheel input, and relative positioning — partial workaround possible but GText can't be clipped)

### Medium Value
- **Keyboard navigation / focus system** -- Tab between fields, Enter/Escape
- **Dropdown: search/filter** for long option lists
- ~~**Slider: click-on-track to jump**~~ **DONE** (second MouseState on track, works for both Slider and DiscreteSlider)
- ~~**Knob: value snapping / step mode**~~ **DONE** (DiscreteKnob component with steps, ticks, snap)
- **Multi-line text input / text area**
- **Progress bar with label** (Meter + text overlay)
- ~~**Separator / spacer component**~~ **DONE** (Separator pooled component + spacer() utility)
- **Modal / dialog / popup component**

### Nice to Have
- **Theming presets** -- light/dark/custom with one call
- ~~**Animation / easing system** -- smooth state transitions~~ **DEFERRED** (requires per-component boilerplate for every animated component; snap transitions are acceptable for immediate-mode GUI)
- **Responsive sizing** -- adapt to window resize
- ~~**IconCache eviction** -- currently grows unbounded~~ **DONE** (FIFO eviction with MAX_SIZE=256, configurable)
- **Number input component** -- numeric Input with validation

---

## V. What 3D ChuGUI Could Look Like

ChuGL provides a full 3D scene graph (GGen, GScene, GCamera, GLight), mesh support, and WebGPU rendering. A 3D ChuGUI could take several forms:

### Billboard Panels (most practical)
2D panels floating in 3D space that always face the camera. The current GRect SDF shader works on planes -- attaching ChuGUI to a GGen positioned in world space gives "floating HUDs." Main work: ray-plane intersection for interaction.

### Diegetic UI (in-world controls)
Controls physically embedded in the 3D scene -- knobs on a virtual mixing board, sliders on a rack, buttons on an instrument panel. Compelling for ChucK's audio-visual use case.

### Spatial Audio Mixer (dream application)
A 3D mixing board where each audio channel is a physical column with knobs, faders, and meters. Channels spatially arranged in 3D. ChuGL's real-time audio-visual pipeline makes this uniquely possible.

### Architectural Requirements

| 2D (current) | 3D equivalent |
|---|---|
| `GRect` (SDF plane) | `GCube`, `GCylinder`, custom meshes |
| `UIUtil.hovered()` (2D AABB) | Ray-mesh intersection |
| `screenCoordToWorldPos` | `camera.screenToRay()` + intersection |
| `posX/posY` layout | Full 3D transform + constraints |
| `rotZ` rotation | Quaternion rotation |
| `gText` (screen-space) | `GText` on 3D planes or billboard text |
| NDC/WORLD units | World units only |

### What Becomes Possible in 3D
- Spatial parameter mapping -- XYZ position maps to three audio parameters
- Depth-based grouping -- near controls for active tracks, far for background
- 3D visualizers with embedded controls
- Multi-user / multi-angle views for installations
- Physical metaphors -- patch cables, rotary switches, realistic toggles

### Practical Starting Point
A `GUIPanel` class wrapping the existing 2D system onto a 3D-positioned plane. Gives 90% of the value with minimal rework. True 3D widgets could come later as components implementing a `GComponent3D` base class with ray-based interaction.
