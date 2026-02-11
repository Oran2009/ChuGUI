//-----------------------------------------------------------------------------
// name: hud.ck
// desc: this example builds a HUD from ChuGUI components
//
// author: Ben Hoang (https://ccrma.stanford.edu/~hoangben/)
//-----------------------------------------------------------------------------

@import "../../ChuGUI.ck"

GG.camera().orthographic();
GG.scene().backgroundColor(@(0.5, 0.5, 0.5));

ChuGUI gui --> GG.scene();
gui.sizeUnits(ChuGUI.WORLD);

// --- Data ---

"Mythrax" => string playerName;
"Undead Warrior" => string playerClass;
41 => int playerLevel;
2504 => float health;
1802 => float mana;
3000 => int maxHealth;
3000 => int maxMana;
300 => int manaCost;
["hand-fist", "sword", "fire", "cloud-lightning", "tornado", "paw-print",
 "heartbeat", "syringe", "bed"] @=> string actionIcons[];

float cooldowns[actionIcons.size()];

["Who Needs Cauldrons?", "Foes Before Hoes", "Yetimus the Yeti Lord",
 "The Battle for Andorhal", "Infernus", "Revantusk Village",
 "Preserving the Barrens", "Enemies Below"] @=> string quests[];

string chatMessage;
["user1: Greetings!", "user2: Hello", "user1: What's up?",
 "user2: Just chuglin'"] @=> string chatLog[];

0.05 => float pad;

