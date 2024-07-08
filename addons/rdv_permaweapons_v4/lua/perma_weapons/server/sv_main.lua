local function SendNotification(ply, msg)
    local PFC = NCS_PERMAWEAPONS.CFG.prefixcolor

    NCS_SHARED.AddText(ply, Color(PFC.r, PFC.g, PFC.b), "["..NCS_PERMAWEAPONS.CFG.prefix.."] ", Color(255,255,255), msg)
end

NCS_PERMAWEAPONS_Mysql:RawQuery([[
    CREATE TABLE IF NOT EXISTS ixPermaWeapons(
        client VARCHAR(80),
        pchar INT,
        weapon VARCHAR(255),
        equipped TINYINT,
        PRIMARY KEY(client, pchar, weapon)
    )
]])

concommand.Add("ncs_pmw_dropdb", function(ply)
    if IsValid(ply) then
        return
    end

    local q = NCS_PERMAWEAPONS_Mysql:Drop("ixPermaWeapons")
    q:Callback(function(data)
        local CFG = NCS_PERMAWEAPONS.CFG.Prefix

        MsgC(CFG.Color, "["..CFG.Appension.."] ", COL_1, "Database Dropped Successfully\n")
    end)
    q:Execute()
end)

hook.Add("PlayerLoadout", "NCS_PERMAWEAPONS.PlayerLoadout", function(ply)
    if !IsValid(ply) or !ply.ixPermaWeapons then
        return
    end

    local SID64 = ply:SteamID64()

    local CATS = NCS_PERMAWEAPONS.CATS[SID64]

    for k, v in pairs(ply.ixPermaWeapons) do
        local TAB = NCS_PERMAWEAPONS.WEAPONS[k]

        if !v.Equipped or !TAB then continue end
        
        if NCS_PERMAWEAPONS.CanUse(ply, k) then
            if NCS_PERMAWEAPONS.CFG.onecat then
                if ( CATS[TAB.CATEGORY] and CATS[TAB.CATEGORY] ~= k ) then 
                    continue
                end
            end
            
            CATS[TAB.CATEGORY] = k

            ply:Give(k)
        end
    end
end)

local function SelectData(ply, slot)
    ply.ixPermaWeapons = {}

    local SID64 = ply:SteamID64()
    local CATS = NCS_PERMAWEAPONS.CATS[SID64]

    local q = NCS_PERMAWEAPONS_Mysql:Select("ixPermaWeapons")
        q:Select("weapon")
        q:Select("equipped")
        q:Where("client", SID64)
        q:Where("pchar", slot)
        q:Callback(function(data)
            if !data or !data[1] then return end

            for k, v in pairs(data) do
                local TAB = NCS_PERMAWEAPONS.WEAPONS[v.weapon]
                if !TAB then continue end

                local VAL = tobool(v.equipped)

                if NCS_PERMAWEAPONS.CFG.onecat then
                    if VAL and CATS[TAB.CATEGORY] then 
                        VAL = false

                        NCS_PERMAWEAPONS.Toggle(ply, v.weapon) 
                    end
                end

                ply.ixPermaWeapons[v.weapon] = {
                    Equipped = VAL
                }
                
                if VAL and TAB then
                    timer.Simple(0, function() 
                        if NCS_PERMAWEAPONS.CanUse(ply, v.weapon) then
                            CATS[TAB.CATEGORY] = v.weapon

                            ply:Give(v.weapon)
                        end
                    end )
                end
            end
        end)
    q:Execute()
end

timer.Simple(0, function()
    NCS_PERMAWEAPONS.OnCharacterLoaded(nil, function(ply, slot)
        NCS_PERMAWEAPONS.CATS[ply:SteamID64()] = {}

        SelectData(ply, slot)
    end)

    NCS_PERMAWEAPONS.OnCharacterDeleted(nil, function(ply, charid)
        local SID64 = ply:SteamID64()

        local q = NCS_PERMAWEAPONS_Mysql:Delete("ixPermaWeapons")
            q:Where("client", SID64)
            q:Where("pchar", charid)
        q:Execute()
    end)
end )

hook.Add("NCS_SHARED_PlayerReadyForNetworking", "NCS_PERMAWEAPONS.PlayerReadyForNetworking", function(ply)
    if !NCS_PERMAWEAPONS.GetCharacterEnabled() then
        NCS_PERMAWEAPONS.CATS[ply:SteamID64()] = {}

        SelectData(ply, 1)
    end

    local COMPRESS = util.Compress(util.TableToJSON((NCS_PERMAWEAPONS.WEAPONS)))
    local BYTES = #COMPRESS

    net.Start("NCS_PW_BatchSendWeapons")
        net.WriteUInt( BYTES, 16 )
        net.WriteData( COMPRESS, BYTES )
    net.Send(ply)

    local COMPRESS = util.Compress(util.TableToJSON((NCS_PERMAWEAPONS.CFG)))

    local BYTES = #COMPRESS

    net.Start("NCS_PMW_SaveConfig")
        net.WriteUInt( BYTES, 16 )
        net.WriteData( COMPRESS, BYTES )
    net.Send(ply)
end)



local function SaveVendors()
    local DATA = {}
    local COUNT = 0

    for k, v in ipairs(ents.GetAll()) do
        if ( v:GetClass() == "ix_perma_weapons" ) then
            table.insert(DATA, {P = v:GetPos(), A = v:GetAngles()})
            COUNT = COUNT + 1
        end
    end

    NCS_PERMAWEAPONS.VENDORS = DATA

    DATA = util.TableToJSON(DATA) 

    file.CreateDir("ncs/permaweapons/")

    file.Write("ncs/permaweapons/vendors_"..game.GetMap()..".json", DATA)

    return COUNT
end

hook.Add("PlayerSay", "NCS_LOADOUTS_MainCommand", function(P, T)
    if string.lower(T) == NCS_PERMAWEAPONS.CFG.savevendorcommand then
        NCS_PERMAWEAPONS.IsAdmin(P, function(ACCESS)
            if !ACCESS then return end

            local COUNT = SaveVendors()

            SendNotification(P, NCS_PERMAWEAPONS.GetLang(nil, "savedVendors", {COUNT, game.GetMap()}))
        end )

        return ""
    end
end )

local function SetupVendors()
    if !NCS_PERMAWEAPONS.VENDORS or table.IsEmpty(NCS_PERMAWEAPONS.VENDORS) then return end
    
    for k, v in ipairs(NCS_PERMAWEAPONS.VENDORS) do
        local E = ents.Create("ix_perma_weapons")
        E:SetPos(v.P)
        E:SetAngles(v.A)
        E:SetModel(NCS_PERMAWEAPONS.CFG.model)
        E:Spawn()
    end
end

local function ReadVendors()
    local DATA = file.Read("ncs/permaweapons/vendors_"..game.GetMap()..".json", "DATA")

    if DATA then
        DATA = util.JSONToTable(DATA)   

        NCS_PERMAWEAPONS.VENDORS = DATA
    end

    SetupVendors()
end

hook.Add("NCS_PMW_ConfigurationLoadSuccessful", "NCS_PERMAWEAPONS_InitVendors", function()
    ReadVendors()
end )

hook.Add("PostCleanupMap", "NCS_PERMAWEAPONS_MapCleanupReadd", function()
    SetupVendors()
end )