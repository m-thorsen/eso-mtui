local function TintCompass(r, g, b)
    ZO_CompassFrameLeft:SetColor(r, g, b, 1);
    ZO_CompassFrameCenter:SetColor(r, g, b, 1);
    ZO_CompassFrameRight:SetColor(r, g, b, 1);
end;

function MTUI:EnableCombatCompass()
    EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_PLAYER_COMBAT_STATE, function(_, inCombat)
        if (inCombat) then
            TintCompass(1, 0.4, 0.25);
        else
            TintCompass(1, 1, 1);
        end
    end);
end;
