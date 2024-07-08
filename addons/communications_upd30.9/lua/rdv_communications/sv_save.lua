util.AddNetworkString("RDV_COMMUNICATIONS_AddRelay")
util.AddNetworkString("RDV_COMMUNICATIONS_RelayToggled")
util.AddNetworkString("RDV_COMMUNICATIONS_ToggleComms")
util.AddNetworkString("RDV_COMMUNICATIONS_RemoveRelay")

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG
    local COL = Color(CFG.chatColor.r, CFG.chatColor.g, CFG.chatColor.b)

    RDV.LIBRARY.AddText(ply, COL, "["..CFG.chatPrefix.."] ", color_white, msg)
end

local function SaveRelays()
    local PATH = "rdv/comms/relays/"..game.GetMap()..".json"

    file.CreateDir("rdv/comms/relays/")

    local LIST = {}

    for k, v in pairs(RDV.COMMUNICATIONS.RELAYS) do
        table.insert(LIST, {
            NAME = v.NAME,
            POS = v.POS,
            ANG = v.ANG,
            MODEL = v.MODEL,
            SOUNDS = ( v.SOUNDS or {} ),
            TEAMS = ( v.TEAMS or {} ),
        })
    end

    file.Write(PATH, util.TableToJSON(LIST))
end

local function READ()
    local PATH = "rdv/comms/relays/"..game.GetMap()..".json"

    if file.Exists(PATH, "DATA") then
        local DATA = util.JSONToTable(file.Read(PATH, "DATA"))

        if !DATA then return end

        for k, v in pairs(DATA) do


            if RDV.COMMUNICATIONS.RELAYS[v.NAME] and IsValid(RDV.COMMUNICATIONS.RELAYS[v.NAME].ENTITY) then continue end
            
            local E = ents.Create("rdv_console_comms")
            E:SetPos(v.POS)
            E:SetAngles(v.ANG)
            E:Spawn()
            E:SetRelayName(v.NAME)
            E:SetRelayEnabled(true)
            E:SetModel(v.MODEL)
            E:DropToFloor()

            RDV.COMMUNICATIONS.RELAYS[v.NAME] = {
                ENABLED = true,
                TEAMS = v.TEAMS,
                SOUNDS = v.SOUNDS,
                POS = v.POS,
                ANG = v.ANG,
                NAME = v.NAME,
                MODEL = v.MODEL,
                ENTITY = E,
            }
        end
    end
end
READ()
hook.Add("PostCleanupMap", "RDV_COMMUNICATIONS_RelayCleanup", READ)


hook.Add("PlayerButtonDown", "RDV_COMMUNICATIONS_addRelaySpot", function(P, B)
    if !P:IsAdmin() then return end
    if !IsValid(P.commsRelayHologram) then return end

    local HOLO = P.commsRelayHologram

    if B == KEY_E then
        P.selectingCommsRelaySpot.Callback(HOLO:GetPos(), HOLO:GetAngles())

        HOLO:Remove()
        P.selectingCommsRelaySpot = nil
        SendNotification(P, RDV.LIBRARY.GetLang(nil, "COMMS_finishedPlacement"))

    elseif B == KEY_G then

        HOLO:Remove()
        P.selectingCommsRelaySpot = nil

        SendNotification(P, RDV.LIBRARY.GetLang(nil, "COMMS_canceledPlacement"))
    end
end )

hook.Add("PlayerTick", "RDV_COMMUNICATIONS_addRelaySpot", function(P)
    if P.selectingCommsRelaySpot and P:IsAdmin() then
        local DATA = P.selectingCommsRelaySpot

        if not IsValid(P.commsRelayHologram) then
            P.commsRelayHologram = ents.Create("prop_physics")

            if IsValid(P.commsRelayHologram) then
                P.commsRelayHologram:SetColor(COL_GRN)
                P.commsRelayHologram:SetModel(DATA.MODEL)
                P.commsRelayHologram:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                P.commsRelayHologram:SetRenderMode(RENDERMODE_TRANSALPHA)
                P.commsRelayHologram:Spawn()
            end
        else
        	local tr = P:GetEyeTrace()

        	P.commsRelayHologram:SetAngles(Angle(0, P:GetAngles().y + 180, 0))
        	P.commsRelayHologram:SetPos(tr.HitPos )
       	end
    end
end )

hook.Add("PlayerDisconnected", "RDV_COMMUNICATIONS_addRelaySpot", function(P)
    if IsValid(P.commsRelayHologram) then
        P.commsRelayHologram = nil
    end
end )

net.Receive("RDV_COMMUNICATIONS_RemoveRelay", function(_, P)
    if !P:IsAdmin() then return end

    local NAME = net.ReadString()

    local DATA = RDV.COMMUNICATIONS.RELAYS[NAME]

    if IsValid(DATA.ENTITY) then DATA.ENTITY:Remove() end

    RDV.COMMUNICATIONS.RELAYS[NAME] = nil

    SaveRelays()
end )


