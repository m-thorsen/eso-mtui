function MTUI:EnableLayout()
    ZO_ActiveCombatTips:ClearAnchors();
    ZO_ActiveCombatTips:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, -300);

    -- ZO_SynergyTopLevelContainer:ClearAnchors();
    -- ZO_SynergyTopLevelContainer:SetAnchor(CENTER, GuiRoot, CENTER, 0, 50);

    ZO_FocusedQuestTrackerPanel:ClearAnchors();
    ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, 260);

    local attributeSpacing = 50;
    ZO_PlayerAttributeMagicka:ClearAnchors()
    ZO_PlayerAttributeMagicka:SetAnchor(RIGHT, ZO_PlayerAttributeHealth, LEFT, -attributeSpacing, 0);
    ZO_PlayerAttributeStamina:ClearAnchors()
    ZO_PlayerAttributeStamina:SetAnchor(LEFT, ZO_PlayerAttributeHealth, RIGHT, attributeSpacing, 0);
end;
