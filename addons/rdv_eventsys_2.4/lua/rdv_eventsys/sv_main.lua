local lastTick = 0

local DOORS = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["func_movelinear"] = true,    
}

util.AddNetworkString("RDV_EVENTS_OpenMenu")
util.AddNetworkString("RDV_EVENTS_OptionsUpdated")

hook.Add("PlayerSay", "RDV_EVENTS_OpenMenu", function(P, TEXT)
    if string.lower(TEXT) == RDV.EVENTS.CFG.COMMAND and RDV.EVENTS.CFG.ADMINS[P:GetUserGroup()] then
        local DATA = RDV.EVENTS.DATA

        net.Start("RDV_EVENTS_OpenMenu")
            net.WriteTable(DATA)
        net.Send(P)

        return ""
    end
end )

net.Receive("RDV_EVENTS_OptionsUpdated", function(_, P)
    if !RDV.EVENTS.CFG.ADMINS[P:GetUserGroup()] then return end

    local DATA = net.ReadTable()
    local CFG = RDV.EVENTS.DATA

    if ( DATA.DoorsLocked ~= nil ) and ( DATA.DoorsLocked ~= CFG.DoorsLocked ) then
        for k, v in ipairs(ents.GetAll()) do
            if !DOORS[v:GetClass()] then continue end
        
            if DATA.DoorsLocked then
                v:Fire("lock")
            else
                v:Fire("unlock")
            end
        end
    end

    for k, v in pairs(DATA) do
        RDV.EVENTS.DATA[k] = v
    end
end )

hook.Add("PlayerSwitchFlashlight", "RDV_DisableFlashlight", function(P, BOOL)
    return !RDV.EVENTS.DATA.FlashlightDisabled
end )

util.AddNetworkString("RDV_EVENTS_UpdateLives")

net.Receive("RDV_EVENTS_UpdateLives", function(_, P)
    if !RDV.EVENTS.CFG.ADMINS[P:GetUserGroup()] then return end
    
    local LivesCount = net.ReadUInt(32)
    local LivesSpawnEnabled = net.ReadBool()
    local TimerCount = net.ReadUInt(32)
    local TimerSpawnEnabled = net.ReadBool()

    RDV.EVENTS.LIVES = {
        LivesSpawnEnabled = LivesSpawnEnabled,
        LivesCount = LivesCount,
        TimerSpawnEnabled = TimerSpawnEnabled,
        TimerCount = TimerCount,

        MaxLives = LivesCount,
        MaxTimer = TimerCount,
    }

    net.Start("RDV_EVENTS_UpdateLives")
        net.WriteUInt(LivesCount, 32)
        net.WriteBool(LivesSpawnEnabled)
        net.WriteUInt(TimerCount, 32)
        net.WriteBool(TimerSpawnEnabled)
    net.Broadcast()
end )

hook.Add("PlayerReadyForNetworking", "RDV_EVENTS_UpdateLives", function(P)
    local DATA = RDV.EVENTS.LIVES
    DATA.LivesCount = ( DATA.LivesCount or 0 )
    DATA.TimerCount = ( DATA.TimerCount or 0 )
    DATA.LivesSpawnEnabled = ( DATA.LivesSpawnEnabled or false )
    DATA.TimerSpawnEnabled = ( DATA.TimerSpawnEnabled or false )

    net.Start("RDV_EVENTS_UpdateLives")
        net.WriteUInt(DATA.LivesCount, 32)
        net.WriteBool(DATA.LivesSpawnEnabled)
        net.WriteUInt(DATA.TimerCount, 32)
        net.WriteBool(DATA.TimerSpawnEnabled)
    net.Broadcast()
end )

hook.Add("Think", "RDV_EVENTS_Think", function()
    if lastTick and lastTick > CurTime() then return end

    local DATA = RDV.EVENTS.LIVES

    if !DATA.TimerCount then return end

    DATA.TimerCount = math.max(DATA.TimerCount - 1, 0)

    lastTick = CurTime() + 1
end )

hook.Add("PlayerDeathThink", "RDV_EVENTS_UpdateLives", function()
    local DATA = RDV.EVENTS.LIVES

    if DATA.MaxLives and ( DATA.MaxLives > 0 ) and DATA.LivesCount and ( DATA.LivesCount <= 0 ) and !DATA.LivesSpawnEnabled then
        return false
    end

    if DATA.MaxTimer and ( DATA.MaxTimer > 0 ) and DATA.TimerCount and ( DATA.TimerCount <= 0 ) and !DATA.TimerSpawnEnabled then
        return false
    end
end)

hook.Add("TFA_PreCanPrimaryAttack", "RDV_EVENTS_JamWeps", function(wep)
    if RDV.EVENTS.DATA.WepJammed then
        if IsValid(wep:GetOwner()) then
            wep:SetJammed(true)
        end

        return false
    end
end)

local NEAREST = {}
hook.Add("PlayerDeath", "RDV.OBJECTIVES.commandPosts", function(ply)
    local DATA = RDV.EVENTS.DATA

    if DATA.commandPostSpawn then
        local ENTITY, DISTANCE
        local POS = ply:GetPos()

        for k, v in ipairs(ents.GetAll()) do
            if v:GetClass() ~= "rd_command_post" then continue end
            if v:GetCP_CurrentFaction() ~= ply:CP_GetFaction() then continue end

            local ND = v:GetPos():DistToSqr(POS)

            if !DISTANCE or ND < DISTANCE then
                ENTITY = v
                DISTANCE = ND
            end
        end

        if !IsValid(ENTITY) then return end

        NEAREST[ply] = ENTITY
    end
end)

hook.Add("PlayerLoadout", "RDV.OBJECTIVES.commandPosts", function(ply)
    local DATA = RDV.EVENTS.DATA

    if DATA.commandPostSpawn then
        if !NEAREST[ply] then return end

        local ENTITY = NEAREST[ply]

        timer.Simple(0, function()
            if !IsValid(ENTITY) then return end
            
            local POS = ENTITY:GetPos()
            POS.x = (POS.x + math.random(75,150))

            ply:SetPos(POS)
        end)
    end
end)