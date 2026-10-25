params["_target", "_person"];

private _radioChatText = "";
private _radioChatWords = [];

private _group = group _person;
private _groupDir = formationDirection (leader _group);
switch (WTDIF_report_direction_system) do {

    case 0: { 
        _targetDir = _person getDirVisual _target;
        _finalDir = _targetDir - _groupDir;
        if(_finalDir < 0) then {
            _finalDir = 360 + _finalDir;
        };

        _directionWord = "";
        _directionWord = switch(true) do {
            case (_finalDir >= 315 || _finalDir <= 45): { "front"};
            case (_finalDir > 45 && _finalDir < 135): { "right"};
            case (_finalDir >= 135 && _finalDir <= 225): { "back"};
            case (_finalDir > 225 && _finalDir < 315): { "left"};
        };

        _radioChatText =  _directionWord;
        _radioChatWords = [_directionWord];

        if(WTDIF_report_direction_visual_aid) then {
            "WTDIFLayer" cutRsc ["DirectionHUD", "PLAIN", -1, false];
            uiNamespace setVariable ["WTDIF_HUD_dir", _groupDir];
        };
    };

    case 1: {

        _finalDir =  _person getDirVisual _target;
        _bearingText = "";
        _bearingWord = "";

        switch(true) do {

            case (_finalDir > 337.5 || _finalDir <= 22.5): { _bearingText = "North"; _bearingWord="north"; };
            case (_finalDir > 22.5 && _finalDir <= 67.5 ): { _bearingText = "North-East"; _bearingWord="northEast";};
            case (_finalDir > 67.5 && _finalDir <= 112.5 ): { _bearingText = "East"; _bearingWord="east";};
            case (_finalDir > 112.5 && _finalDir <= 157.5 ): { _bearingText = "South-East"; _bearingWord="southEast";};
            case (_finalDir > 157.5 && _finalDir <= 202.5 ): { _bearingText = "South"; _bearingWord="south";};
            case (_finalDir > 202.5 && _finalDir <= 247.5 ): { _bearingText = "South-West"; _bearingWord="southWest";};
            case (_finalDir > 247.5 && _finalDir <= 292.5 ): { _bearingText = "West"; _bearingWord="west";};
            case (_finalDir > 292.5 && _finalDir <= 337.5 ): { _bearingText = "North-West"; _bearingWord="northWest";};
        };
        
        _radioChatText = format["%1", _bearingText];
        _radioChatWords = [_bearingWord];

        if(WTDIF_report_direction_visual_aid) then {
            "WTDIFLayer" cutRsc ["CompassHUD", "PLAIN", -1, false];
            uiNamespace setVariable ["WTDIF_HUD_dir", 0];
        };
    };

    case 2: {

        _finalDir =  _person getDirVisual _target;
        _stepDown = floor(_finalDir / 15.0) * 15;
        _stepUp = (floor(_finalDir / 15.0) +1)* 15;
        _bearingNumber = 0;
        if( _finalDir - _stepDown < _stepUp - _finalDir ) then {
            _bearingNumber = _stepDown;
        } else {
            _bearingNumber = _stepUp;
        };
        if(_bearingNumber >= 360) then {
            _bearingNumber = 0;
        };

        _bearingWord="";
        if(_bearingNumber == 0) then {
            _bearingWord = "000";
        } else {
            if(_bearingNumber < 100) then {
                _bearingWord = format["0%1", _bearingNumber];
            } else {
                _bearingWord = format["%1", _bearingNumber];
            };
        };
        _radioChatText = format["Bearing %1", _bearingWord];
        _radioChatWords = ["bearing"+_bearingWord];

        if(WTDIF_report_direction_visual_aid) then {
            "WTDIFLayer" cutRsc ["CompassHUD", "PLAIN", -1, false];
            uiNamespace setVariable ["WTDIF_HUD_dir", 0];
        };
    };

    case 3: {        
        _targetDir = _person getDirVisual _target;
        _finalDir = _targetDir - _groupDir;
        if(_finalDir < 0) then {
            _finalDir = 360 + _finalDir;
        };
        _clockDir = round(_finalDir * 12 / 360);
        //format["Calculating clock stuff -> group dir is %1, target dir is %2, relative dir is %3", _groupDir, _targetDir, _finalDir] call WTDIF_fnc_debug;
        if(_clockDir == 0) then {
            _clockDir = 12;
        };               

        _clockDirWord = format["%1", _clockDir];

        _radioChatText =  "At " + _clockDirWord + " o'clock";
        _radioChatWords = ["at"+ _clockDirWord];

        if(WTDIF_report_direction_visual_aid) then {
            "WTDIFLayer" cutRsc ["ClockHUD", "PLAIN", -1, false];
            uiNamespace setVariable ["WTDIF_HUD_dir", _groupDir];
        };
    };
};

if(WTDIF_location_system) then {
    _locationInfo = [_target, _person] call WTDIF_fnc_location;
    if(_locationInfo != "") then {
        _radioChatText = _radioChatText + " - " + _locationInfo;
    } 
};

[_radioChatText, _radioChatWords]