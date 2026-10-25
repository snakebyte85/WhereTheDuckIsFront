
params ["_caller","_msg", ["_words",[]]];

if ( !(_caller kbHasTopic "Radio") ) then {
    _caller kbAddTopic["Radio","z\WTDIF\addons\main\radio.bikb"];
};

_caller kbTell[_caller, "Radio", "Radio", ["Msg", {}, _msg, _words], true];
