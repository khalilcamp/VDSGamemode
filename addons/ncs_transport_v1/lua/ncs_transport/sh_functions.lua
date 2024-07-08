--

NCS_TRANSPORT.CONFIG = {
    LANG = "en",
    currency = "darkrp",
    prefixText = "Transport",
    prefixColor = Color(255,0,0),
    accentColor = Color(212,0,255),
    takeoffSound = "rdv/transport_system/transport_takeoff.mp3",
    landingSound = "rdv/transport_system/transport_landing.mp3",
    vendormodel = "models/player/zygerrian/zygerrian_pitboss.mdl",
    vendorSave = "!tsave",
    stances = {	
        "pose_standing_02", 
        "idle_all_01",
        "idle_all_02",
    },
    pricing = 0.030,
    vendorRandomize = true,
    soundsEnabled = true,
    camienabled = true,
    admins = {["superadmin"] = "World"},
}

NCS_TRANSPORT.C_LOCATION = {
    name = "New Location Name",
    icon = "Q1TG6Xt",
    price = false,
    pos = false,
    ang = false,
    distanceScaled = true,
    teams = {},
}

NCS_TRANSPORT.collectedData = {}


if CLIENT then
    function NCS_TRANSPORT.RequestLocationData(P, RET)
        net.Start("NCS_TRANSPORT_RequestLocationData")
        net.SendToServer()

        if ( NCS_TRANSPORT.collectedData[P] == true ) then
            if RET then RET(NCS_TRANSPORT.LOCATIONS) end

            return
        else
            NCS_TRANSPORT.collectedData[P] = function(DATA)
                NCS_TRANSPORT.LOCATIONS = DATA

                if RET then RET(DATA) end

                NCS_TRANSPORT.collectedData[P] = true
            end
        end
    end

    net.Receive("NCS_TRANSPORT_RequestLocationData", function(_, P)
        if isbool(NCS_TRANSPORT.collectedData[P]) then return end

        local dataLength = net.ReadUInt(32)
        local dataCompressed = net.ReadData(dataLength)
    
        if !dataCompressed then return end
    
        local newData = util.Decompress(dataCompressed)
        newData = util.JSONToTable(newData)
        
        NCS_TRANSPORT.collectedData[LocalPlayer()](newData)
    end )
else
    util.AddNetworkString("NCS_TRANSPORT_RequestLocationData")

    net.Receive("NCS_TRANSPORT_RequestLocationData", function(_, P)
        if isbool(NCS_TRANSPORT.collectedData[P]) then return end

        local json = util.TableToJSON(NCS_TRANSPORT.LOCATIONS)
        local dataCompressed = util.Compress(json)
        local dataLength = dataCompressed:len()

        net.Start("NCS_TRANSPORT_RequestLocationData")
            net.WriteUInt(dataLength, 32)
            net.WriteData(dataCompressed, dataLength)
        net.Send(P)

        NCS_TRANSPORT.collectedData[P] = true
    end )
end

function NCS_TRANSPORT.GetLocationPrice(P, UID)
    if !NCS_TRANSPORT.LOCATIONS[UID] then return end

    local CFG = NCS_TRANSPORT.LOCATIONS[UID]

    local price = CFG.price
    local distanceScaled = CFG.distanceScaled

    if distanceScaled then
        local DISTANCE = P:GetPos():Distance(CFG.pos)
        DISTANCE = string.Explode(".", DISTANCE / 52.49)[1]

        price = string.Explode(".", NCS_TRANSPORT.CONFIG.pricing * CFG.pos:Distance(P:GetPos()))
        price = price[1]
    end

    return tonumber(price)
end

function NCS_TRANSPORT.IsAdmin(P, CB)
    if NCS_TRANSPORT.CONFIG.camienabled then
        CAMI.PlayerHasAccess(P, "[NCS] Transport", function(ACCESS)
            CB(ACCESS)
        end )
    else
        if NCS_TRANSPORT.CONFIG.admins[P:GetUserGroup()] then
            CB(true)
        else
            CB(false)
        end
    end
end