if RDV.COMMUNICATIONS and RDV.COMMUNICATIONS.LOADED then return end

net.Receive("RDV_COMMS_SetPassive", function()
    local UID = net.ReadUInt(8)
    local CHN = net.ReadString()
    local STA = net.ReadBool()

    local P = Entity(UID)
    
    if !IsValid(P) or !P:IsPlayer() then return end

    RDV.COMMUNICATIONS.PASSIVE[UID] = RDV.COMMUNICATIONS.PASSIVE[UID] or {}
    RDV.COMMUNICATIONS.SPASSIVE[UID] = RDV.COMMUNICATIONS.SPASSIVE[UID] or {}

    RDV.COMMUNICATIONS.OCCUPANTS[CHN] = RDV.COMMUNICATIONS.OCCUPANTS[CHN] or 0

    if STA then
        table.insert(RDV.COMMUNICATIONS.SPASSIVE[UID], CHN)

        RDV.COMMUNICATIONS.PASSIVE[UID][CHN] = true

        RDV.COMMUNICATIONS.OCCUPANTS[CHN] = RDV.COMMUNICATIONS.OCCUPANTS[CHN] + 1
    else
        for k, v in ipairs(RDV.COMMUNICATIONS.SPASSIVE[UID]) do
            if ( CHN == v ) then
                table.remove(RDV.COMMUNICATIONS.SPASSIVE[UID], k)
                break
            end
        end

        RDV.COMMUNICATIONS.PASSIVE[UID][CHN] = nil

        RDV.COMMUNICATIONS.OCCUPANTS[CHN] = RDV.COMMUNICATIONS.OCCUPANTS[CHN] - 1
    end
end )

net.Receive("RDV_COMMS_SendPassive", function()
    local PCOUNT = net.ReadUInt(8)

    for i = 1, PCOUNT do
        local P = net.ReadUInt(8)
        local T = net.ReadTable()

        RDV.COMMUNICATIONS.PASSIVE[P] = RDV.COMMUNICATIONS.PASSIVE[P] or {}
        RDV.COMMUNICATIONS.SPASSIVE[P] = RDV.COMMUNICATIONS.SPASSIVE[P] or {}

        for k, v in ipairs(T) do
            RDV.COMMUNICATIONS.OCCUPANTS[v] = RDV.COMMUNICATIONS.OCCUPANTS[v] or 0

            RDV.COMMUNICATIONS.OCCUPANTS[v] = RDV.COMMUNICATIONS.OCCUPANTS[v] + 1

            RDV.COMMUNICATIONS.PASSIVE[P][v] = true
        end

        RDV.COMMUNICATIONS.SPASSIVE[P] = T
    end
end)

net.Receive("RDV_COMMS_ClearPassive", function()
    local P = net.ReadUInt(8)

    RDV.COMMUNICATIONS.PASSIVE[P] = RDV.COMMUNICATIONS.PASSIVE[P] or {}
    RDV.COMMUNICATIONS.SPASSIVE[P] = RDV.COMMUNICATIONS.SPASSIVE[P] or {}

    for k, v in ipairs(RDV.COMMUNICATIONS.SPASSIVE[P]) do
        RDV.COMMUNICATIONS.OCCUPANTS[v] = RDV.COMMUNICATIONS.OCCUPANTS[v] or 0

        RDV.COMMUNICATIONS.OCCUPANTS[v] = RDV.COMMUNICATIONS.OCCUPANTS[v] - 1
    end

    RDV.COMMUNICATIONS.PASSIVE[P] = nil
    RDV.COMMUNICATIONS.SPASSIVE[P] = nil
end )