if RDV.COMMUNICATIONS and RDV.COMMUNICATIONS.LOADED then return end

function RDV.COMMUNICATIONS.AddPassiveChannel(P, channel)
    if IsValid(P) then
        P = P:EntIndex()
    end

    RDV.COMMUNICATIONS.PASSIVE[P] = RDV.COMMUNICATIONS.PASSIVE[P] or {}
    RDV.COMMUNICATIONS.SPASSIVE[P] = RDV.COMMUNICATIONS.SPASSIVE[P] or {}

    if RDV.COMMUNICATIONS.PASSIVE[P][channel] then
        return
    end

    table.insert(RDV.COMMUNICATIONS.SPASSIVE[P], channel)

    RDV.COMMUNICATIONS.PASSIVE[P][channel] = true

    net.Start("RDV_COMMS_SetPassive")
        net.WriteUInt(P, 8)
        net.WriteString(channel)
        net.WriteBool(true)
    net.Broadcast()

    hook.Run("RDV_COMMS_JoinPassiveChannel", P, channel)
end

function RDV.COMMUNICATIONS.RemovePassiveChannel(P, channel)
    if IsValid(P) then
        P = P:EntIndex()
    end

    RDV.COMMUNICATIONS.PASSIVE[P] = RDV.COMMUNICATIONS.PASSIVE[P] or {}
    RDV.COMMUNICATIONS.SPASSIVE[P] = RDV.COMMUNICATIONS.SPASSIVE[P] or {}

    if !RDV.COMMUNICATIONS.PASSIVE[P][channel] then
        return
    end

    for k, v in ipairs(RDV.COMMUNICATIONS.SPASSIVE[P]) do
        if ( v == channel ) then
            table.remove(RDV.COMMUNICATIONS.SPASSIVE[P], k)
        end
    end
    
    RDV.COMMUNICATIONS.PASSIVE[P][channel] = nil

    net.Start("RDV_COMMS_SetPassive")
        net.WriteUInt(P, 8)
        net.WriteString(channel)
        net.WriteBool(false)
    net.Broadcast()

    hook.Run("RDV_COMMS_LeavePassiveChannel", P, channel)
end

--[[---------------------------------]]--
--  Exit Channel
--[[---------------------------------]]--

function RDV.COMMUNICATIONS.ExitCurrentChannel(ply, network)
    if !IsValid(ply) then return end

    local CURRENT = RDV.COMMUNICATIONS.GetActiveChannel(ply)

    if !CURRENT then
        return
    end

    RDV.COMMUNICATIONS.ACTIVE[ply] = false

    --
    --  Remove from Players Table.
    --

    local TAB = RDV.COMMUNICATIONS.Players
    local COUNT = #TAB

    local UID = ply:EntIndex()

    for i = 1, COUNT do
        if !TAB[i] then
            continue
        end

        if ( TAB[i].UID == UID ) then
            table.remove(RDV.COMMUNICATIONS.Players, i)
        end
    end

    --
    --  Network
    --

    if network then
        net.Start("RDV_COMMS_Disconnect")
            net.WriteUInt(ply:EntIndex(), 8)
        net.Broadcast()
    end
end

--[[---------------------------------]]--
--  Change Channel
--[[---------------------------------]]--

function RDV.COMMUNICATIONS.SetChannel(P, CHANNEL)
    if !IsValid(P) or !CHANNEL then return end

    local ACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(P)

    if ( CHANNEL == ACTIVE ) then
        return
    end

    --
    -- Don't allow players to connect to passive channels.
    --

    local PASSIVE = RDV.COMMUNICATIONS.GetPassiveChannels(P)

    if PASSIVE[CHANNEL] then
        return
    end

    --
    -- Remove Active Channel.
    --

    local TAB = RDV.COMMUNICATIONS.Players
    local COUNT = #TAB

    local UID = P:EntIndex()

    for i = 1, COUNT do
        if !TAB[i] or !TAB[i].UID then
            continue
        end
        
        if ( TAB[i].UID == UID ) then
            table.remove(RDV.COMMUNICATIONS.Players, i)
        end
    end

    --
    -- Set the Active Channel.
    --

    hook.Run("RDV_COMMS_PreChannelConnect", P, CHANNEL)

    RDV.COMMUNICATIONS.Players = RDV.COMMUNICATIONS.Players or {}

    local INSERTED = table.insert(RDV.COMMUNICATIONS.Players, {
        Client = P,
        UID = P:EntIndex(),
        Channel = CHANNEL,
    })

    RDV.COMMUNICATIONS.ACTIVE[P] = CHANNEL

    net.Start("RDV_COMMS_Connect")
        net.WriteUInt(P:EntIndex(), 8)
        net.WriteString(CHANNEL)
    net.Broadcast()

    hook.Run("RDV_COMMS_PostChannelConnect", P, CHANNEL)
end