while (true) {
    GG.nextFrame() => now;

    1 +=> mana;
    Math.clampf(mana, 0, maxMana) => mana;

    // --- Player Info + Meters (top-left column) ---

    UIStyle.pushVar(UIStyle.VAR_CONTAINER_SPACING, 0.025);
    gui.beginColumn(@(-1 + pad, 1 - pad));

        UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.28);
        gui.label(playerName);
        UIStyle.popVar();

        UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.22);
        gui.label("Lvl " + playerLevel + " " + playerClass);
        UIStyle.popVar();

        UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(2, 0.2));
        UIStyle.pushColor(UIStyle.COL_METER_TRACK, @(0.13, 0.13, 0.13));

        UIStyle.pushColor(UIStyle.COL_METER_FILL, @(0.8, 0.13, 0.13));
        gui.meter(0, maxHealth, health);
        UIStyle.popColor();

        UIStyle.pushColor(UIStyle.COL_METER_FILL, @(0.25, 0.35, 1.0));
        gui.meter(0, maxMana, mana);
        UIStyle.popColor(2);

        UIStyle.popVar();

    gui.endColumn();
    UIStyle.popVar();

    // --- Minimap (top-right) ---

    UIStyle.pushColor(UIStyle.COL_RECT, @(0.1, 0.2, 0.14));
    UIStyle.pushVar(UIStyle.VAR_RECT_CONTROL_POINTS, @(1, 1));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2, 1));
    gui.rect(@(1 - pad / 2, 1 - pad / 2));
    UIStyle.popVar(2);
    UIStyle.popColor();
    UIStyle.pushVar(UIStyle.VAR_LABEL_CONTROL_POINTS, @(1, 1));
    UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.2);
    gui.label("Canals", @(1 - pad, 1 - pad));
    UIStyle.popVar(2);

    // --- Quests (right side column) ---

    UIStyle.pushColor(UIStyle.COL_RECT, @(0.14, 0.1, 0.1));
    UIStyle.pushVar(UIStyle.VAR_RECT_CONTROL_POINTS, @(1, 1));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.75, 2));
    gui.rect(@(1 - pad / 2, 0.625));
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushVar(UIStyle.VAR_CONTAINER_SPACING, 0.01);
    UIStyle.pushVar(UIStyle.VAR_CONTAINER_CONTROL_POINTS, @(1, 1));
    gui.beginColumn(@(1 - pad, 0.6));

        UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.2);
        gui.label("Quests");
        UIStyle.popVar();

        UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.16);
        for (0 => int q; q < quests.size(); q++) {
            gui.label((q + 1) + ". " + quests[q]);
        }
        UIStyle.popVar();

    gui.endColumn();
    UIStyle.popVar(2);

    // --- Action Bar (bottom-center) ---

    // Action bar dimensions
    0.3 => float btnSize;
    4 => float barWidth;
    actionIcons.size() => int numBtns;
    (barWidth - numBtns * btnSize) / (numBtns + 1) => float btnGap;

    // Background
    UIStyle.pushColor(UIStyle.COL_RECT, @(0.08, 0.08, 0.09));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(barWidth, 0.5));
    gui.rect(@(0, -1 + pad * 2.5));
    UIStyle.popVar();
    UIStyle.popColor();

    // XP meter
    UIStyle.pushVar(UIStyle.VAR_METER_CONTROL_POINTS, @(0.5, 0));
    UIStyle.pushVar(UIStyle.VAR_METER_SIZE, @(barWidth, 0.05));
    gui.meter(@(0, -1 + pad), 0, 10000, 6900);
    UIStyle.popVar(2);

    // Action buttons in a row, evenly spaced within bar
    UIStyle.pushVar(UIStyle.VAR_BUTTON_SIZE, @(btnSize, btnSize));
    UIStyle.pushColor(UIStyle.COL_BUTTON, @(0.19, 0.18, 0.12));
    UIStyle.pushColor(UIStyle.COL_BUTTON_DISABLED, @(0.1, 0.1, 0.1));
    UIStyle.pushVar(UIStyle.VAR_TOOLTIP_POSITION, UIStyle.TOP);
    UIStyle.pushVar(UIStyle.VAR_CONTAINER_SPACING, btnGap);
    UIStyle.pushVar(UIStyle.VAR_CONTAINER_PADDING, btnGap);
    ChuGUI.worldToNDCSize(@(barWidth, 0)).x / 2.0 => float barHalfNDC;
    gui.beginRow(@(-barHalfNDC, -1 + pad * 2.5));

        for (0 => int i; i < actionIcons.size(); i++) {
            cooldowns[i] > 0.0 || mana < manaCost => int btnDisabled;
            gui.pushID(actionIcons[i] + i);
            gui.button("", me.dir() + "assets/" + actionIcons[i] + ".png", btnDisabled) => int pressed;
            gui.tooltip(actionIcons[i]);
            gui.popID();

            if (!btnDisabled && pressed) {
                GG.fps() * 2.0 => cooldowns[i];
                manaCost -=> mana;
            }
            if (cooldowns[i] > 0.0) {
                1 -=> cooldowns[i];
            }
        }

    gui.endRow();
    UIStyle.popVar(4);
    UIStyle.popColor(2);

    // --- Chat box (bottom-left) ---

    UIStyle.pushColor(UIStyle.COL_RECT, @(0.07, 0.05, 0.11, 0.5));
    UIStyle.pushVar(UIStyle.VAR_RECT_CONTROL_POINTS, @(0, 0));
    UIStyle.pushVar(UIStyle.VAR_RECT_SIZE, @(2.25, 1.4));
    gui.rect(@(-1 + pad, -0.75));
    UIStyle.popVar(2);
    UIStyle.popColor();

    UIStyle.pushVar(UIStyle.VAR_CONTAINER_SPACING, 0.005);
    UIStyle.pushVar(UIStyle.VAR_LABEL_SIZE, 0.12);
    gui.beginColumn(@(-1 + pad + 0.025, -0.4));

        for (0 => int i; i < chatLog.size(); i++) {
            gui.label(chatLog[i]);
        }

        UIStyle.pushVar(UIStyle.VAR_INPUT_SIZE, @(2, 0.2));
        UIStyle.pushVar(UIStyle.VAR_INPUT_TEXT_SIZE, 0.12);
        UIStyle.pushColor(UIStyle.COL_INPUT, @(0.07, 0.05, 0.11, 0.5));
        UIStyle.pushColor(UIStyle.COL_INPUT_BORDER, Color.BLACK);
        gui.input("Chat", chatMessage, "Type a message...") => chatMessage;
        UIStyle.popColor(2);
        UIStyle.popVar(2);

    gui.endColumn();
    UIStyle.popVar(2);
}
