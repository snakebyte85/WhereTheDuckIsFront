params["_directionWord", "_formationDir"];

_directionWord = toLower _directionWord;
private _directionType = [_directionWord] call WTDIF_fnc_typeOfDirection;
private _directionApprox=0;

switch(_directionType) do {

    case "DIRECTION": {
        switch(_directionWord) do {
            case "left": {_directionApprox=_formationDir-90};
            case "right": {_directionApprox=_formationDir+90};
            case "front": {_directionApprox=_formationDir};
            case "back": {_directionApprox=_formationDir+180};
        };
    };

    case "BEARING": {
        _directionApprox = parseNumber (_directionWord trim ["bearing",1])
    };

    case "COMPASS": {
        _directionApprox = switch(_directionWord) do {
            case "north": { 0 };
            case "north-east": { 45 };
            case "east": { 90 };
            case "south-east": { 135 };
            case "south": { 180 };
            case "south-west": { 225 };
            case "west": { 270 };
            case "north-west": { 315 };
        };
    };

};

if(_directionApprox < 0) then {
    _directionApprox = 360 + _directionApprox;
};
if(_directionApprox > 360) then {
    _directionApprox = _directionApprox - 360;
};

_directionApprox