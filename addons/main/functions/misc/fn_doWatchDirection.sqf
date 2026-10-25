params ["_unit", "_direction"];

// 1. Calculate the relative X and Y offsets using sin and cos
private _xOffset = sin _direction;
private _yOffset = cos _direction;

// 2. Get the unit's current position
private _unitPos = getPosWorld _unit;

// 3. Create a target position 10 meters away in that direction
private _targetPos = [
    (_unitPos select 0) + (_xOffset * 10), 
    (_unitPos select 1) + (_yOffset * 10), 
    (_unitPos select 2) + ((eyepos _unit) select 2) // Eye-level height
];

// 4. Command the unit to watch the calculated position
_unit doWatch _targetPos;