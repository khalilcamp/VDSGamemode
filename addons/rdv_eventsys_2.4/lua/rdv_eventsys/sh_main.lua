local DEAD = {} 

gameevent.Listen( "entity_killed" )
hook.Add( "entity_killed", "RDV.OBJECTIVES.livesTimer", function( data ) 
	local victim = data.entindex_killed

    local PLAYER = Entity(victim)

    if !PLAYER:IsPlayer() then return end
    if !IsValid(PLAYER) then return end

    DEAD[PLAYER] = PLAYER:Team()
end )

gameevent.Listen( "player_spawn" )
hook.Add("player_spawn", "RDV.OBJECTIVES.livesTimer", function( data )
    local ID = data.userid
    local PLAYER = Player(ID)

    if !IsValid(PLAYER) then return end
    if !DEAD[PLAYER] then return end
    if DEAD[PLAYER] ~= PLAYER:Team() then return end

    DEAD[PLAYER] = nil

    local LIVES = RDV.EVENTS.LIVES.LivesCount

    if !LIVES then return end

    RDV.EVENTS.LIVES.LivesCount = math.Clamp(LIVES - 1, 0, math.huge)
end)