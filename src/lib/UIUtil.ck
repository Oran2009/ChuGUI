@import "../gmeshes/GRect.ck"

public class UIUtil {
    fun static int hovered(GGen ggen, GRect gRect) {
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
}