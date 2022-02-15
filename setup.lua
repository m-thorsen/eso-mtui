MTUI = {};
MTUI.name = "MTUI";
MTUI.initialized = false;

-- init
EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_ADD_ON_LOADED, function(_, addonName)
    if (addonName == MTUI.name and not MTUI.initialized) then
        SetCVar('SkipPregameVideos', '1');
        ZO_ActionButtons_ToggleShowGlobalCooldown();

        MTUI:EnableLayout();
        MTUI:EnableInteractionLimiter();
        MTUI:EnableKeybinds();
        MTUI:EnableCombatCompass();
        MTUI:EnableSlashCommands();

        MTUI.initialized = true;
    end;
end);




