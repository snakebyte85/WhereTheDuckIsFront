params["_unit", ["_viewer", objNull], ["_distance", 50]];

private _objects = nearestTerrainObjects [_unit, [], _distance];

private _locations = [];

{
    _obj = _x;
    _displayName = "";
    _priority = 1000;

    if(typeOf _obj != "") then {

        // terrain object has a class?
        // display name from hashmap or
        // display name from config
        // priority based on the display name
        // priority based on the map named property
        _displayName = WTDIF_LOCATION_CLASS getOrDefault [typeOf _obj, ""];
        if(_displayName == "") then {
            _displayName = getText (configFile >> 'CfgVehicles' >> typeOf  _obj >> 'displayName'); 
        };
        _priority=WTDIF_LOCATION_PRIORITY getOrDefault [_displayName , -1];

        if(_priority == -1) then {
            _mapProperty = (namedProperties _obj) select {(_x select 0)=="map"};
            if(count _mapProperty >= 1) then {
                _priority = WTDIF_LOCATION_PRIORITY getOrDefault [_mapProperty select 0 select 1 , 0];
            } else {
                _priority = 0;
            };
        };   
        
    } else {

        // edge case rock
        if( (namedProperties _obj) findIf { (_x select 0)=="rock"} > -1 ) then {
            _priority = WTDIF_LOCATION_PRIORITY getOrDefault ["rock", 1000];
            _displayName = "rock";
        } else {

            // getting display name from hashmap based on model info
            _displayName = WTDIF_LOCATION_MODEL getOrDefault [(getModelInfo _obj) select 0, ""];

            _mapProperty = (namedProperties _obj) select {(_x select 0)=="map"};

            // no into hasmap? display name from map named property
            if(_displayName == "" && count _mapProperty >= 1) then {               
                _displayName = _mapProperty select 0 select 1;
            };

            // getting priority from hashmap

            if(_displayName != "") then {
                _priority = WTDIF_LOCATION_PRIORITY getOrDefault [_displayName,-1];
                if(_priority == -1) then {
                    if(count _mapProperty >= 1) then {
                        _priority = WTDIF_LOCATION_PRIORITY getOrDefault [_mapProperty select 0 select 1 , 1000];
                    } else {
                        _priority = 1000;
                    };
                };   
            };
        };
    };
    
    if(_displayName != "") then {
        _locations pushBack [_displayName, position _obj, _unit distance2d _obj, _priority, getModelInfo _obj];
    };

} forEach _objects;

format["Locations before sort are %1", _locations apply { [_x select 0, _x select 2, _x select 3]  }] call WTDIF_fnc_debug;


// sort by weight
_locations= [_locations, [], { (0.4*((_x select 3)/10)) + (0.6*((_x select 2)/_distance)) }, "ASCEND"] call BIS_fnc_sortBy;

format["Locations after sort are %1", _locations apply { [_x select 0, _x select 2, _x select 3]  }] call WTDIF_fnc_debug;

_getDirection = {
    params["_unit", "_viewer", "_objectPos"];
    _viewerDir = _viewer getDirVisual _unit;
    _objectDir = _unit getDirVisual _objectPos;
    _finalDir = 0;
    _direction = "";

    if(_unit distance2d _objectPos < 2) then {
        _direction = "close to";
    } else {

        if(_viewerDir <= 180) then {
            _finalDir = _objectDir - _viewerDir;
        } else {
            _finalDir = (360 - _viewerDir) + _objectDir;
        };

        if(_finalDir < 0) then {
            _finalDir = 360 + _finalDir;
        };
        if(_finalDir >= 360) then {
            _finalDir = 360 - _finalDir;
        };

        format["viewerDir %1, objdir %2, finaldir %3", _viewerDir, _objectDir, _finalDir ] call WTDIF_fnc_debug;

        switch(true) do {
            case (_finalDir >= 340  || _finalDir <= 20 ) : { _direction = "in front of" };
            case (_finalDir <= 200 && _finalDir >= 160) : { _direction = "behind"};
            case (_finalDir > 20 && _finalDir < 160) : { _direction = "left of"};
            case (_finalDir < 340 && _finalDir > 200) : { _direction = "right of"};
        };
    };
    _direction
};

private _text = "";

if( isNull(_viewer) && count _locations > 0 ) then {
    _text = "close to "+ (_locations select 0 select 0);
} else {

    if(count _locations >=2 ) then {
        _location1 = _locations select 0;
        _location2 = _locations select 1;
        _dist1 = _location1 select 2;
        _dist2 = _location2 select 2;

        if( abs(_dist1 - _dist2) > 5) then {
            _location = "";
            if(_dist1 < _dist2) then {
                _location = _location1;
            } else {
                _location = _location2;
            };
            _position = _location select 1;
            _direction = [_unit, _viewer, _position] call _getDirection;
            _name = _location select 0;
            _text = _direction + " " +  _name;
        } else {
            _position1 = _location1 select 1;
            _position2 = _location2 select 1;
            _direction1 = [_unit, _viewer, _position1 ] call _getDirection;
            _direction2 = [_unit, _viewer, _position2 ] call _getDirection;
            _name1 = _location1 select 0;
            _name2 = _location2 select 0;
            if(_direction1 == _direction2 && _name1 == _name2) then {
                _text = _direction1 + " " +  _name1;
            } else {
                _text = _direction1 + " " +  _name1 + " and " + _direction2 + " " + _name2;
            }
        }
    } else {
        if(count _locations == 1 ) then {
            _location = _locations select 0;
            _position = _location select 1;
            _direction = [_unit, _viewer, _position] call _getDirection;
            _name = _location select 0;
            _text = _direction + " " +  _name;
        };
    };
};

_text