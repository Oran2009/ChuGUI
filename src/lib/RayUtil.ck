public class RayUtil {
    // ==== Vector Helpers ====

    // Dot product of two vec3 values
    fun static float dot3(vec3 a, vec3 b) {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    // Normalize a vec3 to unit length
    fun static vec3 normalize3(vec3 v) {
        Math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z) => float len;
        if (len < 0.000001) return @(0, 0, 0);
        return @(v.x / len, v.y / len, v.z / len);
    }

    // ==== Ray Construction ====

    // Returns the ray origin (near plane world position) for the current mouse pixel.
    // Note: samples GWindow.mousePos() independently from mouseRayDir().
    // Callers needing both should be aware they may sample at different times.
    fun static vec3 mouseRayOrigin() {
        return GG.scene().camera().screenCoordToWorldPos(GWindow.mousePos(), 0);
    }

    // Returns the normalized ray direction from the camera through the current mouse pixel.
    fun static vec3 mouseRayDir() {
        GWindow.mousePos() => vec2 mp;
        GG.scene().camera().screenCoordToWorldPos(mp, 0) => vec3 near;
        GG.scene().camera().screenCoordToWorldPos(mp, 1) => vec3 far;
        return normalize3(@(far.x - near.x, far.y - near.y, far.z - near.z));
    }

    // ==== Ray-Plane Intersection ====

    // Ray-plane intersection. Returns the t parameter (distance along ray).
    // Negative t means no hit (behind camera or ray parallel to plane).
    fun static float rayPlaneT(vec3 rayOrigin, vec3 rayDir, vec3 planePoint, vec3 planeNormal) {
        dot3(rayDir, planeNormal) => float denom;

        // Ray is parallel to plane (or nearly so)
        if (Math.fabs(denom) < 0.000001) return -1.0;

        // t = dot(planePoint - rayOrigin, planeNormal) / denom
        @(planePoint.x - rayOrigin.x,
          planePoint.y - rayOrigin.y,
          planePoint.z - rayOrigin.z) => vec3 diff;
        dot3(diff, planeNormal) / denom => float t;

        // Negative t means intersection is behind the ray origin
        if (t < 0.0) return -1.0;

        return t;
    }

    // ==== Coordinate Projection ====

    // Convert a world-space hit point to panel-local 2D coordinates
    // by projecting onto the panel's right and up axes.
    fun static vec2 worldToLocal2D(vec3 hitPoint, vec3 panelPos, vec3 right, vec3 up) {
        @(hitPoint.x - panelPos.x,
          hitPoint.y - panelPos.y,
          hitPoint.z - panelPos.z) => vec3 diff;

        dot3(diff, right) => float localX;
        dot3(diff, up) => float localY;

        return @(localX, localY);
    }
}
