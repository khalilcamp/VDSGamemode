util.AddNetworkString("ix.PermaWeapons.Menu")
util.AddNetworkString("ix.PermaWeapons.Purchase")
util.AddNetworkString("ix.PermaWeapons.Equip")
util.AddNetworkString("ix.PermaWeapons.Admin")
util.AddNetworkString("ix.PermaWeapons.Receive")
util.AddNetworkString("NCS_PW_AddWeaponConfirm")
util.AddNetworkString("NCS_PW_BatchSendWeapons")
util.AddNetworkString("NCS_PMW_SaveConfig")
util.AddNetworkString("NCS_PERMAWEAPONS_UpdateSale")

local function SendNotification(ply, msg)
    local PFC = NCS_PERMAWEAPONS.CFG.prefixcolor

    NCS_SHARED.AddText(ply, Color(PFC.r, PFC.g, PFC.b), "["..NCS_PERMAWEAPONS.CFG.prefix.."] ", Color(255,255,255), msg)
end

net.Receive("ix.PermaWeapons.Purchase", function(len, ply)
    local WEP = net.ReadString()

    local CFG = NCS_PERMAWEAPONS.WEAPONS[WEP]

    if !CFG then
        return
    end

    if !CFG.BUYABLE then return end

    if NCS_PERMAWEAPONS.CanUse(ply, WEP) then
        local PRICE = CFG.PRICE

        if CFG.SALE and CFG.SALE["DISCOUNT"] then
            PRICE = CFG.SALE["DISCOUNT"]
        end

        if !NCS_PERMAWEAPONS.CanAfford(ply, nil, PRICE) then
            return
        else
            NCS_PERMAWEAPONS.AddMoney(ply, nil, -PRICE)
        end

        NCS_PERMAWEAPONS.Give(ply, WEP)

        SendNotification(ply, NCS_PERMAWEAPONS.GetLang(nil, "PMW_YouPurchased", {CFG.NAME, NCS_PERMAWEAPONS.FormatMoney(nil, PRICE)}))
    end 
end)

net.Receive("ix.PermaWeapons.Equip", function(len, ply)
    local WEP = net.ReadString()

    NCS_PERMAWEAPONS.Toggle(ply, WEP)
end)

local function SaveWeaponData()
    file.CreateDir("ncs/permaweapons/")
    file.Write("ncs/permaweapons/weapons.json", util.TableToJSON(NCS_PERMAWEAPONS.WEAPONS))
end

local function ReadWeaponData()
    local PATH = "ncs/permaweapons/weapons.json"

    if file.Exists(PATH, "DATA") then
        local DATA = file.Read(PATH, "DATA")

        DATA = util.JSONToTable(DATA)

        if !DATA or !istable(DATA) then return end


        NCS_PERMAWEAPONS.WEAPONS = DATA
    end
end
ReadWeaponData()

local function SaveConfigurationData()
    file.CreateDir("ncs/permaweapons/")
    file.Write("ncs/permaweapons/configuration.json", util.TableToJSON(NCS_PERMAWEAPONS.CFG))
end

local function ReadConfigurationData()
    local PATH = "ncs/permaweapons/configuration.json"

    if file.Exists(PATH, "DATA") then
        local DATA = file.Read(PATH, "DATA")

        DATA = util.JSONToTable(DATA)

        if !DATA or !istable(DATA) then return end

        for k, v in pairs(DATA) do
            if NCS_PERMAWEAPONS.CFG[k] ~= nil then
                NCS_PERMAWEAPONS.CFG[k] = v
            end
        end
    end

    hook.Run("NCS_PMW_ConfigurationLoadSuccessful")
end
ReadConfigurationData()

net.Receive("NCS_PW_AddWeaponConfirm", function(len, P)
    NCS_PERMAWEAPONS.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local BYTES = net.ReadUInt( 16 )
        local DATA = net.ReadData(BYTES)

        local DECOMPRESSED = util.Decompress(DATA)
        local TAB = util.JSONToTable(DECOMPRESSED)

        --

        local COMPRESS = util.Compress(util.TableToJSON(TAB))

        local BYTES = #COMPRESS

        net.Start("NCS_PW_AddWeaponConfirm")
            net.WriteUInt( BYTES, 16 )
            net.WriteData( COMPRESS, BYTES )
        net.Broadcast()


        NCS_PERMAWEAPONS.WEAPONS[TAB.CLASS] = TAB

        SaveWeaponData()

        SendNotification(P, NCS_PERMAWEAPONS.GetLang(nil, "addedWeapon", {(TAB.NAME or "INVALID")}))
    end )
end )

util.AddNetworkString("NCS_PMW_RemoveWeapon")

net.Receive("NCS_PMW_RemoveWeapon", function(_, P)
    NCS_PERMAWEAPONS.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local CLASS = net.ReadString()

        if !NCS_PERMAWEAPONS.WEAPONS[CLASS] then return end

        SendNotification(P, NCS_PERMAWEAPONS.GetLang(nil, "removedWeapon", {(NCS_PERMAWEAPONS.WEAPONS[CLASS].NAME or "INVALID")}))

        NCS_PERMAWEAPONS.WEAPONS[CLASS] = nil

        net.Start("NCS_PMW_RemoveWeapon")
            net.WriteString(CLASS)
        net.Broadcast()

        SaveWeaponData()
    end )
end )

net.Receive("NCS_PMW_SaveConfig", function(_, P)
    NCS_PERMAWEAPONS.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local BYTES = net.ReadUInt( 16 )
        local DATA = net.ReadData(BYTES)

        local DECOMPRESSED = util.Decompress(DATA)
        local TAB = util.JSONToTable(DECOMPRESSED)
        
        if !TAB.admins["superadmin"] then
            TAB.admins["superadmin"] = "World"
        end

        for k, v in pairs(TAB) do
            if NCS_PERMAWEAPONS.CFG[k] ~= nil then
                NCS_PERMAWEAPONS.CFG[k] = v
            end
        end

        local COMPRESS = util.Compress(util.TableToJSON((NCS_PERMAWEAPONS.CFG)))
        local BYTES = #COMPRESS
    
        net.Start("NCS_PMW_SaveConfig")
            net.WriteUInt( BYTES, 16 )
            net.WriteData( COMPRESS, BYTES )
        net.Broadcast()

        SaveConfigurationData()

        SendNotification(P, NCS_PERMAWEAPONS.GetLang(nil, "savedConfig"))
    end )
end )

net.Receive("NCS_PERMAWEAPONS_UpdateSale", function(_, P)
    local CLASS = net.ReadString()
    local DISCOUNT = net.ReadUInt(32)
    local DURATION = net.ReadUInt(32)

    if !NCS_PERMAWEAPONS.WEAPONS[CLASS] then return end

    DURATION = ( DURATION * 60 ) + os.time()

    NCS_PERMAWEAPONS.WEAPONS[CLASS].SALE = {
        DURATION = DURATION,
        DISCOUNT = DISCOUNT,
    }

    SaveWeaponData()

    net.Start("NCS_PERMAWEAPONS_UpdateSale")
        net.WriteString(CLASS)
        net.WriteUInt(DISCOUNT, 32)
        net.WriteUInt(DURATION, 32)
    net.Broadcast()

    SendNotification(P, NCS_PERMAWEAPONS.GetLang(nil, "updatedSale", {NCS_PERMAWEAPONS.WEAPONS[CLASS].NAME, string.NiceTime(DURATION), NCS_PERMAWEAPONS.FormatMoney(nil, DISCOUNT)}))
end )