public class UIGlobals {
    "NDC" => static string sizeUnits;
    "NDC" => static string posUnits;
    static GGen @ currentPanel;
    static int is3D;

    // 3D hit tracking: closest panel along mouse ray wins interaction
    static float closestHitT;
    static GGen @ closestHitPanel;

    fun static void resetHitTracking() {
        999999.0 => closestHitT;
        null @=> closestHitPanel;
    }
}
