local OBJ = NCS_DATAPAD.RegisterCharacter("nutscript")

function OBJ:GetCharacterID(p)
    return p:getChar():getID()
end

function OBJ:OnCharacterLoaded(CALLBACK)
    NCS_DATAPAD.AddCharacterHook("CharacterLoaded", function(SLOT)
        local CHAR = nut.char.loaded[SLOT]

        local CLIENT = CHAR:getPlayer()

        if not IsValid(CLIENT) then
            return
        end

        CALLBACK(CLIENT, SLOT)
    end)
end

function OBJ:OnCharacterDeleted(CALLBACK)
    NCS_DATAPAD.AddCharacterHook("OnCharacterDelete", function(CLIENT, SLOT)
        CALLBACK(CLIENT, SLOT)
    end)
end

function OBJ:OnCharacterChanged(CALLBACK)
    NCS_DATAPAD.AddCharacterHook("PlayerLoadedChar", function(client, new, old)
        if not old then
            return
        end

        if new ~= old then
            CALLBACK(client, new:getID(), old:getID())
        end
    end)
end