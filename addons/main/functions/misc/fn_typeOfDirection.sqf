params["_directionWord"];

_directionWord = toLower _directionWord;
_directionType = "";

if("left" in _directionWord || "front" in _directionWord || "right" in _directionWord || "back" in _directionWord) then {
    _directionType = "DIRECTION";
};

if("bearing" in _directionWord) then {
    _directionType = "BEARING";
};

if("north" in _directionWord || "south" in _directionWord || "east" in _directionWord || "west" in _directionWord) then {
    _directionType = "COMPASS";
};

_directionType