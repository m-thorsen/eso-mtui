function MTUI:EnableInteractionLimiter()
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
