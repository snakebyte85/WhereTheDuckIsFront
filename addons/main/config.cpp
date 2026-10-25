#include "script_component.hpp"

class CfgPatches
{
	class ADDON
	{
		name = CSTRING(component);
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = { "CBA_main" };
		author = "snakebyte";
		url = "https://community.bistudio.com/wiki";
		VERSION_CONFIG;
	};
};

#define BASE_PATH_FN MAINPREFIX\PREFIX\addons\COMPONENT\functions


class CfgFunctions {
    class PREFIX {
        
        class misc {
            file = QUOTE(BASE_PATH_FN\misc);
            class debug {};
            class radioChat{};
            class location{};
            class initLocationHashmap{};
            class initHandleRadioChat{};
            class typeOfDirection{};
            class getDirectionApprox{};
            class createTargetMenu{};
            class targetLocation{};
            class reportDirection{};
            class spotOrder{};
            class doWatchDirection{};
            class reportDistance{};
            class revealTarget{};
            class getUnitNumberInWord{};
            class createSpottingMenu{};
        };
        
    };
};

class Extended_PostInit_EventHandlers {
    class PREFIX_post_init {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_PreInit_EventHandlers {
	class PREFIX_pre_init {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

#include "hud.hpp"

class RscGroupRootMenu
{
    class Items
    {
        class ReportDistance {
            enable="NotEmpty";
            shortcuts[] ={0};
            speechId = 0;
            title = "How far is it?";
            show = "IsLeader * CursorOnEnemy";
            command=-5;
            class params
            {
                expression="_unit = (groupSelectedUnits player) select 0; _result = [_target, _unit] call WTDIF_fnc_reportDistance; [_unit, _result select 0, _result select 1] spawn WTDIF_fnc_radioChat";
            };
        };

        class Spotting {
            enable="NotEmpty";
            shortcuts[] ={0};
            speechId = 0;
            title = "Start spotting that direction";
            show = "IsLeader * CursonOnGround";
            command=-5;
            class params
            {
                expression="_direction = player getDir (screenToWorld [0.5, 0.5]); [(groupSelectedUnits player) select 0, _direction, _direction ] spawn WTDIF_fnc_spotOrder";
            };
        };


    };

};

class RscSubmenu;
class RscMenuEngage: RscSubmenu
{
    class Items
    {
        class LookAround 
        {
            enable="NotEmpty";
            shortcuts[] ={8};
            speechId = 0;
            title = "Spotting with binoculars";
            show = "IsLeader";
            command=-5;
            class params
            {
                expression="WTDIF_SELECTED_UNITS=groupSelectedUnits player; [] spawn WTDIF_fnc_createSpottingMenu";
            };
        };
    };
};

class RscMenuStatus: RscSubmenu
{
    class Items
    {
        class Status_Separator1
        {
            title="";
            shortcuts[]={};
            submenu="";
            command=-1;
            class params
            {
                expression="";
            };
            show="1";
            enable="1";
            speechId=0;
        };
        class Status_WhereIsTarget
        {
            title="Where is Target?";
            shortcuts[]={};
            submenu="";
            command=-5;
            class params
            {
                expression="WTDIF_SELECTED_UNITS=groupSelectedUnits player; [] spawn WTDIF_fnc_createTargetMenu";
            };
            show="1";
            enable="isLeader * NotEmpty";
            speechId=0;
        };
    };
};