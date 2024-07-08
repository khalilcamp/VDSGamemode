--[[---------------------------------]]--
--  Loadout
--[[---------------------------------]]--

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG
    local COL = Color(CFG.chatColor.r, CFG.chatColor.g, CFG.chatColor.b)

    RDV.LIBRARY.AddText(ply, COL, "["..CFG.chatPrefix.."] ", color_white, msg)
end

local function CanAccess(P)
    if !IsValid(P) then return end
    
    local PASSIVE = RDV.COMMUNICATIONS.SPASSIVE[P]

    if PASSIVE then
        for k, v in ipairs(PASSIVE) do
            if RDV.COMMUNICATIONS.CanAccessChannel(P, v) then
                continue
            end

            RDV.COMMUNICATIONS.RemovePassiveChannel(P, v)
        end
    end

    local ACT = RDV.COMMUNICATIONS.GetActiveChannel(P)

    if !ACT then
        return
    end

    if !RDV.COMMUNICATIONS.CanAccessChannel(P, ACT) then
        RDV.COMMUNICATIONS.ExitCurrentChannel(P, true)
    end
end

hook.Add("PlayerLoadout", "RDV_COMMUNICATIONS_CheckAvailable", CanAccess)

hook.Add("PlayerChangedTeam", "RDV_COMMUNICATIONS_CheckAvailable", function(P)
    timer.Simple(0, function()
        CanAccess(P)
    end)
end)

hook.Add("PlayerButtonDown", "RDV_COMMUNICATIONS_VoiceTalk", function(ply, button)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if !CFG.speakBindEnabled then return end

    if button == CFG.speakBindValue then            
        ply.isCommsTalking = true
        net.Start("RDV_COMMUNICATIONS_Talking")
        net.Send(ply)
    end
end)

hook.Add("PlayerButtonUp", "RDV_COMMUNICATIONS_VoiceTalk", function(ply, button)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if !CFG.speakBindEnabled then return end

    if button == CFG.speakBindValue then            
        ply.isCommsTalking = false

        net.Start("RDV_COMMUNICATIONS_Talking")
        net.Send(ply)
    end
end)

--[[---------------------------------]]--
--  Communications Command
--[[---------------------------------]]--
hook.Add("PlayerSay", "RDV_COMMS_Blacklist", function(P, T, TCHAT)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local ENABLED = RDV.COMMUNICATIONS.GetCommsEnabled(P)

    if ( TCHAT and CFG.disableTeamChat ) and !ENABLED then
        SendNotification(P, RDV.LIBRARY.GetLang(nil, "COMMS_relayDownError"))

        return ""
    end
end )

hook.Add("PlayerSay", "RDV_COMMUNICATIONS_PlayerSay", function(ply, text)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local COMMAND = CFG.chatCommand
    local CONFIG = CFG.menuCommand

    local CLEN = #COMMAND
    local CLEN2 = #CONFIG

    if string.lower(string.sub(text, 1, CLEN)) == COMMAND then
        if !RDV.COMMUNICATIONS.GetCommsEnabled(ply) then
            SendNotification(ply, RDV.LIBRARY.GetLang(nil, "COMMS_relayDownError"))
            return ""
        end

        local MSG = string.sub(text, (CLEN + 2) )

        if !MSG or MSG == "" then
            return ""
        end

        local ACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(ply)

        if !ACTIVE then
            return ""
        end

        local TAB = RDV.COMMUNICATIONS.Players
        local COUNT = #TAB

        local SEND = {}

        for i = 1, COUNT do
            local CLI = TAB[i].Client

            if !IsValid(CLI) then
                continue
            end

            local CCHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(TAB[i].Client)

            if ACTIVE == CCHANNEL then
                table.insert(SEND, TAB[i].Client)
            end
        end

        net.Start("RDV.COMMUNICATIONS.SendCommsMessage")
            net.WriteUInt(ply:EntIndex(), 8)
            net.WriteString(MSG)
        net.Send(SEND)

        return ""
    elseif string.lower(string.sub(text, 1, CLEN2)) == CONFIG then
        if !ply:IsAdmin() then return "" end
        
        net.Start("RDV.COMMUNICATIONS.OpenConfig")
        net.Send(ply)

        return ""
    end
end)

--[[---------------------------------]]--
--  Handle Hearing
--[[---------------------------------]]--

local function canHear( l, t )
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local T_CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(t)
    local L_CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(l)
    local P_CHANNELS = RDV.COMMUNICATIONS.GetPassiveChannels(l)

    if ( ( ( T_CHANNEL and L_CHANNEL ) and (T_CHANNEL == L_CHANNEL) ) or P_CHANNELS[T_CHANNEL] ) then
        if !RDV.COMMUNICATIONS.GetCommsEnabled(t) then
            return
        end

        if CFG.speakBindEnabled and !t.isCommsTalking then
            return
        end

        if RDV.COMMUNICATIONS.MUTED[t] then
            return
        end

        return true
    elseif CFG.speakBindEnabled and t.isCommsTalking then
        return false
    end
end

