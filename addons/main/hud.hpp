
class RscTitles {

    class RscText;

    class DirectionHUD {
        idd = 9999;
        duration = 8;
        fadeIn = 0;
        fadeOut = 2;
        onLoad = "uiNamespace setVariable ['WTDIF_DirectionHUD', _this select 0];";
        
        class controls {   

            // Rotating arrow pointer
            class HUD_Background {
                idc = 9993;
                type = 0;
                style = 0; // ST_SINGLE
                text = "";
                x = "0.075 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.05 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {0, 0, 0, 0.8};
                colorBackground[] = {0, 0, 0, 0.8};
                font = "RobotoCondensed";
                sizeEx = 0;
            };

            // Rotating arrow pointer
            class HUD_Arrow {
                idc = 9992;
                type = 0;
                style = 48 + 2048; // ST_PICTURE + ST_KEEP_ASPECT_RATIO
                text = "z\WTDIF\addons\main\direction.paa";
                x = "0.05 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.10 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.5};
                font = "RobotoCondensed";
                sizeEx = 0;
            };         
            
        };
    };

    class CompassHUD {
        idd = 9999;
        duration = 8;
        fadeIn = 0;
        fadeOut = 2;
        onLoad = "uiNamespace setVariable ['WTDIF_CompassHUD', _this select 0];";
        
        class controls {

            // Rotating arrow pointer
            class HUD_Background {
                idc = 9993;
                type = 0;
                style = 0; // ST_SINGLE
                text = "";
                x = "0.075 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.05 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {0, 0, 0, 0.8};
                colorBackground[] = {0, 0, 0, 0.8};
                font = "RobotoCondensed";
                sizeEx = 0;
            };

            // Rotating arrow pointer
            class HUD_Arrow {
                idc = 9992;
                type = 0;
                style = 48 + 2048; // ST_PICTURE + ST_KEEP_ASPECT_RATIO
                text = "z\WTDIF\addons\main\compass.paa";
                x = "0.05 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.10 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.5};
                font = "RobotoCondensed";
                sizeEx = 0;
            };
            
            class BearingText: RscText {
                idc = 1001;
                type = 0;                       // CT_STATIC = 0
                style = 0;    
                x = "0.086 * safeZoneW + safeZoneX";
                y = "0.625 * safeZoneH + safeZoneY";
                w = "0.05 * safeZoneW";
                h = "0.05 * safeZoneH";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.0};
                text = "test";
                font = "RobotoCondensed";
                sizeEx = 0.04;
            };

        };
    };

    class ClockHUD {
        idd = 9999;
        duration = 8;
        fadeIn = 0;
        fadeOut = 2;
        onLoad = "uiNamespace setVariable ['WTDIF_ClockHUD', _this select 0];";
        
        class controls {   

            // Rotating arrow pointer
            class HUD_Background {
                idc = 9993;
                type = 0;
                style = 0; // ST_SINGLE
                text = "";
                x = "0.075 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.05 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {0, 0, 0, 0.8};
                colorBackground[] = {0, 0, 0, 0.8};
                font = "RobotoCondensed";
                sizeEx = 0;
            };

            // Rotating arrow pointer
            class HUD_Arrow {
                idc = 9992;
                type = 0;
                style = 48 + 2048; // ST_PICTURE + ST_KEEP_ASPECT_RATIO
                text = "z\WTDIF\addons\main\clock.paa";
                x = "0.05 * safeZoneW + safeZoneX";
                y = "0.60 * safeZoneH + safeZoneY";
                w = "0.10 * safeZoneW";
                h = "0.10 * safeZoneH";
                colorText[] = {1, 1, 1, 1};
                colorBackground[] = {0, 0, 0, 0.5};
                font = "RobotoCondensed";
                sizeEx = 0;
            };         
            
        };
    };
};
