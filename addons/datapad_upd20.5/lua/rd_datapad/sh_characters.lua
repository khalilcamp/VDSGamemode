NCS_DATAPAD.CharSystems = {}

function NCS_DATAPAD.RegisterCharacter(NAME)
    NCS_DATAPAD.CharSystems[NAME] = {}

    return NCS_DATAPAD.CharSystems[NAME]
end

local HOOKS = {}

function NCS_DATAPAD.AddCharacterHook(hookname, callback)
    if not hookname then return end

    HOOKS = HOOKS or {}

    local position = table.insert(HOOKS, hookname)

    hook.Add(hookname, hookname..".DAP."..position, callback)
end

--[[
    Currency Functions.
--]]

function NCS_DATAPAD.GetCharacterID(player, game_mode)
    if !game_mode then
        game_mode = NCS_DATAPAD.CONFIG.CharSystemSelected
    end

    local TAB = NCS_DATAPAD.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.GetCharacterID) then
        return false
    end
        
    return TAB:GetCharacterID(player)
end

function NCS_DATAPAD.OnCharacterLoaded(game_mode, callback)
    if !game_mode then
        game_mode = NCS_DATAPAD.CONFIG.CharSystemSelected
    end

    local TAB = NCS_DATAPAD.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterLoaded) then
        return false
    end

    TAB:OnCharacterLoaded(function(player, slot)
        callback(player, tonumber(slot))
    end)
end


function NCS_DATAPAD.OnCharacterDeleted(game_mode, callback)
    if !game_mode then
        game_mode = NCS_DATAPAD.CONFIG.CharSystemSelected
    end

    local TAB = NCS_DATAPAD.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterDeleted) then
        return false
    end

    TAB:OnCharacterDeleted(function(player, slot)
        callback(player, tonumber(slot))
    end)
end

function NCS_DATAPAD.OnCharacterChanged(game_mode, callback)
    if !game_mode then
        game_mode = NCS_DATAPAD.CONFIG.CharSystemSelected
    end

    local TAB = NCS_DATAPAD.CharSystems[game_mode]

    if not TAB or not isfunction(TAB.OnCharacterChanged) then
        return false
    end

    TAB:OnCharacterChanged(function(player, new, old)
        callback(player, tonumber(new), tonumber(old))
    end)
end

function NCS_DATAPAD.GetCharacterEnabled()
    return ( NCS_DATAPAD.CONFIG.CharSystemSelected ~= false )
end