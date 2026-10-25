params["_target", "_selectedUnits"];


{
    _visibility = [objNull, "VIEW"] checkVisibility [eyePos _x, aimPos _target];
    format["Unit %1 has a visibility %2 for target %3", _x, _visibility, _target] call WTDIF_fnc_debug;
    if(_visibility <= 0) then {
        [_x, "Negative, I can't see it", ["negative"]] spawn WTDIF_fnc_radioChat;
    } else {

        _distance = _x distance2d _target;
        _radioChatMessageDist = "";
        _radioChatWordDist = "";

        if(_distance <= 90) then {
            _radioChatMessageDist = "75m";
            _radioChatWordDist = "dist75";
        } else {
            _d = (floor(_distance / 150)) + 1;
            _radioChatMessageDist = (str _d) + "00m";
            _radioChatWordDist="dist"+(str _d)+"00";
        };
        
        _result = [_target, _x] call WTDIF_fnc_reportDirection;
        _radioChatMessageDir = _result select 0;
        _radioChatWordsDir = _result select 1;

        _radioChatMessage = _radioChatMessageDist + " - " + _radioChatMessageDir;
        _radioChatWords = [_radioChatWordDist, _radioChatWordsDir select 0];

        [_x, _radioChatMessage, _radioChatWords] spawn WTDIF_fnc_radioChat;
        break;
    };

} forEach _selectedUnits;

