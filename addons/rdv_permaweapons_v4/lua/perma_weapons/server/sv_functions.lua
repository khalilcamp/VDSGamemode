local function IsEquipped(ply, wep)
    local TAB = ply.ixPermaWeapons

    if !TAB or !TAB[wep] then
        return
    end

    return TAB[wep].Equipped
end

local function SendNotification(ply, msg)
    NCS_SHARED.AddText(ply, NCS_PERMAWEAPONS.CFG.prefix, "["..NCS_PERMAWEAPONS.CFG.prefixcolor.."] ", Color(255,255,255), msg)
end

function NCS_PERMAWEAPONS.Give(ply, wep, char)
    if !IsValid(ply) then return false end

    if !NCS_PERMAWEAPONS.WEAPONS[wep] then 
        return false 
    end

    local SID64 = ply:SteamID64()

    if !char then
	    char =  ( NCS_PERMAWEAPONS.GetCharacterEnabled() and NCS_PERMAWEAPONS.GetCharacterID(ply) or 1 )
    end

    local q = NCS_PERMAWEAPONS_Mysql:Insert("ixPermaWeapons")
        q:Insert("client", SID64)
        q:Insert("pchar", char)
        q:Insert("weapon", wep)
        q:Insert("equipped", 0)
    q:Execute()

    ply.ixPermaWeapons[wep] = {
        Equipped = false,
    }
    
    hook.Run("NCS_PMW_PostGiveWeapon", ply, wep, char)

    return true
end

function NCS_PERMAWEAPONS.Take(ply, wep, char)
    if !IsValid(ply) then return false end

    if !NCS_PERMAWEAPONS.WEAPONS[wep] then 
        return false 
    end

    local SID64 = ply:SteamID64()

    if !char then
	    char =  (NCS_PERMAWEAPONS.GetCharacterEnabled() and NCS_PERMAWEAPONS.GetCharacterID(ply) or 1 )
    end

    ply.ixPermaWeapons[wep] = nil

    local q = NCS_PERMAWEAPONS_Mysql:Delete("ixPermaWeapons")
        q:Where("client", SID64)
        q:Where("pchar", char)
        q:Where("weapon", wep)
    q:Execute()

    hook.Run("NCS_PMW_PostTakeWeapon", ply, wep, char)

    return true
end

function NCS_PERMAWEAPONS.Toggle(ply, wep, char)
    local TAB = NCS_PERMAWEAPONS.WEAPONS[wep]
    if !TAB then return end

    if !ply.ixPermaWeapons or !ply.ixPermaWeapons[wep] then
        return false
    end

    if NCS_PERMAWEAPONS.CanUse(ply, wep) then
        local NVAL = !IsEquipped(ply, wep)

        local SID64 = ply:SteamID64()

        if !char then
            char =  (NCS_PERMAWEAPONS.GetCharacterEnabled() and NCS_PERMAWEAPONS.GetCharacterID(ply) or 1 )
        end

        local CATS = NCS_PERMAWEAPONS.CATS[SID64]

        if NCS_PERMAWEAPONS.CFG.onecat then
            if NVAL then    
                if CATS[TAB.CATEGORY] then 
                    SendNotification(ply, NCS_PERMAWEAPONS.GetLang(nil, "PMW_oneCat"))
                    return 
                end
            
                CATS[TAB.CATEGORY] = wep
            else
                if ( CATS[TAB.CATEGORY] and CATS[TAB.CATEGORY] == wep ) then
                    CATS[TAB.CATEGORY] = nil
                end
            end
        end

        ply.ixPermaWeapons[wep] = {
            Equipped = NVAL,
        }

        local STAT = NVAL and 1 or 0

        local q = NCS_PERMAWEAPONS_Mysql:Update("ixPermaWeapons")
            q:Update("equipped", STAT)
            q:Where("client", SID64)
            q:Where("pchar", char)
            q:Where("weapon", wep)
        q:Execute()

        if NVAL then
            ply:Give(wep)
        else
            ply:StripWeapon(wep)
        end
    end
end

function NCS_PERMAWEAPONS.MysqlConnect()
	local READ = NCS_PERMAWEAPONS.Mysql

	local HOST = READ.Host
	local PASSWORD = READ.Password
	local DATABASE = READ.Name
	local USERNAME = READ.Username
	local PORT = READ.Port
				
	local MODULE = ( READ.Module or "sqlite" )
	
	NCS_PERMAWEAPONS_Mysql:SetModule(MODULE)
	
	NCS_PERMAWEAPONS_Mysql:Connect(HOST, USERNAME, PASSWORD, DATABASE, PORT)
end