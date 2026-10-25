#include "script_mod.hpp"

call WTDIF_fnc_initLocationHashmap;

call WTDIF_fnc_initHandleRadioChat;




// 2. Initialize the UI onto a dedicated screen rendering layer
//"ClockLayer" cutRsc ["ClockHUD", "PLAIN", -1, false];

// 3. Start a fast frame tick to update the UI structure alignment
addMissionEventHandler ["EachFrame", {

    if( alive player && count(units group player) > 0) then {
        private _display = uiNamespace getVariable ["WTDIF_ClockHUD", displayNull];

        if (!isNull _display) then {        
            private _ctrlArrow = _display displayCtrl 9992;
            _formationDir = uiNamespace getVariable ["WTDIF_HUD_dir", 0];
            _dirVec = getCameraViewDirection player;
            _x = _dirVec select 0;
            _y = _dirVec select 1;

            _playerDir = (_x atan2 _y);
            if (_playerDir < 0) then {
                _playerDir = _playerDir + 360;
            };
            _finalDir = _formationDir - _playerDir;
            if(_finalDir < 0) then {
                _finalDir = 360 + _finalDir;
            };
            _ctrlArrow ctrlSetAngle [_finalDir, 0.5, 0.5, true];
        };

        _display = uiNamespace getVariable ["WTDIF_DirectionHUD", displayNull];

        if (!isNull _display) then {        
            private _ctrlArrow = _display displayCtrl 9992;
            _formationDir = uiNamespace getVariable ["WTDIF_HUD_dir", 0];
            _dirVec = getCameraViewDirection player;
            _x = _dirVec select 0;
            _y = _dirVec select 1;

            // Calculate azimuth in degrees (0 = North, 90 = East, etc.)
            _playerDir = (_x atan2 _y);
            if (_playerDir < 0) then {
                _playerDir = _playerDir + 360;
            };
            _finalDir = _formationDir - _playerDir;
            if(_finalDir < 0) then {
                _finalDir = 360 + _finalDir;
            };
            _ctrlArrow ctrlSetAngle [_finalDir, 0.5, 0.5, true];
        };

        _display = uiNamespace getVariable ["WTDIF_CompassHUD", displayNull];

        if (!isNull _display) then {        
            private _ctrlArrow = _display displayCtrl 9992;
            _dirVec = getCameraViewDirection player;
            _x = _dirVec select 0;
            _y = _dirVec select 1;

            _playerDir = (_x atan2 _y);
            if (_playerDir < 0) then {
                _playerDir = _playerDir + 360;
            };

            _ctrlArrow ctrlSetAngle [-(_playerDir), 0.5, 0.5, true];

            private _ctrlText = _display displayCtrl 1001;
            if(WTDIF_show_bearing_visual_aid) then {
                _text = "";
                _roundedDir = round _playerDir;
                if(_roundedDir >= 0 && _roundedDir < 10) then {
                    _text = format["00%1", _roundedDir];
                };
                if(_roundedDir >= 10 && _roundedDir < 100) then {
                    _text = format["0%1", _roundedDir];
                };
                if(_roundedDir >= 100) then {
                    _text = format["%1", _roundedDir];
                };
                _ctrlText ctrlSetText _text;
            } else {
                _ctrlText ctrlSetText "";
            }
        };
    };

}];