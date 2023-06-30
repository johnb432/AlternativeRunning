#include "script_component.hpp"

if (!hasInterface) exitWith {};

// If the player tries to move backwards, stop running
addUserActionEventHandler ["MoveBack", "Activate", {
    [call CBA_fnc_currentUnit, OFF] call FUNC(run);
}];
