params["_target", "_selectedUnits"];


{
    _visibility = [objNull, "VIEW"] checkVisibility [eyePos _x, aimPos _target];
    format["Unit %1 has a visibility %2 for target %3", _x, _visibility, _target] call WTDIF_fnc_debug;
    if(_visibility <= 0) then {
        [_x, "Negative, I can't see it", ["negative"]] spawn WTDIF_fnc_radioChat;
    } else {

        _result = [_target, _x] call WTDIF_fnc_reportDistance;
        _radioChatMessageDist = _result select 0;
        _radioChatWordsDist = _result select 1;        
        
        _result = [_target, _x] call WTDIF_fnc_reportDirection;
        _radioChatMessageDir = _result select 0;
        _radioChatWordsDir = _result select 1;

        _radioChatMessage = _radioChatMessageDist + " - " + _radioChatMessageDir;
        _radioChatWords = [_radioChatWordsDist select 0, _radioChatWordsDir select 0];

        [_x, _radioChatMessage, _radioChatWords] spawn WTDIF_fnc_radioChat;
        break;
    };

} forEach _selectedUnits;

