params["_unit", "_target"];

private _targetName = getText (configOf _target >> "textsingular");
private _targetNameSound = getText (configOf _target >> "nameSound");

private _result = [_target, _unit] call WTDIF_fnc_reportDistance;
_radioChatMessageDist = _result select 0;
_radioChatWordsDist = _result select 1;        

_result = [_target, _unit] call WTDIF_fnc_reportDirection;
_radioChatMessageDir = _result select 0;
_radioChatWordsDir = _result select 1;

_radioChatMessage = format["Spotted - %1 - %2 - %3", _targetName, _radioChatMessageDist, _radioChatMessageDir];
_radioChatWords = ["EnemyDetected", _targetNameSound, _radioChatWordsDist select 0, _radioChatWordsDir select 0];

[_unit, _radioChatMessage, _radioChatWords] spawn WTDIF_fnc_radioChat;
(group _unit) reveal _target;