net.Receive("RDV_COMMUNICATIONS_AddRelay", function(_, P)
    if !P:IsAdmin() then return end

    local NAME = net.ReadString()
    local MODEL = net.ReadString()

    NAME = string.upper(NAME)
    NAME = string.Trim(NAME)

    assert( NAME ~= "", "Invalid name for this relay.")
    assert( !RDV.COMMUNICATIONS.RELAYS[NAME], "A relay with this name already exists.")

    if !util.IsValidModel(MODEL) then
        MODEL = "models/props_wasteland/gaspump001a.mdl"
    end

    local T_LIST = {}
    local S_LIST = {}

    local COUNT = net.ReadUInt(8)

    for i = 1, COUNT do
        T_LIST[net.ReadString()] = true
    end

    local S_COUNT = net.ReadUInt(8)

    for i = 1, S_COUNT do
        table.insert(S_LIST, net.ReadString())
    end

    SendNotification(P, RDV.LIBRARY.GetLang(nil, "COMMS_pressE"))

    P.selectingCommsRelaySpot = {
        MODEL = MODEL,
        Callback = function(POS, ANG)
            local E = ents.Create("rdv_console_comms")
            E:SetPos(POS)
            E:SetAngles(ANG)
            E:SetRelayName(NAME)
            E:SetRelayEnabled(true)
            E:Spawn()
            E:SetModel(MODEL)
            E:DropToFloor()
        
            RDV.COMMUNICATIONS.RELAYS[NAME] = {
                ENABLED = true,
                TEAMS = T_LIST,
                SOUNDS = S_LIST,
                NAME = NAME,
                POS = POS,
                MODEL = MODEL,
                ANG = ANG,
                ENTITY = E,
            }

            SaveRelays()
        end,
    }
end )

util.AddNetworkString("RDV_COMMUNICATIONS_GotoRelay")

net.Receive("RDV_COMMUNICATIONS_GotoRelay", function(_, P)
    if !P:IsAdmin() then return end

    local NAME = net.ReadString()

    if !RDV.COMMUNICATIONS.RELAYS[NAME] then return end

    local DATA = RDV.COMMUNICATIONS.RELAYS[NAME]

    if !IsValid(DATA.ENTITY) then return end

    P:SetPos(DATA.ENTITY:GetPos())

    SendNotification(P, RDV.LIBRARY.GetLang(nil, "COMMS_movedtoRelay", {NAME}))
end )

hook.Add("PlayerChangedTeam", "RDV_COMMUNICATIONS_CheckRelay", function(P, OLD, NEW)
    timer.Simple(0, function()
        net.Start("RDV_COMMUNICATIONS_ToggleComms")
            net.WriteBool(RDV.COMMUNICATIONS.GetCommsEnabled(P))
        net.Send(P)
    end )
end )


--[[
--  Configuration
--]]

local function SaveCFG()
    file.CreateDir("rdv/comms")

    local JSON = util.TableToJSON(RDV.COMMUNICATIONS.S_CFG)

    file.Write("rdv/comms/config.json", JSON)
end

local function ReadCFG()
    local DIR = "rdv/comms/config.json"

    if !file.Exists(DIR, "DATA") then return end

    local DATA = util.JSONToTable(file.Read(DIR, "DATA"))

    if !DATA then return end

    for k, v in pairs(DATA) do
        RDV.COMMUNICATIONS.S_CFG[k] = v
    end
end
ReadCFG()

util.AddNetworkString("RDV_COMMUNICATIONS_UPDCFG")
net.Receive("RDV_COMMUNICATIONS_UPDCFG", function(_, P)
    if !P:IsAdmin() then return end

    local BYTES = net.ReadUInt( 16 )
    local DATA = net.ReadData(BYTES)

    local DECOMPRESSED = util.Decompress(DATA)
    local TAB = util.JSONToTable(DECOMPRESSED)

    RDV.COMMUNICATIONS.S_CFG = TAB

    local COMPRESS = util.Compress(util.TableToJSON(TAB))

    local BYTES = #COMPRESS

    net.Start("RDV_COMMUNICATIONS_UPDCFG")
        net.WriteUInt( BYTES, 16 )
        net.WriteData( COMPRESS, BYTES )
    net.Broadcast()

    SaveCFG()
end )

hook.Add("PlayerReadyForNetworking", "RDV_COMMUNICATIONS_SendConfig", function(P)
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local COMPRESS = util.Compress(util.TableToJSON(CFG))

    local BYTES = #COMPRESS

    net.Start("RDV_COMMUNICATIONS_UPDCFG")
        net.WriteUInt( BYTES, 16 )
        net.WriteData( COMPRESS, BYTES )
    net.Send(P)
end )