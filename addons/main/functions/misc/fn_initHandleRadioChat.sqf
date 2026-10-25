
_KnowsAboutChanged = {
    params ["_group", "_targetUnit", "_newKnowsAbout", "_oldKnowsAbout"];
    if([side _group, side _targetUnit] call BIS_fnc_sideIsEnemy) then {
        /*format["Enemy %1, old %2, new %3", _targetUnit, _oldKnowsAbout, _newKnowsAbout] call WTDIF_fnc_debug;
        if(_oldKnowsAbout == 0) then {
            format["ENEMY DETECTED %1", _targetUnit] call WTDIF_fnc_debug;
        };*/
        if(_newKnowsAbout == 0) then {
             format["FORGOT ENEMY %1", _targetUnit] call WTDIF_fnc_debug;
            _targetUnit setVariable ["WTDIF_reported", nil];
        }
    };
};

(group player) addEventHandler ["KnowsAboutChanged", _KnowsAboutChanged ];

addMissionEventHandler ["HandleChatMessage", {
	params ["_channel", "_owner", "_from", "_text", "_person", "_name", "_strID", "_forcedDisplay", "_isPlayerMessage", "_sentenceType", "_chatMessageType", "_params"];

    _block = false;
    _group = group _person;
    _returnValue = false;
    if(group player == _group && _channel == 3) then {

        if( "[SKIP]" in _text) then {
            _returnValue = true;
        };

        if( "Contact" in _text) then {

            _tokens = _text splitString "- ";
            _unitType = _tokens select 1;
            _distance = 50;
            _directionWord = "";
            if(count _tokens > 2) then {            
                _distance = parseNumber ((_tokens select 2) trim ["m", 2]);
                _directionWord = _tokens select 3;
                // Bearing SPACE 000
                if(toLower(_directionWord) == "bearing") then {
                    _directionWord = _directionWord+ (_tokens select 4);
                    _directionWord = _directionWord trim [".",2];
                };

                // North DASH East
                if((toLower(_directionWord) == "north" || toLower(_directionWord) == "south") && count _tokens > 4 ) then {
                    _directionWord = _directionWord+ "-" + (_tokens select 4);
                };

                // Due west
                if(toLower(_directionWord) == "due") then {
                    _directionWord = _tokens select 4;
                    _directionWord = _directionWord trim [".",2];
                };
            };

            _groupDir = formationDirection (leader _group);

            _directionType = "";
            _directionApprox = 0;
        
            if(_directionWord != "") then {
                format["Processing directionWord=%1", _directionWord] call WTDIF_fnc_debug;
                _directionType = [_directionWord] call WTDIF_fnc_typeOfDirection;
                _directionApprox = [_directionWord, _groupDir] call WTDIF_fnc_getDirectionApprox;
            };

            format["CONTACT chat with: type=%1, distance=%2, directionWord=%3, directionType=%4, directionApprox=%5", _unitType, _distance, _directionWord, _directionType, _directionApprox] call WTDIF_fnc_debug;

            _targets = _group targets [true, 1000, [], 5];

            // First filter -> by unitType
            _targets = _targets select {
                _name = getText (configOf _x >> "textsingular");
                format["TEST: trying target %1 with name %2 with name from chat %3", _x, _name, _unitType] call WTDIF_fnc_debug;
                toLower(_name) == toLower(_unitType)
            };

            // Second filter -> by distance
            _targets = _targets select {
                _targetDistance = _person distance2D _x;
                format["TEST: trying target %1 with distance %2 with distance from chat %3", _x, _targetDistance, _distance] call WTDIF_fnc_debug;
                _diffDistance = abs((_person distance2D _x) - _distance);
                _diffDistance <=100
            };

            // Third filter -> by direction approx if direction provided
            if(_directionType != "") then {
                _directionThreshold = switch(_directionType) do {
                    case "DIRECTION": { 90};
                    case "BEARING": { 15};
                    case "COMPASS": { 45};
                };
                _targets = _targets select {
                    _targetDir = _person getDirVisual _x;
                    format["TEST: trying target %1 with dir %2 with direction approx %3", _x, _targetDir, _directionApprox] call WTDIF_fnc_debug;
                    _diffDir = abs(_directionApprox - _targetDir);
                    if(_diffDir > 180) then {
                        _diffDir = 360 - _diffDir;
                    };
                    _diffDir <= _directionThreshold;
                };
            };

            // if still multiple targets, get the first with "reported" variable false.
            // if everything has reported variable true, just the first.            
            if(count _targets > 1) then {
                _filteredTargets = _targets select { !(_x getVariable["WTDIF_reported", false]) };
                if(count _filteredTargets > 0) then {
                    _targets = _filteredTargets;
                }
            };

            _target = objnull;
            if( count _targets > 0) then {
                _target = _targets select 0;
            };        

            if(!isNull(_target)) then {

                format["Tracking successful: got target %1", _target] call WTDIF_fnc_debug;

                _alreadyCompass = (_directionType == "COMPASS" || _directionType == "BEARING") && 
                       (WTDIF_report_direction_system == 1 || WTDIF_report_direction_system == 2);
                _alreadyDirection = _directionType == "DIRECTION" && WTDIF_report_direction_system == 0;

                // we add new info only if needed!
                if( !_alreadyCompass && !_alreadyDirection) then {

                    _result = [_target, _person, _directionType] call WTDIF_fnc_reportDirection;                
                    _radioChatText = _result select 0;
                    _radioChatWords = _result select 1;

                    [_person, "[SKIP] "+_radioChatText, _radioChatWords] spawn WTDIF_fnc_radioChat;

                    _prefix = "";
                    if(_target getVariable["WTDIF_reported", false]) then {
                        _prefix = "Old "
                    };
                    
                    _target setVariable ["WTDIF_reported", true]; 
                    if(_radioChatText != "") then {
                        _returnValue = _prefix + _text + " - " +  _radioChatText;
                    };

                    format["In handlechatmessage original message was %1, now returning %2", _text, _returnValue] call WTDIF_fnc_debug;
                } else {
                    if(WTDIF_report_direction_visual_aid) then {         
                        uiNamespace setVariable ["WTDIF_HUD_dir", _groupDir];
                        _hud = switch(_directionType) do {
                            case "DIRECTION": { "DirectionHUD"};
                            case "BEARING": { "CompassHUD" };
                            case "COMPASS": { "CompassHUD" };
                        }; 
                        "WTDIFLayer" cutRsc [_hud, "PLAIN", -1, false];                            
                    };
                };
            };
        };
    };
    
    _returnValue

}];