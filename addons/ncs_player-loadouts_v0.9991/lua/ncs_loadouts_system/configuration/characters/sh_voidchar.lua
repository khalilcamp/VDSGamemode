local OBJ = NCS_LOADOUTS.RegisterCharacter("voidchar")

function OBJ:GetCharacterID(p)
    return tonumber(p:GetCharacterID())
end

function OBJ:OnCharacterLoaded(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("VoidChar.CharacterSelected", function(ply, charobj)
        if not IsValid(ply) then
            return
        end

        local slot = tonumber(charobj.id)

        CALLBACK(ply, slot)
    end)
end

function OBJ:OnCharacterDeleted(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("VoidChar.CharacterDeleted", function(player, charobj)
        CALLBACK(player, tonumber(charobj.id))
    end)
end

function OBJ:OnCharacterChanged(CALLBACK)
    NCS_LOADOUTS.AddCharacterHook("VoidChar.CharacterSelected", function(client, new, old)
        if not old then
            return
        end

        if new ~= old then
            CALLBACK(client, tonumber(new.id), tonumber(old.id))
        end
    end)
end