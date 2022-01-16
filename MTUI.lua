MTUI = {};

function MTUI:ToggleMusic()
    local s = GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_MUSIC_ENABLED);
	if (s == "1") then
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_MUSIC_ENABLED, "0");
		d("Music disabled");
	else
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_MUSIC_ENABLED, "1");
		d("Music enabled");
	end;
end;

function MTUI:SetMasterVolume(level)
    level = tonumber(level);
    SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME, level);
    d("Master volume: "..level);
end;

function MTUI:DecreaseMasterVolume()
    local v = tonumber(GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME));

    if (v == 0) then return;
    elseif (v > 75) then MTUI:SetMasterVolume(75);
    elseif (v > 50) then MTUI:SetMasterVolume(50);
    elseif (v > 25) then MTUI:SetMasterVolume(25);
    else MTUI:SetMasterVolume(0);
    end;
end;

function MTUI:IncreaseMasterVolume()
    local v = tonumber(GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME));

    if (v == 100) then return;
    elseif (v < 25) then MTUI:SetMasterVolume(25);
    elseif (v < 50) then MTUI:SetMasterVolume(50);
    elseif (v < 75) then MTUI:SetMasterVolume(75);
    else MTUI:SetMasterVolume(100);
    end;
end;

function MTUI:SelectQuickslot(delta)
    local slots = { 12, 11, 10, 9, 16, 15, 14, 13 };
    local curr = GetCurrentQuickslot();
    local index;

    for i, v in pairs(slots) do
        if v == curr then index = i + delta end;
    end;

    if (index > 8) then index = 1 end;
    if (index < 1) then index = 8; end;

    SetCurrentQuickslot(slots[index]);
    PlaySound("Click_Positive");
end;

function MTUI:NextQuickslot()
    MTUI:SelectQuickslot(1);
end;

function MTUI:PrevQuickslot()
    MTUI:SelectQuickslot(-1);
end;

-- Update attribute bars offsetX based on the shift set in settings.
local function UpdateAttributeBarsOffsetX()
    local offsetX = 70;
    ZO_PlayerAttributeMagicka:ClearAnchors()
    ZO_PlayerAttributeMagicka:SetAnchor(RIGHT, ZO_PlayerAttributeHealth, LEFT, -offsetX, 0);
    ZO_PlayerAttributeStamina:ClearAnchors()
    ZO_PlayerAttributeStamina:SetAnchor(LEFT, ZO_PlayerAttributeHealth, RIGHT, offsetX, 0);
end;

EVENT_MANAGER:RegisterForEvent("MTUI_OnLoad", EVENT_ADD_ON_LOADED, function()
    function KEYBINDING_MANAGER:IsChordingAlwaysEnabled()
        return true;
    end;

    SetCVar('SkipPregameVideos', '1');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_INCREASE_MASTER_VOLUME', 'Increase master volume');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_DECREASE_MASTER_VOLUME', 'Decrease master volume');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_TOGGLE_MUSIC', 'Toggle music');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_NEXT_QUICKSLOT', 'Next quickslot');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_PREV_QUICKSLOT', 'Previous quickslot')
end);

EVENT_MANAGER:RegisterForEvent('MTUI_OnPlayerActive', EVENT_PLAYER_ACTIVATED, function()
    ZO_ActionButtons_ToggleShowGlobalCooldown();
    UpdateAttributeBarsOffsetX();
end);

