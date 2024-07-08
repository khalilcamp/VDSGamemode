function NCS_LOADOUTS.RegisterCharacter(NAME)
    NCS_LOADOUTS.CharSystems[NAME] = {}

    return NCS_LOADOUTS.CharSystems[NAME]
end

local HOOKS = {}

function NCS_LOADOUTS.AddCharacterHook(hookname, callback)
    if not hookname then return end

    HOOKS = HOOKS or {}

    local position = table.insert(HOOKS, hookname)

    hook.Add(hookname, hookname..".LOD."..position, callback)
end

--[[
    Currency Functions.
--]]

function NCS_LOADOUTS.GetCharacterID(player, game_mode)
    if !game_mode then
        game_mode = NCS_LOADOUTS.CONFIG.charsysselected
    end

    local TAB = NCS_LOADOUTS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.GetCharacterID) then
        return false
    end
        
    return TAB:GetCharacterID(player)
end

function NCS_LOADOUTS.OnCharacterLoaded(game_mode, callback)
    if !game_mode then
        game_mode = NCS_LOADOUTS.CONFIG.charsysselected
    end

    local TAB = NCS_LOADOUTS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterLoaded) then
        return false
    end

    TAB:OnCharacterLoaded(function(player, slot)
        callback(player, tonumber(slot))
    end)
end


function NCS_LOADOUTS.OnCharacterDeleted(game_mode, callback)
    if !game_mode then
        game_mode = NCS_LOADOUTS.CONFIG.charsysselected
    end

    local TAB = NCS_LOADOUTS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterDeleted) then
        return false
    end

    TAB:OnCharacterDeleted(function(player, slot)
        callback(player, tonumber(slot))
    end)
end

function NCS_LOADOUTS.OnCharacterChanged(game_mode, callback)
    if !game_mode then
        game_mode = NCS_LOADOUTS.CONFIG.charsysselected
    end

    local TAB = NCS_LOADOUTS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterChanged) then
        return false
    end

    TAB:OnCharacterChanged(function(player, new, old)
        callback(player, tonumber(new), tonumber(old))
    end)
end

function NCS_LOADOUTS.GetCharacterEnabled()
    return ( NCS_LOADOUTS.CONFIG.charsysselected ~= false )
end