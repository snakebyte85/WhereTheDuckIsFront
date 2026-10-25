params["_unit","_directionStart", "_directionEnd"];

private _binocular = binocular _unit;

// Just do nothing if unit has no binocular item
if(_binocular == "") exitsWith {
              [_unit, "Negative, no binocular", ["negative"]] call WTDIF_fnc_radioChat;
};

_unit setVariable["WTDIF_binocular_item", _binocular];
_unit setVariable["WTDIF_old_selected_weapon", currentWeapon _unit];

_unit setVariable["WTDIF_direction_start", _directionStart];
_unit setVariable["WTDIF_direction_end", _directionEnd];

_startCode = {
           _binocular = _x getVariable "WTDIF_binocular_item";
           _x selectWeapon _binocular;
           _x disableAI "PATH";
           _x disableAI "TARGET";
           _x disableAI "AUTOTARGET";
           _directionStart = _x getVariable "WTDIF_direction_start";
           _directionEnd = _x getVariable "WTDIF_direction_end";
           _directionCurrent = _directionStart;
           _clockWise=true;
           if(abs(_directionStart - _directionEnd) <= 180) then {
                                         _clockWise = _directionStart < _directionEnd;
           } else {
                                         _clockWise = _directionStart > _directionEnd;
           };
           _x setVariable["WTDIF_clock_wise", _clockWise];
};

_endCode = {
         _stateMachine = _x getVariable "WTDIF_state_machine";
         [_stateMachine] call CBA_statemachine_fnc_delete;
         _oldWeapon = _x getVariable "WTDIF_old_selected_weapon";
         _x selectWeapon _oldWeapon;
         _x enableAI "PATH";
         _x enableAI "TARGET";
         _x enableAI "AUTOTARGET";
};


private _stateMachine = [ [_unit], true ] call CBA_statemachine_fnc_create;
_unit setVariable ["WTDIF_state_machine", _stateMachine]';

[_stateMachine, {}, _startCode, {}, "Start"] call CBA_statemachine_fnc_addState;

[_stateMachine, {}, {}, {}, "Spotting"] call CBA_statemachine_fnc_addState;

[_stateMachine, {}, {}, {}, "NextSpottingDirection"] call CBA_statemachine_fnc_addState;

[_stateMachine, {}, _endCode, {}, "End"] call CBA_statemachine_fnc_addState;



[_stateMachine, "Start", "Spotting", {true}, {}, "start_to_spotting"] call CBA_statemachine_fnc_addTransition;
[_stateMachine, "NextSpottingDirection", "Spotting", {true}, {}, "next_spotting_direction_to_spotting"] call CBA_statemachine_fnc_addTransition;

