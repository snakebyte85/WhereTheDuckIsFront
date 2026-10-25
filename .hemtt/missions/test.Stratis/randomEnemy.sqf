_enemies = ["O_officer_F", "O_soldier_M_F", "O_crew_f"];
_group = createGroup east;
_radius = 100;
_position = (position player) getPos [_radius * sqrt random 1, random 360];

(selectRandom _enemies) createUnit [_position, _group, 'this disableAI "FIREWEAPON"'];