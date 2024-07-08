function NCS_PERMAWEAPONS.RegisterCharacter(NAME)
    NCS_PERMAWEAPONS.CharSystems[NAME] = {}

    return NCS_PERMAWEAPONS.CharSystems[NAME]
end

local HOOKS = {}

function NCS_PERMAWEAPONS.AddCharacterHook(hookname, callback)
    if not hookname then return end

    HOOKS = HOOKS or {}

    local position = table.insert(HOOKS, hookname)

    hook.Add(hookname, hookname..".LOD."..position, callback)
end

--[[
    Currency Functions.
--]]

function NCS_PERMAWEAPONS.GetCharacterID(player, game_mode)
    if !game_mode then
        game_mode = NCS_PERMAWEAPONS.CFG.charsysselected
    end

    local TAB = NCS_PERMAWEAPONS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.GetCharacterID) then
        return false
    end
        
    return TAB:GetCharacterID(player)
end

function NCS_PERMAWEAPONS.OnCharacterLoaded(game_mode, callback)
    if !game_mode then
        game_mode = NCS_PERMAWEAPONS.CFG.charsysselected
    end

    local TAB = NCS_PERMAWEAPONS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterLoaded) then
        return false
    end

    TAB:OnCharacterLoaded(function(player, slot)
        callback(player, tonumber(slot))
    end)
end


function NCS_PERMAWEAPONS.OnCharacterDeleted(game_mode, callback)
    if !game_mode then
        game_mode = NCS_PERMAWEAPONS.CFG.charsysselected
    end

    local TAB = NCS_PERMAWEAPONS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterDeleted) then
        return false
    end

    TAB:OnCharacterDeleted(function(player, slot)
        callback(player, tonumber(slot))
    end)
end

function NCS_PERMAWEAPONS.OnCharacterChanged(game_mode, callback)
    if !game_mode then
        game_mode = NCS_PERMAWEAPONS.CFG.charsysselected
    end

    local TAB = NCS_PERMAWEAPONS.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterChanged) then
        return false
    end

    TAB:OnCharacterChanged(function(player, new, old)
        callback(player, tonumber(new), tonumber(old))
    end)
end

function NCS_PERMAWEAPONS.GetCharacterEnabled()
    return ( NCS_PERMAWEAPONS.CFG.charsysselected ~= false )
end