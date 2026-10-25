#include "script_mod.hpp"

private _category = 'Where The Duck is Front? VERSION';

[
    "WTDIF_report_direction_system",
    "LIST",
    ["Report Direction System","Choose one of the available report direction systems. Vanilla (left, right, back, front), Compass (North, South etc..), Compass precise (Bearing 135), Clock (2 O'clock)."],
    _category,
    [[0, 1, 2, 3], ["Vanilla", "Compass", "Compass precise", "Clock"], 0]
] call CBA_fnc_addSetting;

[
    "WTDIF_report_direction_visual_aid",
    "CHECKBOX",
    ["Enable Report Direction Visual Aid","Show a visual aid when a target is reported. The visual aid depends on the kind of report direction system chosen."],
    _category,
    true
] call CBA_fnc_addSetting;

[
    "WTDIF_show_bearing_visual_aid",
    "CHECKBOX",
    ["Enable bearing number when Visual Aid is shown","Show the bearing number when compass visual aid is shown."],
    _category,
    true
] call CBA_fnc_addSetting;

[
    "WTDIF_location_system",
    "CHECKBOX",
    ["Enable Location System (ALPHA)","When reporting a target, more info are added to the report based on objects close to the target (houses, poles, fences, walls etc...). WARNING: this is an alpha feature. At this state it's not reliable and most of the map objects need to be registered with a proper name."],
    _category,
    false
] call CBA_fnc_addSetting;

[
    "WTDIF_debug",
    "CHECKBOX",
    ["Enable Debug","Enable Extra Debug logging"],
    _category,
    false
] call CBA_fnc_addSetting;