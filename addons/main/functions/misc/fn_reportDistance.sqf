params["_target", "_person"];

private _radioChatText = "";
private _radioChatWords = "";

_distance = (getPosAtl _target) vectordistance (getPosATl _person);

if(_distance <= 90) then {
    _radioChatText = "75m";
    _radioChatWords = "dist75";
} else {
    _d = round(_distance / 100);
    _radioChatText = (str _d) + "00m";
    _radioChatWords="dist"+(str _d)+"00";
};

[_radioChatText, [_radioChatWords]]