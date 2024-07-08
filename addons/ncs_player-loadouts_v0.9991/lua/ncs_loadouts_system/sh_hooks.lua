if CLIENT then
    hook.Add( "InitPostEntity", "NCS_LOADOUTS_PlayerReadyForNetworking", function()
        if !IsValid(LocalPlayer()) then return end

        net.Start( "NCS_LOADOUTS_PlayerReadyForNetworking" )
        net.SendToServer()
    end )
else 
    local NETWORKED = {}

    util.AddNetworkString( "NCS_LOADOUTS_PlayerReadyForNetworking" )

    net.Receive( "NCS_LOADOUTS_PlayerReadyForNetworking", function( len, ply )
        if NETWORKED[ply] then
            ply:Kick()
            return
        end

        NETWORKED[ply] = true

        hook.Run("NCS_LOADOUTS_PlayerReadyForNetworking", ply)
    end )
end