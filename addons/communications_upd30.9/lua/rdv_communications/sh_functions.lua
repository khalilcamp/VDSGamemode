
function RDV.COMMUNICATIONS.GetPassiveChannels(P)
    if IsValid(P) then
        P = P:EntIndex()
    end

    RDV.COMMUNICATIONS.PASSIVE[P] = RDV.COMMUNICATIONS.PASSIVE[P] or {}

    return RDV.COMMUNICATIONS.PASSIVE[P] or {}
end

function RDV.COMMUNICATIONS.GetActiveChannel(P)
    if !RDV.COMMUNICATIONS.Players then
        return false
    end

    if CLIENT then
        if IsValid(P) then
            P = P:EntIndex()
        end
        
        if !RDV.COMMUNICATIONS.Players[P] then
            return false
        else
            return RDV.COMMUNICATIONS.Players[P]
        end
    else
        return RDV.COMMUNICATIONS.ACTIVE[P]
    end
end

function RDV.COMMUNICATIONS.CanAccessChannel(ply, channel)
    local LIST = RDV.COMMUNICATIONS.LIST[channel]

    if !LIST then
        return
    end

    if LIST.CustomCheck then
        local CHECK = LIST.CustomCheck(ply)

        if CHECK ~= nil then
            return CHECK
        end
    end

    if LIST.Factions and !table.IsEmpty(LIST.Factions) then
        if !LIST.Factions[team.GetName(ply:Team())] then
            return false
        end
    end

    local HOOK = hook.Run("RDV_COMMS_CanAccessChannel", ply, channel)

    if ( HOOK == false ) then
        return false
    end

    return true
end

function RDV.COMMUNICATIONS.GetMemberCount(CHANNEL)
    if CLIENT then
        local TAB = RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL]

        if !TAB then
            return 0
        else
            return TAB
        end
    end
end

function RDV.COMMUNICATIONS.GetCommsEnabled(P)
    if !IsValid(P) then return false end

    if CLIENT then 
        if ( RDV.COMMUNICATIONS.RELAY == false ) then 
            return false 
        else
            return true
        end
    else
        local COUNT = 0

        for k, v in pairs(RDV.COMMUNICATIONS.RELAYS) do
            if v.TEAMS and v.TEAMS[team.GetName(P:Team())] then
                COUNT = COUNT + 1

                if ( v.ENABLED == true ) then
                    return true
                end
            end
        end

        if COUNT <= 0 then
            return true
        end

        return false
    end
end

function RDV.COMMUNICATIONS.GetChannelColor(ID)
    if !RDV.COMMUNICATIONS.LIST[ID] then
        return Color(255,255,255)
    end

    return RDV.COMMUNICATIONS.LIST[ID].Color or Color(255,255,255)
end