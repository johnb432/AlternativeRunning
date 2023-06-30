#include "script_component.hpp"

/*
 * Author: WebKnight, johnb43
 * Monitors the unit while running.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * player call alternative_running_main_fnc_startMonitoring;
 *
 * Public: No
 */

params ["_unit"];

// Add monitoring to unit
private _pfhID = _unit getVariable QGVAR(pfhID);

if (!isNil "_pfhID") exitWith {};

_pfhID = [{
    params ["_unit"];

    // If unit died, stop
    if (!alive _unit) exitWith {
        _pfhID call CBA_fnc_removePerFrameHandler;

        _unit setVariable [QGVAR(pfhID), nil];
    };

    private _animationState = animationState _unit;
    private _condition = ((_unit getHit "legs") >= 0.5) || {!isSprintAllowed _unit};
    private _posASL = getPosASL _unit;
    private _posASLz = _posASL select 2;

    // Check if player is in valid state for running
    if (
        ((_animationState in GVAR(animationsOther)) && {_condition || {getStamina _unit < 3} || {_posASLz < -0.6}}) ||
        {(_animationState in GVAR(animationsWater)) && {_condition || {_posASLz < -1.45} || {_posASLz >= -0.6}}}
    ) exitWith {
        [_unit, OFF] call FUNC(run);
    };

    private _terrainGradAngle = [_posASL, getDir _unit, 0.05] call BIS_fnc_terrainGradAngle;

    // Check terrain slope
    if (_terrainGradAngle < 17 && {_terrainGradAngle > -26}) then {
        if !(_animationState in GVAR(animations)) then {
            [_unit, ON] call FUNC(run);
        };
    } else {
        if (_animationState in GVAR(animations)) then {
            [_unit, OFF] call FUNC(run);
        };
    };
}, [0.5, 0.1] select (_unit == call CBA_fnc_currentUnit), _unit] call CBA_fnc_addPerframeHandler;

_unit setVariable [QGVAR(pfhID), _pfhID];
