#include "..\script_component.hpp"
/*
 * Author: MiszczuZPolski
 * Handles any visual effects of medical.
 *
 * Arguments:
 * 0: Manual, instant update (optional, default false) <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call kat_feedback_fnc_handleEffects
 *
 * Public: No
 */
params [["_manualUpdate", false]];

if (ACEGVAR(common,OldIsCamera) || {!alive ACE_player}) exitWith {
    [false]    call FUNC(effectOpioid);
    [false]    call FUNC(effectLowSpO2);
};

BEGIN_COUNTER(handleEffects);

// - Current state info -------------------------------------------------------
private _opioid          = GET_PP(ACE_player);
private _spO2             = GET_KAT_SPO2(ACE_player);
private _unconscious      = IS_UNCONSCIOUS(ACE_player);
private _poisoned = IS_AIRPOISONED(ACE_player);
private _tear = IN_TEARGAS(ACE_player);
private _wheeze = ((ACE_player getVariable [QGVAR(pneumothorax), 0] > 0) || ACE_player getVariable [QGVAR(hemopneumothorax), false] || ACE_player getVariable [QGVAR(tensionpneumothorax), false] || ACE_player getVariable [QEGVAR(chemical,airPoisoning), false]);

// - Visual effects -----------------------------------------------------------

[!_unconscious, _opioid] call FUNC(effectOpioid);

[
    !_unconscious,
    linearConversion [GVAR(effectLowSpO2), EGVAR(breathing,SpO2_dieValue), _spO2, 0, 1, true]
] call FUNC(effectLowSpO2);

[!_unconscious, _poisoned, ACE_player] call FUNC(effectCoughing);
[!_unconscious, _tear] call FUNC(effectTearHaze);
[!_unconscious, _wheeze, ACE_player] call (effectBreathingWheeze);

END_COUNTER(handleEffects);
