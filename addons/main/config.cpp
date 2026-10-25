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

class RscSubmenu;
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