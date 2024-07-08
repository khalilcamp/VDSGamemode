
util.AddNetworkString("RDV_COMMS_SendPassive")
util.AddNetworkString("RDV_COMMS_Disconnect")
util.AddNetworkString("RDV_COMMS_Connect")
util.AddNetworkString("RDV_COMMS_Sync")
util.AddNetworkString("RDV_COMMS_RemoveChannel")
util.AddNetworkString("RDV_COMMS_SetPassive")
util.AddNetworkString("RDV_COMMS_ClearPassive")
util.AddNetworkString("RDV_COMMS_MUTE")

--
util.AddNetworkString("RDV.COMMUNICATIONS.SendCommsMessage")
util.AddNetworkString("RDV.COMMUNICATIONS.RelayToggled")
util.AddNetworkString("RDV.COMMUNICATIONS.OpenConfig")
util.AddNetworkString("RDV.COMMUNICATIONS.CreateChannel")
util.AddNetworkString("RDV_COMMUNICATIONS_Talking")
--

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local COL = CFG.chatColor
    local PRE = CFG.chatPrefix
	
    RDV.LIBRARY.AddText(ply, COL, "["..PRE.."] ", color_white, msg)
end

net.Receive("RDV_COMMS_Disconnect", function(len, ply)
    local CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(ply)

    local CAN = hook.Run("RDV_COMMS_PreChannelDisconnect", ply, CHANNEL)
    if (CAN == false) then return end

    RDV.COMMUNICATIONS.ExitCurrentChannel(ply, true)

    hook.Run("RDV_COMMS_PostChannelDisconnect", ply, CHANNEL)
end)

net.Receive("RDV_COMMS_MUTE", function(len, ply)
    RDV.COMMUNICATIONS.MUTED[ply] = !RDV.COMMUNICATIONS.MUTED[ply]
end)

local DELAY = {}

net.Receive("RDV_COMMS_Connect", function(len, ply)
    if DELAY[ply] and DELAY[ply] > CurTime() then
        return
    end

    local CHANNEL = net.ReadString()

    if !RDV.COMMUNICATIONS.CanAccessChannel(ply, CHANNEL) then
        return
    end

    local CAN = RDV.COMMUNICATIONS.SetChannel(ply, CHANNEL)

    if CAN then
        local LChannel = RDV.LIBRARY.GetLang(nil, "COMMS_switchedChannel", {
            CHANNEL,
        })

        SendNotification(ply, LChannel)
    end

    DELAY[ply] = CurTime() + 2
end)

net.Receive("RDV_COMMS_SetPassive", function(_, P)
    if DELAY[P] and DELAY[P] > CurTime() then
        return
    end

    local CHANNEL = net.ReadString()

    if !RDV.COMMUNICATIONS.LIST[CHANNEL] then
        return
    end

    if !RDV.COMMUNICATIONS.CanAccessChannel(P, CHANNEL) then
        return
    end

    local STATUS = net.ReadBool()
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if STATUS then
        if ( table.Count(RDV.COMMUNICATIONS.GetPassiveChannels(P)) ) < RDV.COMMUNICATIONS.S_CFG.passiveChannelCount then
            RDV.COMMUNICATIONS.AddPassiveChannel(P, CHANNEL)
        end
    else
        RDV.COMMUNICATIONS.RemovePassiveChannel(P, CHANNEL)
    end

    DELAY[P] = CurTime() + 2
end )