local function voiceBoxCanHear( l, t )
    local CFG = RDV.COMMUNICATIONS.S_CFG

    VoiceBox.FX.IsRadioComm( l:EntIndex(), t:EntIndex(), false )

    local T_CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(t)
    local L_CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(l)
    local P_CHANNELS = RDV.COMMUNICATIONS.GetPassiveChannels(l)

    if ( ( ( T_CHANNEL and L_CHANNEL ) and (T_CHANNEL == L_CHANNEL) ) or P_CHANNELS[T_CHANNEL] ) then
        if !RDV.COMMUNICATIONS.GetCommsEnabled(t) then
            return
        end

        if CFG.speakBindEnabled and !t.isCommsTalking then
            return
        end
        
        if RDV.COMMUNICATIONS.MUTED[t] then
            return
        end

        VoiceBox.FX.IsRadioComm( l:EntIndex(), t:EntIndex(), not VoiceBox.FX.__PlayerCanHearPlayersVoice(l, t) )
        
        return true
    elseif CFG.speakBindEnabled and t.isCommsTalking then
        return false
    end
end

hook.Add( "PlayerCanHearPlayersVoice", "RDV_COMMUNICATIONS_VoiceControl", canHear )

if VoiceBox and VoiceBox.FX then
    hook.Add( "PlayerCanHearPlayersVoice", "RDV_COMMUNICATIONS_VoiceControl", voiceBoxCanHear )
else
    hook.Add( "VoiceBox.FX", "RDV.COMMUNICATIONS", function()
        hook.Add( "PlayerCanHearPlayersVoice", "RDV_COMMUNICATIONS_VoiceControl", voiceBoxCanHear )
    end )
end

--[[---------------------------------]]--
--  Occupancy
--[[---------------------------------]]--

hook.Add("PlayerDisconnected", "RDV_COMMUNICATIONS_DISCONNECTED", function(ply)
    if !RDV.COMMUNICATIONS.Players then
        return
    end

    local IND = ply:EntIndex()

    -- Clear Passive Channels
    if RDV.COMMUNICATIONS.SPASSIVE[IND] then
        RDV.COMMUNICATIONS.SPASSIVE[IND] = nil
        RDV.COMMUNICATIONS.PASSIVE[IND] = nil

        net.Start("RDV_COMMS_ClearPassive")
            net.WriteUInt(IND, 8)
        net.Broadcast()
    end

    -- Clear Muted Status
    if  RDV.COMMUNICATIONS.MUTED[ply] then
         RDV.COMMUNICATIONS.MUTED[ply] = nil
    end

    -- Exit Main Channel
    local ACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(ply)

    if ACTIVE then
        RDV.COMMUNICATIONS.ExitCurrentChannel(ply, true)
    end
end)

--[[---------------------------------]]--
--  In-game Channel Creation
--[[---------------------------------]]--

hook.Add("PlayerReadyForNetworking", "RDV_COMMUNICATIONS_NETWORK", function(ply)
    RDV.COMMUNICATIONS.MUTED[ply] =  RDV.COMMUNICATIONS.MUTED[ply] or false
    RDV.COMMUNICATIONS.ACTIVE[ply] = RDV.COMMUNICATIONS.ACTIVE[ply] or false
    
    local ACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(ply)

    -- SEND PLAYERS INSIDE CHANNELS CURRENTLY
    if RDV.COMMUNICATIONS.Players then
        local SEND = {}
        local COUNT = 0
        
        for k, v in ipairs(RDV.COMMUNICATIONS.Players) do
            if v.Channel and v.Channel ~= "" then
                COUNT = COUNT + 1

                table.insert(SEND, v)
            end
        end

        net.Start("RDV_COMMS_Sync")
            net.WriteUInt(COUNT, 8)
            
            for i = 1, COUNT do
                local P = Entity(SEND[i].UID)

                if !IsValid(P) then continue end

                net.WriteUInt(P:EntIndex(), 8)
                net.WriteString(SEND[i].Channel)
            end
        net.Send(ply)
    end

    -- SEND PLAYERS IN PASSIVE CHANNELS
    if RDV.COMMUNICATIONS.PASSIVE then
        local PCOUNT = 0
        local SEND = {}
        local COUNT = {}

        for k, v in ipairs(player.GetAll()) do
            local UID = v:EntIndex()

            if RDV.COMMUNICATIONS.SPASSIVE[UID] and #RDV.COMMUNICATIONS.SPASSIVE[UID] > 0 then
                table.insert(SEND, {
                    PLAYER = UID, 
                    CHANNELS = RDV.COMMUNICATIONS.SPASSIVE[UID],
                })

                PCOUNT = PCOUNT + 1
            end
        end

        net.Start("RDV_COMMS_SendPassive")
            net.WriteUInt(PCOUNT, 8)

            for k, v in ipairs(SEND) do
                net.WriteUInt(v.PLAYER, 8)
                net.WriteTable(v.CHANNELS)
            end
        net.Send(ply)
    end

    local CFG = RDV.COMMUNICATIONS.S_CFG
    
    if CFG.defaultChannel then
        RDV.COMMUNICATIONS.SetChannel(ply, CFG.defaultChannel)
    end

    hook.Run("RDV_COMMS_NetworkingComplete", ply)
end)


hook.Add("RDV_COMMS_PostChannelConnect", "RDV_COMMUNICATIONS_StartMuted", function(ply)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if CFG.startMuted then
         RDV.COMMUNICATIONS.MUTED[ply] = true
    end
end )

if repairDatabase then
    repairDatabase["rdv_console_comms"] = function(fusionCutter, ent, trace)
        local hp = ent:Health()

        if hp < ent:GetMaxHealth() then
            ent:SetHealth(math.Clamp(ent:Health() + 25, 0, ent:GetMaxHealth()))

            return true
        end

        return false
    end
end