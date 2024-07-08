local q = RDV_Mysql:Create("RDV_ADDON_MEDALS_V2")
    q:Create("M_UID", "INTEGER NOT NULL AUTO_INCREMENT")
    q:Create("M_MEDAL", "INT")
	q:Create("M_RECEIVER", "INT")
    q:Create("M_GIVER", "VARCHAR(255)")
    q:Create("M_DATE", "DATE")
	q:PrimaryKey("M_UID")
q:Execute()

local q = RDV_Mysql:Create("RDV_ADDON_MEDALS_SE")
	q:Create("M_RECEIVER", "INT")
    q:Create("M_PRIMARY", "INTEGER")
	q:PrimaryKey("M_RECEIVER")
q:Execute()

function RDV.MEDALS.Give(MEDAL, P_RECEIVER, P_GIVER)
    if !MEDAL or !P_RECEIVER then return end
    if !P_GIVER then P_GIVER = "Console" end

    MEDAL = tonumber(MEDAL)

    if IsValid(P_GIVER) then
        P_GIVER = P_GIVER:SteamID64()
    end

    local PID = RDV.MEDALS.GetPlayerID(P_RECEIVER)

    RDV.MEDALS.P_TAB[PID] = RDV.MEDALS.P_TAB[PID] or {}

    local CFG = RDV.MEDALS.LIST[MEDAL]

    if !CFG then ErrorNoHalt("Attempted to give an unknown Medal to player "..P_RECEIVER:Name().." ("..PID..")") return end

    if CFG.MAX and CFG.MAX > 0 then
        local COUNT = 0

        for k, v in ipairs(RDV.MEDALS.P_TAB[PID]) do
            if ( v.Medal == MEDAL ) then COUNT = COUNT + 1 end
        end

        if ( COUNT + 1 ) > CFG.MAX then
            local LANG = RDV.LIBRARY.GetLang(nil, "MED_maxMedals", {MEDAL})

            RDV.LIBRARY.AddText(P_RECEIVER, Color(255,0,0), "[MEDALS] ", color_white, LANG)

            return
        end
    end

    local LANG = RDV.LIBRARY.GetLang(nil, "MED_givenMedal", {MEDAL, P_GIVER})

    if CFG.REWARD and CFG.REWARD > 0 then
        RDV.LIBRARY.AddMoney(P_RECEIVER, nil, CFG.REWARD)

        LANG = RDV.LIBRARY.GetLang(nil, "MED_givenRewardMedal", {MEDAL, P_GIVER, RDV.LIBRARY.FormatMoney(nil, CFG.REWARD)})
    end

    RDV.LIBRARY.AddText(P_RECEIVER, Color(255,0,0), "[MEDALS] ", color_white, LANG)

    local TIMESTAMP = os.date("%x")

    local q = RDV_Mysql:Insert("RDV_ADDON_MEDALS_V2")
        q:Insert("M_RECEIVER", PID)
        q:Insert("M_GIVER", P_GIVER)
        q:Insert("M_MEDAL", MEDAL)
        q:Insert("M_DATE", TIMESTAMP)
        q:Callback(function(data, idk, last)
            table.insert(RDV.MEDALS.P_TAB[PID], {
                Medal = MEDAL,
                Giver = P_GIVER,
                Time = TIMESTAMP,
                UID = last,
            })
        end)
    q:Execute()
end

function RDV.MEDALS.Save()
    local DATA = RDV.MEDALS.LIST

    local JSON = util.TableToJSON(DATA)

    file.CreateDir("rdv/medals")

    file.Write("rdv/medals/data.json", JSON)
end

