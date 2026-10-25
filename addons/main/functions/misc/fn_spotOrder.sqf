params["_unit","_directionStart", "_directionEnd"];

format["Spotting order for unit %1, from %2 to %3", _unit, _directionStart, _directionEnd] call WTDIF_fnc_debug;

_unitNumber = groupId _unit;
_unitNumberWord = [_unitNumber] call WTDIF_fnc_getUnitNumberInWord;
[leader (group _unit), format["%1, watch that direction with your binoculars", _unitNumber], [_unitNumberWord, "ObserveThatPosition"]] spawn WTDIF_fnc_radioChat;
sleep 1;

if(_directionStart == _directionEnd) then {
    _directionStart = _directionStart - 20;
    _directionEnd = _directionEnd + 20;
    if(_directionStart < 0) then {
        _directionStart = 360 + _directionStart;
    };
    if(_directionEnd > 360) then {
        _directionEnd = 360 - _directionEnd;
    };
};

WTDIF_SPOTTING_TIME = 5;
WTDIF_SPOTTING_DIRECTION_STEP = 15;
WTDIF_SPOTTING_RANGE=20;
WTDIF_SPOTTING_TICK = 100;
WTDIF_SPOTTING_MAX_DISTANCE = 1000;


private _binocular = binocular _unit;

// Just do nothing if unit has no binocular item
if(_binocular == "") exitWith {
    [_unit, "Negative, no binocular", ["negative"]] spawn WTDIF_fnc_radioChat;
};

[_unit, "Copy", ["ready"]] spawn WTDIF_fnc_radioChat;

_unit setVariable["WTDIF_direction_start", _directionStart];
_unit setVariable["WTDIF_direction_end", _directionEnd];

// already in spotting, I just change his direction
if( !isNull( _unit getVariable["WTDIF_state_machine", objnull]) ) exitWith {
    _directionCurrent = _directionStart;
    _directionTarget = _directionEnd;
    _clockWise=true;
    if(abs(_directionStart - _directionEnd) <= 180) then {
        _clockWise = _directionStart < _directionEnd;
    } else {
        _clockWise = _directionStart > _directionEnd;
    };
    _unit setVariable["WTDIF_clock_wise", _clockWise];
    _unit setVariable["WTDIF_direction_current", _directionCurrent];
    _unit setVariable["WTDIF_direction_target", _directionTarget];
};

_unit setVariable["WTDIF_binocular_item", _binocular];
_unit setVariable["WTDIF_old_selected_weapon", currentWeapon _unit];

_timeOutCondition = { 
    _timeout = _this getVariable "WTDIF_timeout_state";
    CBA_missionTime > _timeout 
};

_startCode = {
    params["_unit"];
    
    _unit disableAI "PATH";
    _unit disableAI "TARGET";
    _unit disableAI "AUTOTARGET";
    _unit setUnitPos "MIDDLE";
    _directionStart = _unit getVariable "WTDIF_direction_start";
    _directionEnd = _unit getVariable "WTDIF_direction_end";
    _directionCurrent = _directionStart;
    _directionTarget = _directionEnd;
    _clockWise=true;
    if(abs(_directionStart - _directionEnd) <= 180) then {
        _clockWise = _directionStart < _directionEnd;
    } else {
        _clockWise = _directionStart > _directionEnd;
    };
    _unit setVariable["WTDIF_clock_wise", _clockWise];
    _unit setVariable["WTDIF_direction_current", _directionCurrent];
    _unit setVariable["WTDIF_direction_target", _directionTarget];
    _unit setVariable["WTDIF_position", (expectedDestination _unit) select 0];
};

_spottingCode = {
    params["_unit"];
    _currentFrame = diag_frameno;
    _lastFrame = _unit getVariable ["WTDIF_last_tick", 0];

    if (_currentFrame - _lastFrame >= WTDIF_SPOTTING_TICK) then {

        _binocular = _unit getVariable "WTDIF_binocular_item";
        _unit selectWeapon _binocular;

        _directionCurrent = _unit getVariable "WTDIF_direction_current";
        _directionRandom = _directionCurrent + random (WTDIF_SPOTTING_DIRECTION_STEP/2);
        [_unit, _directionRandom] call WTDIF_fnc_doWatchDirection;

        _unit setVariable ["WTDIF_last_tick", _currentFrame];
    };

};

_revealTargetsCode = {
    params["_unit"];
    _possibleTargets = _unit nearEntities ["AllVehicles",WTDIF_SPOTTING_MAX_DISTANCE];
    _possibleTargets = _possibleTargets select { 
        [side _unit, side _x] call BIS_fnc_sideIsEnemy && (group _unit) knowsAbout _x == 0
    };
    _directionCurrent = _unit getVariable "WTDIF_direction_current";
    _minAngle = _directionCurrent - (WTDIF_SPOTTING_RANGE/2);
    if(_minAngle < 0) then {
        _minAngle = 360 + _minAngle;
    };
    _maxAngle = _directionCurrent + (WTDIF_SPOTTING_RANGE/2);
    if(_maxAngle > 360) then {
        _maxAngle = 360 - _maxAngle;
    };
    
    _possibleTargets = _possibleTargets select {
        _relDir = _unit getDir _x;
        _isInRange = false;

        if (_minAngle <= _maxAngle) then {    
            _isInRange = (_relDir >= _minAngle && _relDir <= _maxAngle);
        } else {    
            _isInRange = (_relDir >= _minAngle || _relDir <= _maxAngle);
        };

        _isInRange
    };

    {
        _visibility = [objNull, "VIEW"] checkVisibility [eyePos _unit, aimPos _x];
        format["Visibility from %1 to %2 = %3", _unit, _x, _visibility] call WTDIF_fnc_debug;

        // TODO better algorithm detection?
        if( random 1 <= _visibility) then {
            [_unit, _x] call WTDIF_fnc_revealTarget;
        }

    }forEach _possibleTargets;

};

