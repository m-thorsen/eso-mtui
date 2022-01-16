MTUI = {};
MTUI.name = "MTUI";

-- local methods
local function SelectQuickslot(delta)
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

local function SetMasterVolume(level)
    level = tonumber(level);
    SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME, level);
    d("Master volume: "..level);
end;

local function TintCompass(r, g, b)
    ZO_CompassFrameLeft:SetColor(r, g, b, 1);
    ZO_CompassFrameCenter:SetColor(r, g, b, 1);
    ZO_CompassFrameRight:SetColor(r, g, b, 1);
end

local function TightenAttributeBares()
    local offsetX = 70;
    ZO_PlayerAttributeMagicka:ClearAnchors()
    ZO_PlayerAttributeMagicka:SetAnchor(RIGHT, ZO_PlayerAttributeHealth, LEFT, -offsetX, 0);
    ZO_PlayerAttributeStamina:ClearAnchors()
    ZO_PlayerAttributeStamina:SetAnchor(LEFT, ZO_PlayerAttributeHealth, RIGHT, offsetX, 0);
end;

-- Public methods
function MTUI:NextQuickslot()
    SelectQuickslot(1);
end;

function MTUI:PrevQuickslot()
    SelectQuickslot(-1);
end;

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

function MTUI:DecreaseMasterVolume()
    local v = tonumber(GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME));

    if (v == 0) then return;
    elseif (v > 75) then SetMasterVolume(75);
    elseif (v > 50) then SetMasterVolume(50);
    elseif (v > 25) then SetMasterVolume(25);
    else SetMasterVolume(0);
    end;
end;

function MTUI:IncreaseMasterVolume()
    local v = tonumber(GetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AUDIO_VOLUME));

    if (v == 100) then return;
    elseif (v < 25) then SetMasterVolume(25);
    elseif (v < 50) then SetMasterVolume(50);
    elseif (v < 75) then SetMasterVolume(75);
    else SetMasterVolume(100);
    end;
end;

-- init
function MTUI:Initialize()
    function KEYBINDING_MANAGER:IsChordingAlwaysEnabled()
        return true;
    end;

    SetCVar('SkipPregameVideos', '1');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_INCREASE_MASTER_VOLUME', 'Increase master volume');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_DECREASE_MASTER_VOLUME', 'Decrease master volume');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_TOGGLE_MUSIC', 'Toggle music');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_NEXT_QUICKSLOT', 'Next quickslot');
    ZO_CreateStringId('SI_BINDING_NAME_MTUI_PREV_QUICKSLOT', 'Previous quickslot')

    EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_PLAYER_ACTIVATED, function()
        ZO_ActionButtons_ToggleShowGlobalCooldown();
        TightenAttributeBares();
    end);

    EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_PLAYER_COMBAT_STATE, function(_, inCombat)
        if inCombat then
            TintCompass(1, 0.4, 0.25);
        else
            TintCompass(1, 1, 1);
        end
    end);
end;

EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_ADD_ON_LOADED, function(_, addonName)
    if (addonName == MTUI.name) then
        MTUI:Initialize();
    end
end);
