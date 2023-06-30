#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {
            "cba_main",
            "cba_xeh"
        };
        author = "WebKnight";
        authors[] = {"WebKnight", "johnb43"};
        url = "https://vk.com/senpai_naxoditsya_tut";
        VERSION_CONFIG;
    };
};

#include "CfgMoves.hpp"
#include "CfgEventHandlers.hpp"

// Modded keybinds
class CfgUserActions {
    class GVAR(alternativeRunning) {
        displayName = CSTRING(toggleAction);
        tooltip = CSTRING(toggleActionDesc);
        onActivate = QUOTE([ARR_2(call CBA_fnc_currentUnit,TOGGLE)] call FUNC(run));
    };
};

class CfgDefaultKeysPresets {
    class Arma2 {
        class Mappings {
            GVAR(alternativeRunning)[] = {0x12A}; // 2x Left shift
        };
    };
};

class UserActionGroups {
    class PREFIX {
        name = COMPONENT_NAME;
        isAddon = 1;
        group[] = {QGVAR(alternativeRunning)};
    };
};

class UserActionsConflictsGroups {
    class ActionGroups {
        PREFIX[] = {QGVAR(alternativeRunning)};
    };

    class CollisionGroups {
        ADDON[] = {QUOTE(PREFIX)};
    };
};
