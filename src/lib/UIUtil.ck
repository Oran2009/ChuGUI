@import "../gmeshes/GRect.ck"
@import "UIGlobals.ck"
@import "RayUtil.ck"

public class UIUtil {
    // ==== Unit Conversion ====

    // Convert NDC size to world size
    fun static vec2 NDCToWorldSize(vec2 ndcSize) {
        GG.camera().NDCToWorldPos(@(ndcSize.x, ndcSize.y, 0)) => vec3 worldPos;
        GG.camera().NDCToWorldPos(@(0, 0, 0)) => vec3 origin;
        return @(Math.fabs(worldPos.x - origin.x), Math.fabs(worldPos.y - origin.y));
    }

    // Convert world size to NDC size
    fun static vec2 worldToNDCSize(vec2 worldSize) {
        GG.camera().worldPosToNDC(@(worldSize.x, worldSize.y, 0)) => vec3 ndcPos;
        GG.camera().worldPosToNDC(@(0, 0, 0)) => vec3 origin;
        return @(Math.fabs(ndcPos.x - origin.x), Math.fabs(ndcPos.y - origin.y));
    }

    // Convert size from current unit system to world coordinates
    // Respects the global sizeUnits() setting
    fun static vec2 sizeToWorld(vec2 size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else {
            return NDCToWorldSize(size);
        }
    }

    // Convert single float size from current unit system to world coordinates
    fun static float sizeToWorld(float size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else {
            NDCToWorldSize(@(size, size)) => vec2 worldSize;
            return worldSize.x;
        }
    }

    // Convert position from current unit system to world coordinates
    // Respects the global posUnits() setting
    fun static vec2 posToWorld(vec2 pos) {
        if (UIGlobals.posUnits == "WORLD") {
            return pos;
        } else {
            GG.camera().NDCToWorldPos(@(pos.x, pos.y, 0)) => vec3 worldPos;
            return @(worldPos.x, worldPos.y);
        }
    }

    // ==== Collision Detection ====

    fun static int hovered(GGen ggen, GRect gRect) {
        // Dispatch to 3D hit testing when panel is in 3D mode
        if (UIGlobals.is3D && UIGlobals.currentPanel != null) {
            return hovered3D(UIGlobals.currentPanel, ggen, gRect);
        }

        // Original 2D hit testing (flat mode)
        GG.camera().screenCoordToWorldPos(GWindow.mousePos(), 1) => vec3 mouseWorld;

        ggen.posWorld().x => float cx;
        ggen.posWorld().y => float cy;
        mouseWorld.x - cx => float dx;
        mouseWorld.y - cy => float dy;

        // account for rotation
        ggen.rotZ() => float angle;
        Math.cos(angle) => float c;
        Math.sin(angle) => float s;
        (dx * c + dy * s) => float localX;
        (-dx * s + dy * c) => float localY;

        gRect.size().x / 2.0 => float halfW;
        gRect.size().y / 2.0 => float halfH;

        gRect.pos().x => float rectLocalX;
        gRect.pos().y => float rectLocalY;

        localX - rectLocalX => float relX;
        localY - rectLocalY => float relY;

        if (relX < -halfW || relX > halfW || relY < -halfH || relY > halfH) {
            return 0;
        }

        gRect.borderRadius() => float cornerR;
        if (Math.fabs(relX) <= (halfW - cornerR) || Math.fabs(relY) <= (halfH - cornerR)) {
            return 1;
        }

        (relX > 0 ? halfW - cornerR : -halfW + cornerR) => float cx2;
        (relY > 0 ? halfH - cornerR : -halfH + cornerR) => float cy2;

        relX - cx2 => float dx2;
        relY - cy2 => float dy2;

        return (dx2 * dx2 + dy2 * dy2 <= cornerR * cornerR) ? 1 : 0;
    }

    // 3D hit testing via ray-plane intersection
    fun static int hovered3D(GGen panel, GGen ggen, GRect gRect) {
        // Get panel's world-space plane using GGen direction vectors
        panel.posWorld() => vec3 panelPos;
        panel.forward() => vec3 normal;  // panel's local Z = plane normal
        panel.right() => vec3 right;
        panel.up() => vec3 up;

        // Construct mouse ray
        RayUtil.mouseRayOrigin() => vec3 rayOrigin;
        RayUtil.mouseRayDir() => vec3 rayDir;

        // Ray-plane intersection
        RayUtil.rayPlaneT(rayOrigin, rayDir, panelPos, normal) => float t;
        if (t < 0) return 0;  // behind camera or parallel

        // Hit point in world space
        @(rayOrigin.x + t * rayDir.x,
          rayOrigin.y + t * rayDir.y,
          rayOrigin.z + t * rayDir.z) => vec3 hitWorld;

        // Convert to panel-local 2D
        RayUtil.worldToLocal2D(hitWorld, panelPos, right, up) => vec2 hitLocal;

        // Component position in panel-local space
        RayUtil.worldToLocal2D(ggen.posWorld(), panelPos, right, up) => vec2 ggenLocal;

        hitLocal.x - ggenLocal.x => float dx;
        hitLocal.y - ggenLocal.y => float dy;

        // Account for component's local rotation relative to panel
        ggen.rotZ() - panel.rotZ() => float angle;
        Math.cos(angle) => float c;
        Math.sin(angle) => float s;
        (dx * c + dy * s) => float localX;
        (-dx * s + dy * c) => float localY;

        // Standard AABB + corner radius check (same as flat mode)
        gRect.size().x / 2.0 => float halfW;
        gRect.size().y / 2.0 => float halfH;

        gRect.pos().x => float rectLocalX;
        gRect.pos().y => float rectLocalY;

        localX - rectLocalX => float relX;
        localY - rectLocalY => float relY;

        if (relX < -halfW || relX > halfW || relY < -halfH || relY > halfH) {
            return 0;
        }

        gRect.borderRadius() => float cornerR;
        if (Math.fabs(relX) <= (halfW - cornerR) || Math.fabs(relY) <= (halfH - cornerR)) {
            return 1;
        }

        (relX > 0 ? halfW - cornerR : -halfW + cornerR) => float cx2;
        (relY > 0 ? halfH - cornerR : -halfH + cornerR) => float cy2;

        relX - cx2 => float dx2;
        relY - cy2 => float dy2;

        return (dx2 * dx2 + dy2 * dy2 <= cornerR * cornerR) ? 1 : 0;
    }
}