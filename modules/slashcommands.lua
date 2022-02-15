function MTUI:EnableSlashCommands()
    SLASH_COMMANDS["/leave"] = function()
        if not IsUnitGrouped("player") then
            return;
        end;
        GroupLeave();
    end;

    SLASH_COMMANDS["/rl"] = function()
        ReloadUI();
    end;
end;
