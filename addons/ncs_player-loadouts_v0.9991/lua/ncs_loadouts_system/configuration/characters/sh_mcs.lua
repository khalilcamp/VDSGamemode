local OBJ = NCS_LOADOUTS.RegisterCharacter("mcs")

function OBJ:GetCharacterID(p)
    return p:GetCharacter()
end

function OBJ:OnCharacterLoaded(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("PlayerLoadedCharacter", function(player, slot)
        CALLBACK(player, slot)
    end)
end

function OBJ:OnCharacterDeleted(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("CharacterDeleted", function(player, slot)
        CALLBACK(player, slot)
    end)
end

function OBJ:OnCharacterChanged(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("PrePlayerLoadedCharacter", function(client, new, old)
        if not old then
            return
        end
        
        if new ~= old then
            CALLBACK(client, new, old)
        end
    end)
end