_nextSpottingDirectionCode = {
    params["_unit"];
    _clockWise = _unit getVariable "WTDIF_clock_wise";
    _directionCurrent = _unit getVariable "WTDIF_direction_current";
    _directionTarget = _unit getVariable "WTDIF_direction_target";

    _clockWiseN = 1;
    if(!_clockWise) then {
        _clockWiseN = -1;
    };
    _nextDirectionStep = _directionCurrent + (WTDIF_SPOTTING_DIRECTION_STEP * _clockWiseN);
    if(_nextDirectionStep > 360) then {
        _nextDirectionStep = 360 - _nextDirectionStep;
    };
    if(_nextDirectionStep < 0) then {
        _nextDirectionStep = 360 + _nextDirectionStep;
    };
    if(abs (_nextDirectionStep - _directionTarget ) < WTDIF_SPOTTING_DIRECTION_STEP+1) then {
        
        _directionCurrent = _directionTarget;
        _unit setVariable["WTDIF_direction_current", _directionCurrent];

        _clockWise = !_clockWise;
        _unit setVariable ["WTDIF_clock_wise", _clockWise];

        _directionStart = _unit getVariable "WTDIF_direction_start";
        _directionEnd = _unit getVariable "WTDIF_direction_end";
        if(_directionTarget==_directionEnd) then {
            _directionTarget=_directionStart;
        } else {
            _directionTarget=_directionEnd;
        };
        _unit setVariable["WTDIF_direction_target", _directionTarget];

    } else {
        _directionCurrent = _nextDirectionStep;
        _unit setVariable["WTDIF_direction_current", _directionCurrent];
    };

    format["Next spotting direction -> %1", _directionCurrent] call WTDIF_fnc_debug;

    
};

_endCondition = {
    _dest = (expectedDestination _this) select 0;
    _position = _this getVariable "WTDIF_position";
    !(alive _this) || !(_dest isEqualTo _position)
};

_endCode = {
    params["_unit"];
    _stateMachine = _unit getVariable "WTDIF_state_machine";
    [_stateMachine] call CBA_statemachine_fnc_delete;
    _unit setVariable ["WTDIF_state_machine", nil];
    _oldWeapon = _unit getVariable "WTDIF_old_selected_weapon";
    _unit selectWeapon _oldWeapon;
    _unit enableAI "PATH";
    _unit enableAI "TARGET";
    _unit enableAI "AUTOTARGET";
    _unit setUnitPos "AUTO";
};


private _stateMachine = [ [_unit], true ] call CBA_statemachine_fnc_create;
_unit setVariable ["WTDIF_state_machine", _stateMachine];

[_stateMachine, {}, _startCode, {}, "Start"] call CBA_statemachine_fnc_addState;

[_stateMachine, _spottingCode, {
    _this setVariable["WTDIF_timeout_state", CBA_missionTime+WTDIF_SPOTTING_TIME];
    }, {}, "Spotting"] call CBA_statemachine_fnc_addState;

[_stateMachine, _revealTargetsCode, {}, {}, "RevealTargets"] call CBA_statemachine_fnc_addState;

[_stateMachine, {}, {}, {}, "NextSpottingDirection"] call CBA_statemachine_fnc_addState;

[_stateMachine, {}, _endCode, {}, "End"] call CBA_statemachine_fnc_addState;



[_stateMachine, "Start", "Spotting", {true}, {}, "start_to_spotting"] call CBA_statemachine_fnc_addTransition;
[_stateMachine, "Spotting", "RevealTargets", _timeOutCondition, {}, "spotting_to_reveal_targets"] call CBA_statemachine_fnc_addTransition;
[_stateMachine, "RevealTargets", "Spotting", {true}, _nextSpottingDirectionCode, "reveal_targets_to_spotting"] call CBA_statemachine_fnc_addTransition;

[_stateMachine, "RevealTargets", "End", ["WTDIF_spotting_end"] , { true }, {}, "revealtargets_to_end_event"] call CBA_statemachine_fnc_addEventTransition;
[_stateMachine, "Spotting", "End", ["WTDIF_spotting_end"] , { true }, {}, "spotting_to_end_event"] call CBA_statemachine_fnc_addEventTransition;

[_stateMachine, "RevealTargets", "End", _endCondition, {}, "revealtargets_to_end"] call CBA_statemachine_fnc_addTransition;
[_stateMachine, "Spotting", "End", _endCondition, {}, "spotting_to_end"] call CBA_statemachine_fnc_addTransition;

