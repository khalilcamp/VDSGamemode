util.AddNetworkString("NCS_TRANSPORT_UpdateSettings")
util.AddNetworkString("NCS_TRANSPORT_UpdateLocation")
util.AddNetworkString("NCS_TRANSPORT_OpenMenu")
util.AddNetworkString("NCS_TRANSPORT_TravelSuccess")

local function SendNotification(ply, msg)
    local CFG = NCS_TRANSPORT.CONFIG
	local PC = CFG.prefixColor
	local PT = CFG.prefixText

    NCS_SHARED.AddText(ply, Color(PC.r, PC.g, PC.b), "["..PT.."] ", color_white, msg)
end

local function SaveSettingsData()
    file.CreateDir("ncs/transport")

    file.Write("ncs/transport/settings.json", util.TableToJSON(NCS_TRANSPORT.CONFIG))
end

local function ReadSettingsData()
    file.CreateDir("ncs/transport")

    if !file.Exists("ncs/transport/settings.json", "DATA") then return end

    local newData = file.Read("ncs/transport/settings.json", "DATA")
    newData = util.JSONToTable(newData)

    if !istable(newData) then return end

    for k, v in pairs(newData) do
        if ( NCS_TRANSPORT.CONFIG[k] == nil ) then continue end

        NCS_TRANSPORT.CONFIG[k] = v
    end
end

hook.Add("NCS_SHARED_PlayerReadyForNetworking", "NCS_TRANSPORT_SendConfigData", function(P)
    local DATA = NCS_TRANSPORT.CONFIG

    local json = util.TableToJSON(DATA)
    local dataCompressed = util.Compress(json)
    local dataLength = dataCompressed:len()

    net.Start("NCS_TRANSPORT_UpdateSettings")
        net.WriteUInt(dataLength, 32)
        net.WriteData(dataCompressed, dataLength)
    net.Send(P)
end )

ReadSettingsData()

net.Receive("NCS_TRANSPORT_UpdateSettings", function(_, P)
    NCS_TRANSPORT.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local dataLength = net.ReadUInt(32)
        local dataCompressed = net.ReadData(dataLength)

        if !dataCompressed then return end

        local newData = util.Decompress(dataCompressed)
        newData = util.JSONToTable(newData)

        for k, v in pairs(newData) do
            if ( NCS_TRANSPORT.CONFIG[k] == nil ) then continue end

            NCS_TRANSPORT.CONFIG[k] = v
        end

        net.Start("NCS_TRANSPORT_UpdateSettings")
            net.WriteUInt(dataLength, 32)
            net.WriteData(dataCompressed, dataLength)
        net.Broadcast()

        SaveSettingsData()
    end )
end )


local function ReadLocationsData()
    file.CreateDir("ncs/transport")

    if !file.Exists("ncs/transport/mapdata_"..game.GetMap()..".json", "DATA") then return end

    local newData = file.Read("ncs/transport/mapdata_"..game.GetMap()..".json", "DATA")
    newData = util.JSONToTable(newData)

    if !istable(newData) then return end

    NCS_TRANSPORT.LOCATIONS = newData
end
ReadLocationsData()

local function SaveLocationsData()
    file.CreateDir("ncs/transport")

    file.Write("ncs/transport/mapdata_"..game.GetMap()..".json", util.TableToJSON(NCS_TRANSPORT.LOCATIONS))
end

net.Receive("NCS_TRANSPORT_UpdateLocation", function(_, P)
    NCS_TRANSPORT.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local dataLength = net.ReadUInt(32)
        local dataCompressed = net.ReadData(dataLength)

        if !dataCompressed then return end

        local newData = util.Decompress(dataCompressed)
        newData = util.JSONToTable(newData)

        if newData.icon then
            if string.find(newData.icon, "imgur") then
                local SLASHES = {}
        
                for i = 1, #newData.icon do
                    if newData.icon[i] == "/" then
                        SLASHES[i] = true
                    end
                end
        
                local LINK = string.sub(newData.icon, ( table.maxn(SLASHES) + 1) )
        
                newData.icon = LINK
            end
        end

        if newData.uid and NCS_TRANSPORT.LOCATIONS[newData.uid] then
            for k, v in pairs(newData) do
                if ( NCS_TRANSPORT.C_LOCATION[k] ~= nil ) then 
                    NCS_TRANSPORT.LOCATIONS[newData.uid][k] = v
                end
            end
        else
            newData.uid = os.time()

            NCS_TRANSPORT.LOCATIONS[newData.uid] = newData
        end

        
        if NCS_TRANSPORT.collectedData[P] then
            local json = util.TableToJSON(newData)
            local compressed = util.Compress(json)
            local length = compressed:len()

            net.Start("NCS_TRANSPORT_UpdateLocation")
                net.WriteUInt(length, 32)
                net.WriteData(compressed, length)
            net.Broadcast()
        end

        SaveLocationsData()
    end )
end )

local travelDelays = {}

