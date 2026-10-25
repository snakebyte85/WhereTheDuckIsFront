private _fromMenu = [ ["Spotting - From direction", true]];

private _code = "_pos = screenToWorld[0.5,0.5];
    _dir = player getDirVisual _pos;
    missionnamespace setVariable['WTDIF_spotting_from', _dir];
    [] spawn { 
        {
            player groupSelectUnit [_x, true];
        } forEach WTDIF_SELECTED_UNITS;
         showCommandingMenu '#USER:WTDIF_SPOTTING_MENU_TO';
    };";

_fromMenu pushback ["From", [], "", -5, [["expression", _code]], "1", "1"];
missionnamespace setVariable["WTDIF_SPOTTING_MENU_FROM", _fromMenu];


private _toMenu = [ ["Spotting - To direction", true]];
_code = "_pos = screenToWorld[0.5,0.5];
    _to = player getDirVisual _pos;
    _from = missionnamespace getVariable 'WTDIF_spotting_from';
    [groupSelectedUnits player select 0, _from, _to ] spawn WTDIF_fnc_spotOrder;";
_toMenu pushback ["To", [], "", -5, [["expression", _code]], "1", "1"];
missionnamespace setVariable["WTDIF_SPOTTING_MENU_TO", _toMenu];

// units are unselected because I am calling a function, not a menu, when selecting "Where is Target?"
// I need to select them again
{
	player groupSelectUnit [_x, true];
} forEach WTDIF_SELECTED_UNITS;

showCommandingMenu "#USER:WTDIF_SPOTTING_MENU_FROM";