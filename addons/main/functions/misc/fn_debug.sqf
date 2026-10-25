
params ["_msg"];

    if(WTDIF_debug) then {
        _finalMsg = format['[WTDIF]-> %1', _msg];
        systemChat _finalMsg;
        diag_log _finalMsg;
    };

