#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

// CBA Settings
[
    QGVAR(enableAltRunMgBolt),
    "CHECKBOX",
    LLSTRING(settingEnableMgBolt),
    [COMPONENT_NAME, LLSTRING(clientSettings)],
    true
] call CBA_fnc_addSetting;

// Animation groups
GVAR(animations) = [QGVAR(run), QGVAR(runLowered), QGVAR(runWithLauncher), QGVAR(pistol), QGVAR(runWaterLight), QGVAR(runWaterHeavy)] apply {toLowerANSI _x};
GVAR(animationsOther) = GVAR(animations) select [0, 4];
GVAR(animationsWater) = GVAR(animations) select [4, 2];

// CBA Keybinds
[COMPONENT_NAME, QGVAR(toggleAlternativeRunning), [LLSTRING(toggleAction), LLSTRING(toggleActionDesc)], {
    // Toggle running mode
    [call CBA_fnc_currentUnit, TOGGLE] call FUNC(run);
}, {}, [DIK_W, [true, false, true]]] call CBA_fnc_addKeybind;

ADDON = true;
