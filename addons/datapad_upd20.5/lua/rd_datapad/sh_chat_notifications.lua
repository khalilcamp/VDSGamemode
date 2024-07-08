function NCS_DATAPAD.AddText(receivers, ...)
    if SERVER then
        net.Start("NCS_DATAPAD.AddText")
            net.WriteTable({...})
        net.Send(receivers)
    else
        chat.AddText(...)

        surface.PlaySound("common/talk.wav")
    end
end

function NCS_DATAPAD.PlaySound(client, snd)
    if !IsValid(client) or !snd then
        return
    end
    
    if SERVER then
        net.Start("NCS_DATAPAD.PlaySound")
            net.WriteString(snd)
        net.Send(client)
    else
        surface.PlaySound(snd)
    end
end

if CLIENT then
    net.Receive("NCS_DATAPAD.PlaySound", function()
        local SND = net.ReadString()

        surface.PlaySound(SND)
    end)

    net.Receive("NCS_DATAPAD.AddText", function()
        chat.AddText(unpack(net.ReadTable()))

        surface.PlaySound("common/talk.wav")
    end)
else
    util.AddNetworkString("NCS_DATAPAD.PlaySound")
    util.AddNetworkString("NCS_DATAPAD.AddText")
end