local function LOAD(PID, P)
    local q = RDV_Mysql:Select("RDV_ADDON_MEDALS_V2")
        q:Select("M_UID")
        q:Select("M_RECEIVER")
        q:Select("M_GIVER")
        q:Select("M_MEDAL")
        q:Select("M_DATE")
        q:Where("M_RECEIVER", PID)
        q:Callback(function(data)
            if !data or !data[1] then return end

            RDV.MEDALS.P_TAB[PID] = RDV.MEDALS.P_TAB[PID] or {}
            
            local ACCESS = {}
            
            for k, v in ipairs(data) do
                if !RDV.MEDALS.LIST[tonumber(v.M_MEDAL)] then continue end
                
                local KEY = table.insert(RDV.MEDALS.P_TAB[PID], {
                    Medal = tonumber(v.M_MEDAL),
                    Giver = v.M_GIVER,
                    Time = v.M_DATE,
                    UID = v.M_UID,
                })
                
                ACCESS[tonumber(v.M_UID)] = KEY
            end

            local q = RDV_Mysql:Select("RDV_ADDON_MEDALS_SE")
                q:Select("M_RECEIVER")
                q:Select("M_PRIMARY")
                q:Where("M_RECEIVER", PID)
                q:Callback(function(D)
                    if !D or !D[1] then
                        P:SetNWInt("RDV_MEDALS_PRIMARY", nil)
                        P:SetNWInt("RDV_MEDALS_MedID", nil)
                        return 
                    end
        
                    local M_PRIM = tonumber(D[1].M_PRIMARY)

                    local TAB = ACCESS[M_PRIM]
        
                    if !TAB then
                        return
                    end
                    
                    P:SetNWInt("RDV_MEDALS_PRIMARY", M_PRIM)

                    if RDV.MEDALS.P_TAB[PID][M_PRIM] then
                        P:SetNWInt("RDV_MEDALS_MedID", RDV.MEDALS.P_TAB[PID][M_PRIM].Medal)
                    end
                end)
            q:Execute()
        end)
    q:Execute()
end

RDV.LIBRARY.OnCharacterLoaded(nil, function(P, SLOT)
    local PID = (P:SteamID64()..SLOT)

    LOAD( PID, P )
end )

RDV.LIBRARY.OnCharacterChanged(nil, function(P, NEW, OLD)
    if !OLD then return end

    local PID = (P:SteamID64()..OLD)

    if RDV.MEDALS.P_TAB[PID] then 
        RDV.MEDALS.P_TAB[PID] = nil 
    end
end)

RDV.LIBRARY.OnCharacterDeleted(nil, function(P, SLOT)
    local CID = ( P:SteamID64()..SLOT )

    local PID = RDV.MEDALS.GetPlayerID(P)

    local q = RDV_Mysql:Delete("RDV_ADDON_MEDALS_V2")
        q:Where("M_RECEIVER", PID)
        q:Callback(function(data)
            if RDV.MEDALS.P_TAB[PID] then 
                RDV.MEDALS.P_TAB[PID] = nil 
            end
        end)
    q:Execute()

    local q = RDV_Mysql:Delete("RDV_ADDON_MEDALS_SE")
        q:Where("M_RECEIVER", PID)
        q:Callback(function(D)
            if ( CID == PID ) then
                P:SetNWInt("RDV_MEDALS_PRIMARY", nil)
                P:SetNWInt("RDV_MEDALS_MedID", nil)
            end
        end)
    q:Execute()
end )

hook.Add("PlayerSay", "RDV_MEDALS_PlayerSay", function(P, TEXT)
    if TEXT == "!medals" then
        net.Start("RDV_MEDALS_MENU")
        net.Send(P)
        return ""
    end
end )


local function READ()
    local PATH = "rdv/medals/data.json"

    if file.Exists(PATH, "DATA") then
        local DATA = file.Read(PATH, "DATA")
        DATA = util.JSONToTable(DATA)

        if !istable(DATA) then return end
        
        for k, v in pairs(DATA) do
            RDV.MEDALS.Register(v.Name, {
                ID = k,
                ICON = v.ICON,
                REWARD = v.REWARD,
                MAX = v.MAX,
                COLOR = Color(226,230,28),
            })
        end
    end

    hook.Remove("Think", "RDV_MEDALS_READ")
end
hook.Add("Think", "RDV_MEDALS_READ", READ)

util.AddNetworkString("RDV_MEDALS_SendPayload")

hook.Add("PlayerReadyForNetworking", "RDV_MEDALS_SendPayload", function(P)
    local DATA = util.TableToJSON(RDV.MEDALS.LIST)
    local COMP = util.Compress(DATA)
    local LEN = COMP:len()

    net.Start("RDV_MEDALS_SendPayload")
        net.WriteUInt(LEN, 32)
        net.WriteData(COMP, LEN)
    net.Send(P)

    if RDV.LIBRARY.GetCharacterEnabled() then return end

    LOAD( P:SteamID64(), P )
end )