private _currentMenu = [ ["Where is Target?", true]];

private _targets = (group player) targets [true, 1000];

private _maxCount = 8;
private _count = 0;
private _page = 1;

{
    if(_count >= _maxCount) then {
        if(_page > 1) then {
            _menuBackName = format["#USER:WTDIF_TARGET_MENU_%1",_page-1];
            _currentMenu pushback ["Back", [], _menuBackName, -2, [[]], "1", "1"];
        };
        _menuNextName = format["#USER:WTDIF_TARGET_MENU_%1",_page+1];
        _currentMenu pushback ["Next", [], _menuNextName, -2, [[]], "1", "1"];
        _menuCurrentName = format["WTDIF_TARGET_MENU_%1",_page];
        missionnamespace setVariable[_menuCurrentName, _currentMenu];
        _currentMenu = [ ["Where is Target?", true]];
        _page = _page + 1;
        _count = 0;
    };

    _displayName = [configFile >> "CfgVehicles" >> typeOf _x] call BIS_fnc_displayName;
    _code = format["[WTDIF_TARGETS select %1, groupSelectedUnits player] call WTDIF_fnc_targetLocation", _count];
    _currentMenu pushback [_displayName, [], "", -5, [["expression", _code]], "1", "1"];

    _count = _count + 1;

}foreach _targets;

if(_page > 1) then {
    _menuBackName = format["#USER:WTDIF_TARGET_MENU_%1",_page-1];
    _currentMenu pushback ["Back", [], _menuBackName, -2, [[]], "1", "1"];
};

private _menuCurrentName = format["WTDIF_TARGET_MENU_%1",_page];
missionnamespace setVariable[_menuCurrentName, _currentMenu];

WTDIF_TARGETS = _targets;

// units are unselected because I am calling a function, not a menu, when selecting "Where is Target?"
// I need to select them again
{
	player groupSelectUnit [_x, true];
} forEach WTDIF_SELECTED_UNITS;

showCommandingMenu "#USER:WTDIF_TARGET_MENU_1";