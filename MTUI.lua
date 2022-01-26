MTUI = {};
MTUI.name = "MTUI";
MTUI.initialized = false;

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

local function MoveFrames()
    ZO_ActiveCombatTipsTip:ClearAnchors();
    ZO_ActiveCombatTipsTip:SetAnchor(CENTER, GuiRoot, CENTER, 0, -100);

    ZO_SynergyTopLevelContainer:ClearAnchors();
    ZO_SynergyTopLevelContainer:SetAnchor(CENTER, GuiRoot, CENTER, 0, 100);

    ZO_FocusedQuestTrackerPanel:ClearAnchors();
    ZO_FocusedQuestTrackerPanel:SetAnchor(TOPRIGHT, GuiRoot, TOPRIGHT, 0, 260);

    local attributeSpacing = 50;
    ZO_PlayerAttributeMagicka:ClearAnchors()
    ZO_PlayerAttributeMagicka:SetAnchor(RIGHT, ZO_PlayerAttributeHealth, LEFT, -attributeSpacing, 0);
    ZO_PlayerAttributeStamina:ClearAnchors()
    ZO_PlayerAttributeStamina:SetAnchor(LEFT, ZO_PlayerAttributeHealth, RIGHT, attributeSpacing, 0);
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

local function LimitInteractions()
    local function ShouldDenyInteraction()
        local action, name, interactionBlocked, isOwned, additionalInteractInfo, context, contextLink, isCrime = GetGameCameraInteractableActionInfo();

        if (name ~= '' and name ~= nil and not IsControlKeyDown()) then
            if (interactionBlocked and additionalInteractInfo == ADDITIONAL_INTERACT_INFO_EMPTY) then return true end;
            if (name == GetUnitName("companion")) then return true end;
            if (IsUnitFriendlyFollower("interact")) then return true end;
            if (isCrime) then return true end;
        end;

        return false;
    end;

    local DoInteraction = FISHING_MANAGER.StartInteraction;

    FISHING_MANAGER.StartInteraction = function(...)
        return ShouldDenyInteraction() or DoInteraction(...);
    end;

    ZO_PreHook(RETICLE, "TryHandlingInteraction", function(interactionPossible)
        return interactionPossible and ShouldDenyInteraction();
    end);
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

    ZO_ActionButtons_ToggleShowGlobalCooldown();

    MoveFrames();
    LimitInteractions();

    EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_PLAYER_COMBAT_STATE, function(_, inCombat)
        if (inCombat) then
            TintCompass(1, 0.4, 0.25);
        else
            TintCompass(1, 1, 1);
        end
    end);

    MTUI.initialized = true;
end;

EVENT_MANAGER:RegisterForEvent(MTUI.name, EVENT_ADD_ON_LOADED, function(_, addonName)
    if (addonName == MTUI.name and not MTUI.initialized) then
        MTUI:Initialize();
    end
end);

SLASH_COMMANDS["/leave"] = function()
    if not IsUnitGrouped("player") then
        return;
    end;
    GroupLeave();
end;
