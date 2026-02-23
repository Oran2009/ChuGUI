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

    // Convert NDC size to world size on a 3D panel's plane
    fun static vec2 NDCToWorldSize3D(vec2 ndcSize, GGen panel) {
        panel.posWorld() => vec3 panelPos;
        panel.forward() => vec3 normal;
        panel.right() => vec3 right;
        panel.up() => vec3 up;

        // Project origin NDC point onto panel
        GG.camera().NDCToWorldPos(@(0, 0, 0)) => vec3 origNear;
        GG.camera().NDCToWorldPos(@(0, 0, 1)) => vec3 origFar;
        RayUtil.normalize3(@(origFar.x - origNear.x, origFar.y - origNear.y, origFar.z - origNear.z)) => vec3 origDir;
        RayUtil.rayPlaneT(origNear, origDir, panelPos, normal) => float t0;

        // Project offset NDC point onto panel
        GG.camera().NDCToWorldPos(@(ndcSize.x, ndcSize.y, 0)) => vec3 offNear;
        GG.camera().NDCToWorldPos(@(ndcSize.x, ndcSize.y, 1)) => vec3 offFar;
        RayUtil.normalize3(@(offFar.x - offNear.x, offFar.y - offNear.y, offFar.z - offNear.z)) => vec3 offDir;
        RayUtil.rayPlaneT(offNear, offDir, panelPos, normal) => float t1;

        if (t0 < 0 || t1 < 0) return NDCToWorldSize(ndcSize);  // fallback

        @(origNear.x + t0 * origDir.x, origNear.y + t0 * origDir.y, origNear.z + t0 * origDir.z) => vec3 hit0;
        @(offNear.x + t1 * offDir.x, offNear.y + t1 * offDir.y, offNear.z + t1 * offDir.z) => vec3 hit1;

        // Measure distance along panel's local axes
        @(hit1.x - hit0.x, hit1.y - hit0.y, hit1.z - hit0.z) => vec3 diff;
        Math.fabs(RayUtil.dot3(diff, right)) => float w;
        Math.fabs(RayUtil.dot3(diff, up)) => float h;

        return @(w, h);
    }

    // Convert size from current unit system to world coordinates
    // Respects the global sizeUnits() setting
    fun static vec2 sizeToWorld(vec2 size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else if (UIGlobals.is3D && UIGlobals.currentPanel != null) {
            return NDCToWorldSize3D(size, UIGlobals.currentPanel);
        } else {
            return NDCToWorldSize(size);
        }
    }

    // Convert single float size from current unit system to world coordinates
    fun static float sizeToWorld(float size) {
        if (UIGlobals.sizeUnits == "WORLD") {
            return size;
        } else if (UIGlobals.is3D && UIGlobals.currentPanel != null) {
            NDCToWorldSize3D(@(size, size), UIGlobals.currentPanel) => vec2 worldSize;
            return worldSize.x;
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