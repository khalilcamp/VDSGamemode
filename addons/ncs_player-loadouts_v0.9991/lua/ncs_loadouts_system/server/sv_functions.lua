function NCS_LOADOUTS.MysqlConnect()
	local READ = NCS_LOADOUTS.Mysql

	local HOST = READ.Host
	local PASSWORD = READ.Password
	local DATABASE = READ.Name
	local USERNAME = READ.Username
	local PORT = READ.Port
				
	local MODULE = ( READ.Module or "sqlite" )
	
	NCS_LOADOUTS_Mysql:SetModule(MODULE)
	
	NCS_LOADOUTS_Mysql:Connect(HOST, USERNAME, PASSWORD, DATABASE, PORT)
end

function NCS_LOADOUTS.PlayerID(P)
	local PID = P:SteamID64()

	if NCS_LOADOUTS.CONFIG.charsysselected then
		local CID = NCS_LOADOUTS.GetCharacterID(P)

		if CID then
			return ( PID..CID )
		end
	end

	return PID
end

function NCS_LOADOUTS.GetPlayerLoadout(P)
    if !IsValid(P) then return false end

    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if P_DATA and P_DATA.LOADOUT then
        return P_DATA.LOADOUT
    else
        return false
    end
end

function NCS_LOADOUTS.GetLoadoutName(UID)
    local TAB = NCS_LOADOUTS.LIST[UID]

    if !TAB then return false end

    return TAB.name or false 
end