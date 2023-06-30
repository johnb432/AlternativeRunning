#include "script_component.hpp"

/*
 * Author: WebKnight, johnb43
 * Makes a unit start or stop running.
 *
 * Arguments:
 * 0: Target <OBJECT> (default: objNull)
 * 1: Type: Turn on (1), turn off (0) or toggle (-1) <NUMBER> (default: 0)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, 1] call alternative_running_main_fnc_run;
 *
 * Public: No
 */

params [["_unit", objNull, [objNull]], ["_type", OFF, [0]]];

// If unit is not local or dead, skip
if (!local _unit || {!alive _unit}) exitWith {};

// If in zeus, don't activate it on zeus unit
if ((_unit == player) && {!isNull findDisplay IDD_RSCDISPLAYCURATOR}) exitWith {};

private _animationState = animationState _unit;
private _currentWeapon = currentWeapon _unit;
private _weapons = [primaryWeapon _unit, handgunWeapon _unit, secondaryWeapon _unit];

// If in running animation, turn off (even if no weapon in hand)
if ((_animationState in GVAR(animations)) && {_type != ON}) exitWith {
    private _pfhID = _unit getVariable QGVAR(pfhID);

    // Stop monitoring
    if (!isNil "_pfhID") then {
        _pfhID call CBA_fnc_removePerFrameHandler;

        _unit setVariable [QGVAR(pfhID), nil];
    };

    // Primary, handgun, launcher, no weapon
    _unit playMoveNow (["AmovPercMstpSrasWrflDnon", "AmovPercMstpSrasWpstDnon", "AmovPercMstpSrasWlnrDnon", "AmovPercMstpSnonWnonDnon"] select (_weapons find _currentWeapon));
};

// If no weapon or not told to start, quit
if (_currentWeapon == "" || {_type == OFF}) exitWith {};

private _posASL = getPosASL _unit;
private _terrainGradAngle = [_posASL, getDir _unit, 0.05] call BIS_fnc_terrainGradAngle;

// Check if possible to run
if !(((_unit getHit "legs") < 0.5) && {isSprintAllowed _unit} && {stance _unit != "UNDEFINED"} && {isNull objectParent _unit} && {_terrainGradAngle < 17} && {_terrainGradAngle > -26}) exitWith {};

private _posASLz = _posASL select 2;

// Handgun weapons
if (_currentWeapon == (_weapons select 1)) exitWith {
    if (getStamina _unit >= 3 && {_posASLz >= -0.6}) then {
        _unit playMoveNow QGVAR(pistol);

        _unit call FUNC(startMonitoring);
    };
};

// Launchers
if (_currentWeapon == (_weapons select 2)) exitWith {
    if (getStamina _unit >= 3 && {_posASLz >= -0.6}) then {
        _unit playMoveNow QGVAR(runWithLauncher);

        _unit call FUNC(startMonitoring);
    };
};

// Default: Primary weapons
if (_posASLz <= -1.45) exitWith {};

if (_posASLz < -0.6) then {
    _unit playMoveNow ([QGVAR(runWaterLight), QGVAR(runWaterHeavy)] select (getNumber (configfile >> "CfgMagazines" >> currentMagazine _unit >> "count") >= 40));

    _unit call FUNC(startMonitoring);
} else {
    if (getStamina _unit >= 3) then {
        private _bulletCount = getNumber (configfile >> "CfgMagazines" >> currentMagazine _unit >> "count");

        _unit playMoveNow ([QGVAR(run), QGVAR(runLowered)] select (GVAR(enableAltRunMgBolt) && {_bulletCount <= 10 || {_bulletCount >= 40}}));

        _unit call FUNC(startMonitoring);
    };
};
