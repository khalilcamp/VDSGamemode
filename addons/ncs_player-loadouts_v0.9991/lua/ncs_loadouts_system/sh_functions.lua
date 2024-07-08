function NCS_LOADOUTS.IsAdmin(P, CB)
    if NCS_LOADOUTS.CONFIG.camienabled then
        CAMI.PlayerHasAccess(P, "[NCS] Loadouts", function(ACCESS)
            CB(ACCESS)
        end )
    else
        if NCS_LOADOUTS.CONFIG.admins[P:GetUserGroup()] then
            CB(true)
        else
            CB(false)
        end
    end
end

function NCS_LOADOUTS.AddText(receivers, ...)
    if SERVER then
        net.Start("NCS_LOADOUTS.AddText")
            net.WriteTable({...})
        net.Send(receivers)
    else
        chat.AddText(...)

        surface.PlaySound("common/talk.wav")
    end
end

function NCS_LOADOUTS.PlaySound(client, snd)
    if !IsValid(client) or !snd then
        return
    end
    
    if SERVER then
        net.Start("NCS_LOADOUTS.PlaySound")
            net.WriteString(snd)
        net.Send(client)
    else
        surface.PlaySound(snd)
    end
end

if CLIENT then
    net.Receive("NCS_LOADOUTS.PlaySound", function()
        local SND = net.ReadString()

        surface.PlaySound(SND)
    end)

    net.Receive("NCS_LOADOUTS.AddText", function()
        chat.AddText(unpack(net.ReadTable()))

        surface.PlaySound("common/talk.wav")
    end)
else
    util.AddNetworkString("NCS_LOADOUTS.PlaySound")
    util.AddNetworkString("NCS_LOADOUTS.AddText")
end

