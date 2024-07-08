function RDV.MEDALS.GetPlayerID(P)
    local PID = P:SteamID64()

    if RDV.LIBRARY.GetCharacterEnabled() then
        PID = PID..RDV.LIBRARY.GetCharacterID(P)
    end
    
    return PID
end 

function RDV.MEDALS.GetName(UID)
    UID = tonumber(UID)

    if !RDV.MEDALS.LIST[UID] then return false end

    return ( RDV.MEDALS.LIST[UID].Name or false )
end

function RDV.MEDALS.GetPrimary(P)
    return tonumber(P:GetNWInt("RDV_MEDALS_PRIMARY", 0))
end

function RDV.MEDALS.Register(NAME, DATA)
    DATA.Name = NAME

    RDV.MEDALS.LIST[DATA.ID] = DATA
    RDV.MEDALS.CACHE_LIST[NAME] = DATA.ID

    if !DATA.HOOKS then 
        return 
    end

    for k, v in pairs(DATA.HOOKS) do
        hook.Add(tostring(k), "RDV_MEDALS_HOOKS", function(...)
            local VAL, P = v(...)

            if ( VAL == true ) and IsValid(P) then
                RDV.MEDALS.Give(NAME, P)
            end
        end )
    end
end