net.Receive("NCS_TRANSPORT_TravelSuccess", function(_, P)
    if travelDelays[P] and travelDelays[P] > CurTime() then return end
    travelDelays[P] = CurTime() + 2

    local vendorUID = net.ReadUInt(32)
    local UID = net.ReadUInt(32)
    local CFG = NCS_TRANSPORT.LOCATIONS

    if !CFG[UID] then return end

    for k, v in ipairs(ents.FindByClass("ncs_transport_vendor")) do
        if v.vendorUID ~= vendorUID then continue end
        if v.locations and ( !table.IsEmpty(v.locations) and !v.locations[UID] ) then return end

        if v:GetPos():DistToSqr(P:GetPos()) > 80 * 80 then 
            return 
        end
    end

    if CFG[UID].teams and !table.IsEmpty(CFG[UID].teams) then
        if !CFG[UID].teams[team.GetName(P:Team())] then return end
    end

    local finalPrice = NCS_TRANSPORT.GetLocationPrice(P, UID)
    if !NCS_TRANSPORT.CanAfford(P, nil, finalPrice) then return end

    NCS_TRANSPORT.AddMoney(P, nil, -finalPrice)

    P:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255), 0.3, 2)
    P:Lock()

    net.Start("NCS_TRANSPORT_TravelSuccess")
    net.Send(P)

    timer.Simple(2, function()
        if !CFG[UID] then return end

        if NCS_TRANSPORT.CONFIG.soundsEnabled and NCS_TRANSPORT.CONFIG.landingSound then
            NCS_SHARED.PlaySound(P, NCS_TRANSPORT.CONFIG.landingSound)
        end

        P:SetPos(CFG[UID].pos)
        P:SetEyeAngles(CFG[UID].ang)
        P:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 0.3, 2)
        P:UnLock()

        SendNotification(P, NCS_TRANSPORT.GetLang(nil, "youTraveled", {CFG[UID].name, NCS_TRANSPORT.FormatMoney(nil, finalPrice)}))
    end )
end )



local function SaveVendors()
    local COUNT = 0
    local DATA = {}

    for k, v in ipairs(ents.GetAll()) do
        if ( v:GetClass() == "ncs_transport_vendor" ) then
            table.insert(DATA, {
                P = v:GetPos(), A = v:GetAngles(), M = v:GetModel(), LOC = v.locations, vendorUID = v.vendorUID,
            })

            COUNT = COUNT + 1
        end
    end

    NCS_TRANSPORT.VENDORS = DATA

    file.CreateDir("ncs/transport/")

    file.Write("ncs/transport/vendors_"..game.GetMap()..".json", util.TableToJSON(DATA) )

    return COUNT
end

hook.Add("PlayerSay", "NCS_TRANSPORT_MainCommand", function(P, T)
    if string.lower(T) == string.lower(NCS_TRANSPORT.CONFIG.vendorSave) then
        NCS_TRANSPORT.IsAdmin(P, function(ACCESS)
            if !ACCESS then return end

            local COUNT = SaveVendors()

            SendNotification(P, NCS_TRANSPORT.GetLang(nil, "savedVendors", {COUNT, game.GetMap()}))
        end )

        return ""
    end
end )

local function SetupVendors()
    if !NCS_TRANSPORT.VENDORS or table.IsEmpty(NCS_TRANSPORT.VENDORS) then return end
    
    for k, v in ipairs(NCS_TRANSPORT.VENDORS) do
        local E = ents.Create("ncs_transport_vendor")
        E:SetPos(v.P)
        E:SetAngles(v.A)
        E:SetModel( (v.M or NCS_TRANSPORT.CONFIG.model) )
        E.vendorUID = v.vendorUID
        E.notInitialSpawn = true
        E.locations = v.LOC
        E:Spawn()
    end
end

local function ReadVendors()
    local DATA = file.Read("ncs/transport/vendors_"..game.GetMap()..".json", "DATA")

    if DATA then
        DATA = util.JSONToTable(DATA)   

        NCS_TRANSPORT.VENDORS = DATA
    end

    SetupVendors()
end

ReadVendors()

hook.Add("PostCleanupMap", "NCS_TRANSPORT_CleanupMap", function()
    SetupVendors()
end )

util.AddNetworkString("NCS_TRANSPORT_UpdateDestinations")
net.Receive("NCS_TRANSPORT_UpdateDestinations", function(_, P)
    NCS_TRANSPORT.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local vendorUID = net.ReadUInt(32)
        local destinationsTable = net.ReadTable()

        for k, v in ipairs(ents.FindByClass("ncs_transport_vendor")) do
            if ( tonumber(v.vendorUID) == tonumber(vendorUID) ) then
                v.locations = destinationsTable
            end
        end
    end )
end )

util.AddNetworkString("NCS_TRANSPORT_DeleteLocation")
net.Receive("NCS_TRANSPORT_DeleteLocation", function(_, P)
    NCS_TRANSPORT.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end
    
        local locationUID = net.ReadUInt(32)

        if NCS_TRANSPORT.LOCATIONS[locationUID] then
            NCS_TRANSPORT.LOCATIONS[locationUID] = nil

            SaveLocationsData()

            for k, v in ipairs(ents.FindByClass("ncs_transport_vendor")) do
                if v.locations and v.locations[locationUID] then v.locations[locationUID] = nil end
            end

            SaveVendors()
        end

        net.Start("NCS_TRANSPORT_DeleteLocation")
            net.WriteUInt(locationUID, 32)
        net.Broadcast()
    end )
end )