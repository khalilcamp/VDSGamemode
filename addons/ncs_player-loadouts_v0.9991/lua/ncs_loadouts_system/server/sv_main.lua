local function SendNotification(ply, msg)
    local CFG = NCS_LOADOUTS.CONFIG
	local PC = CFG.prefixcolor
	local PT = CFG.prefixtext

    NCS_LOADOUTS.AddText(ply, Color(PC.r, PC.g, PC.b), "["..PT.."] ", color_white, msg)
end

timer.Simple(0, function()
	local q = NCS_LOADOUTS_Mysql:Create("NCS_LOADOUTS_V1")
		q:Create("PlayerID", "VARCHAR(255)")
		q:Create("CertFlags", "TEXT")
		q:Create("PerLoadout", "VARCHAR(255)")
		q:PrimaryKey("PlayerID")
	q:Execute()
end )

util.AddNetworkString("NCS_LOADOUTS_GetPlayerCertifications")
util.AddNetworkString("NCS_LOADOUTS_MenuOpen")
util.AddNetworkString("NCS_LOADOUTS_ChangePlayerCert")

hook.Add("OnEntityCreated", "NCS_VehicleRestrict", function(E)
    timer.Simple(0, function()
        if !IsValid(E) or E:GetClass() ~= "prop_vehicle_prisoner_pod" or !IsValid(E:GetParent()) then return end

        local PARENT = E:GetParent()
        local ALLOWED = {}

        for k, v in pairs(NCS_LOADOUTS.CERTS) do
            if v.seats and v.seats[PARENT:GetClass()] then
                if v.seats[PARENT:GetClass()][E:GetNWInt("pPodIndex")] then 
                    E.NCS_allowedDrivers = E.NCS_allowedDrivers or {}

                    E.NCS_allowedDrivers[v.uid] = true
                elseif v.seats[PARENT:GetClass()]["-"] then
                    E.NCS_allowedDrivers = E.NCS_allowedDrivers or {}

                    E.NCS_allowedDrivers[v.uid] = true
                end
            end
        end
    end )
end )


local function SupportRequisitionRequests(P, CLASS)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )
    P_DATA.CERTS = P_DATA.CERTS or {}

    local permissionTab = {}

    if RDV and RDV.VEHICLE_REQ and RDV.VEHICLE_REQ.VEHICLES[CLASS] then
        CLASS = RDV.VEHICLE_REQ.VEHICLES[CLASS].CLASS
    elseif NCS_REQUISITION and NCS_REQUISITION.VEHICLES[CLASS] then
        CLASS = NCS_REQUISITION.VEHICLES[CLASS].CLASS
    end

    for k, v in pairs(NCS_LOADOUTS.CERTS) do    
        if !v.seats or !v.seats[CLASS] then continue end

        if v.seats[CLASS]["-"] then
            permissionTab[v.uid] = true
        end
    end

    if table.IsEmpty(permissionTab) then
        return
    else
        for k, v in pairs(P_DATA.CERTS) do
            if permissionTab[k] then
                return
            end
        end
    end

    return false
end
hook.Add("RDV_VR_CanRequest", "RequisitionSupportCerts", SupportRequisitionRequests)
hook.Add("NCS_REQUISITION_CanRequest", "RequisitionSupportCerts", SupportRequisitionRequests)


hook.Add("CanPlayerEnterVehicle", "functionsdsadsad", function(P, POD)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )
    P_DATA.CERTS = P_DATA.CERTS or {}
    
    if !POD.NCS_allowedDrivers then return end

    local function FindSeat()
        local FOUND = false

        for k, v in ipairs(POD:GetParent():GetPassengerSeats()) do
            if !v.NCS_allowedDrivers then
                FOUND = v
                break
            end

            for a, b in pairs(P_DATA.CERTS) do
                if v.NCS_allowedDrivers[a] then
                    FOUND = v
                    break
                end
            end
        end

        if !FOUND then return false end

        P:EnterVehicle(FOUND)

        return false
    end

    for k, v in pairs(POD.NCS_allowedDrivers) do
        if P_DATA.CERTS and P_DATA.CERTS[k] then return end
    end

    local FIND = FindSeat()

    if !FIND then return false end
end )


local function SaveVendors()
    local DATA = {}
    local COUNT = 0

    for k, v in ipairs(ents.GetAll()) do
        if ( v:GetClass() == "ncs_loadouts_terminal" ) then
            table.insert(DATA, {P = v:GetPos(), A = v:GetAngles()})
            COUNT = COUNT + 1
        end
    end

    NCS_LOADOUTS.VENDORS = DATA

    DATA = util.TableToJSON(DATA) 

    file.CreateDir("ncs/loadouts/")

    file.Write("ncs/loadouts/vendors_"..game.GetMap()..".json", DATA)

    return COUNT
end

hook.Add("PlayerSay", "NCS_LOADOUTS_MainCommandRun", function(P, T)
    if string.lower(T) == NCS_LOADOUTS.CONFIG.menucommand then
        local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

        if ( NCS_LOADOUTS.CONFIG.accessoption == 3 ) then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "accessDisabled")) return "" end

        net.Start("NCS_LOADOUTS_MenuOpen")
            if !P_DATA.InitialCertsUpdated and P_DATA.CERTS then
                net.WriteBool(true)
                net.WriteTable(P_DATA.CERTS or {})

                P_DATA.InitialCertsUpdated = true
            else
                net.WriteBool(false)
            end
        net.Send(P)

        return ""
    elseif string.lower(T) == NCS_LOADOUTS.CONFIG.savevendorcommand then
        NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
            if !ACCESS then return end

            local COUNT = SaveVendors()

            SendNotification(P, NCS_LOADOUTS.GetLang(nil, "savedVendors", {COUNT, game.GetMap()}))
        end )

        return ""
    end
end )

local function SetupVendors()
    if !NCS_LOADOUTS.VENDORS or table.IsEmpty(NCS_LOADOUTS.VENDORS) then return end
    
    for k, v in ipairs(NCS_LOADOUTS.VENDORS) do
        local E = ents.Create("ncs_loadouts_terminal")
        E:SetPos(v.P)
        E:SetAngles(v.A)
        E:Spawn()
        E:SetModel(NCS_LOADOUTS.CONFIG.vendormodel)
    end
end

local function ReadVendors()
    local DATA = file.Read("ncs/loadouts/vendors_"..game.GetMap()..".json", "DATA")

    if DATA then
        DATA = util.JSONToTable(DATA)   

        NCS_LOADOUTS.VENDORS = DATA
    end

    SetupVendors()
end

hook.Add("PostCleanupMap", "NCS_LOADOUTS_MapCleanupReadd", function()
    SetupVendors()
end )

local function SaveLoadouts()
    local DATA = NCS_LOADOUTS.LIST

    if DATA then 
        hook.Run("NCS_LOADOUTS_SaveLoadouts", DATA)

        DATA = util.TableToJSON(DATA) 
    end

    file.CreateDir("ncs/loadouts/")

    file.Write("ncs/loadouts/loadouts.json", DATA)
end

local function SaveCertifications()
    local DATA = NCS_LOADOUTS.CERTS

    if DATA then 
        hook.Run("NCS_LOADOUTS_SaveCertifications", DATA)
        DATA = util.TableToJSON(DATA) 
    end

    file.CreateDir("ncs/loadouts/")

    file.Write("ncs/loadouts/certifications.json", DATA)
end

local function SaveSettings()
    local DATA = NCS_LOADOUTS.CONFIG

    if DATA then DATA = util.TableToJSON(DATA) end

    file.CreateDir("ncs/loadouts/")
    
    file.Write("ncs/loadouts/settings.json", DATA)
end

local function LoadData()
    file.CreateDir("ncs/loadouts")

    local D_Settings = file.Read("ncs/loadouts/settings.json", "DATA")

    if D_Settings then
        D_Settings = util.JSONToTable(D_Settings)

        for k, v in pairs(D_Settings) do
            if NCS_LOADOUTS.CONFIG[k] ~= nil then
                NCS_LOADOUTS.CONFIG[k] = v
            end
        end
    end

    local D_Loadouts = file.Read("ncs/loadouts/loadouts.json", "DATA")

    if D_Loadouts then
        D_Loadouts = util.JSONToTable(D_Loadouts)   

        NCS_LOADOUTS.LIST = D_Loadouts
    end

    local D_Certifications = file.Read("ncs/loadouts/certifications.json", "DATA")

    if D_Certifications then
        D_Certifications = util.JSONToTable(D_Certifications)

        NCS_LOADOUTS.CERTS = D_Certifications
    end

    local listRunning = false

    for a, t in pairs(NCS_LOADOUTS.LIST) do
        for k, v in pairs(t.certs) do
            if !NCS_LOADOUTS.CERTS[k] then
                NCS_LOADOUTS.LIST[a].certs[k] = nil

                listRunning = true
            end
        end
    end

    if listRunning then
        SaveCertifications()
    end
end
LoadData()

util.AddNetworkString("NCS_LOADOUTS_AddLoadout")
util.AddNetworkString("NCS_LOADOUTS_DelLoadout")

net.Receive("NCS_LOADOUTS_AddLoadout", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end

        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local uncompressed = util.Decompress(data)

        if (!uncompressed) then
            return
        end

        local D = util.JSONToTable(uncompressed)
        
        local UID

        if D.uid then
            UID = D.uid
        else
            UID = table.maxn(NCS_LOADOUTS.LIST) + 1
        end
        
        if !D.name or ( string.Trim(D.name) == "" ) then return end

        if !D.icon or ( string.Trim(D.icon) == "" ) then
            D.icon = "Hk1RYWm"
        end

        if D.health then
            D.health = math.Round(D.health, 0)

            if D.health > 999999 then return end
        end

        if D.armor then
            D.armor = math.Round(D.armor, 0)

            if D.armor > 999999 then return end
        end

        if D.customcode then
            if string.find(D.customcode, "sql") then D.customcode = false end
        end

        if istable(D.teams) and table.Count(D.teams) <= 0 then D.teams = false end
        if istable(D.models) and table.Count(D.models) <= 0 then D.models = false end
        if istable(D.weps) and table.Count(D.weps) <= 0 then D.weps = false end

        D.uid = UID

        NCS_LOADOUTS.LIST[UID] = D

        local json = util.TableToJSON(D)
        local compressed = util.Compress(json)
        local length = compressed:len()

        SaveLoadouts()
    end )
end )

util.AddNetworkString("NCS_LOADOUTS_GetPlayerCerts")

net.Receive("NCS_LOADOUTS_GetPlayerCerts", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        local B, R = nil, nil

        if RDV and RDV.RANK then
            B = RDV.RANK.GetPlayerRankTree(P)
            R = RDV.RANK.GetPlayerRank(P)
        elseif MRS then
            B = MRS.GetPlayerGroup(P:Team())
            R = MRS.GetPlyRank(P, B)
        end

        if NCS_LOADOUTS.CONFIG.ranks and table.Count(NCS_LOADOUTS.CONFIG.ranks) > 0 and NCS_LOADOUTS.CONFIG.ranks[B] then
            if ( NCS_LOADOUTS.CONFIG.ranks[B] <= R ) then 
                ACCESS = true
            end
        end

        if NCS_LOADOUTS.CONFIG.teamrestrictcerts and table.Count(NCS_LOADOUTS.CONFIG.teamrestrictcerts) > 0 and NCS_LOADOUTS.CONFIG.teamrestrictcerts[team.GetName(P:Team())] then
            ACCESS = true
        end

        if !ACCESS then return end

        
        local PID = net.ReadUInt(8)

        if PID and IsValid(Player(PID)) then
            local P_R = Player(PID)
            local P_DATA = ( NCS_LOADOUTS.P_DATA[P_R:SteamID64()] or {} )

            local C = P_DATA.CERTS

            net.Start("NCS_LOADOUTS_GetPlayerCerts")
                net.WriteUInt(PID, 8)
                net.WriteTable(C or {})
            net.Send(P)
        end
    end )
end )

util.AddNetworkString("NCS_LOADOUTS_EquipLoadout")
util.AddNetworkString("NCS_LOADOUTS_UnequipLoadout")

local function UnequipLoadout(P, UID)
    UID = tonumber(UID)

    local TAB = NCS_LOADOUTS.LIST[UID]

    if !TAB then
        SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noEquipAccess"))
    else
        hook.Run("NCS_LOADOUTS_PreLoadoutUnequipped", P, UID)

        local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

        if TAB.weps then
            for k, v in pairs(TAB.weps) do
                P:StripWeapon(k)
            end
        end

        if P_DATA.OriginalModel then
            P:SetModel(P_DATA.OriginalModel)

            P_DATA.OriginalModel = nil
        end

        if P_DATA.OriginalHealth then
            P:SetHealth(P_DATA.OriginalHealth)
            P:SetMaxHealth(P_DATA.OriginalHealth)
        end

        if P_DATA.OriginalArmor then
            P:SetArmor(P_DATA.OriginalArmor)
            P:SetMaxArmor(P_DATA.OriginalArmor)
        end

        hook.Run("NCS_LOADOUTS_PostLoadoutUnequipped", P, UID)

        P_DATA.LOADOUT = nil
    end
end

local function EquipLoadout(P, UID)
    UID = tonumber(UID)

    local TAB = NCS_LOADOUTS.LIST[UID]

    if !TAB then return end

    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if P_DATA.LOADOUT then
        UnequipLoadout(P, P_DATA.LOADOUT)
    end
    
    if !P_DATA.OriginalModel then P_DATA.OriginalModel = P:GetModel() end
    
    if TAB.models then
        for a, b in pairs(TAB.models) do
            if b.teams[team.GetName(P:Team())] then
                P:SetModel(a)

                break
            end
        end
    end

    if TAB.weps then
        for k, v in pairs(TAB.weps) do
            P:Give(k)
        end
    end

    if TAB.health and P_DATA.OriginalHealth then
        P:SetMaxHealth( (P_DATA.OriginalHealth + TAB.health ) )
        P:SetHealth( (P_DATA.OriginalHealth + TAB.health ) )
    end

    if TAB.armor and P_DATA.OriginalArmor then
        P:SetMaxArmor((P_DATA.OriginalArmor + TAB.armor ))
        P:SetArmor((P_DATA.OriginalArmor + TAB.armor ))
    end

    if TAB.customcode and isstring(TAB.customcode) then
        local CC = TAB.customcode

        CC = string.Replace(CC, "%po%", "Player("..P:UserID()..")")

        RunString(CC)
    end

    hook.Run("NCS_LOADOUTS_PostLoadoutEquipped", P, UID)

    P_DATA.LOADOUT = UID
end

net.Receive("NCS_LOADOUTS_DelLoadout", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        if !ACCESS then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noPermsAccess")) return end

        local UID = net.ReadUInt(16)

        for k, v in ipairs(player.GetAll()) do
            local P_DATA = ( NCS_LOADOUTS.P_DATA[v:SteamID64()] or {} )

            if ( tonumber(P_DATA.LOADOUT) == tonumber(UID) ) then
                UnequipLoadout(v, UID)
            end
        end
        
        if NCS_LOADOUTS.LIST[UID] then
            NCS_LOADOUTS.LIST[UID] = nil
        end

        SaveLoadouts()
    end )
end )

hook.Add("playerGetSalary", "NCS_LOADOUTS_SalaryModifier", function(P, AMOUNT)
    if !DarkRP then return end
    
    local loadoutData = NCS_LOADOUTS.GetPlayerLoadout(P)
    loadoutData = NCS_LOADOUTS.LIST[loadoutData]

    if loadoutData and loadoutData.salary then
        local salaryModifier = loadoutData.salary
        
        local lang = NCS_LOADOUTS.GetLang(nil, "loadoutSalaryExec", { DarkRP.formatMoney(AMOUNT), DarkRP.formatMoney(salaryModifier), loadoutData.name})

        return false, lang, (AMOUNT + salaryModifier)
    end
end )

net.Receive("NCS_LOADOUTS_EquipLoadout", function(_, P)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if P_DATA.antiSpamDelay and P_DATA.antiSpamDelay > CurTime() then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "antiSpamDelay")) return end

    P_DATA.antiSpamDelay = CurTime() + 5

    local UID = net.ReadUInt(16)
    local PLD = NCS_LOADOUTS.GetPlayerLoadout(P)

    if ( PLD == UID ) then return end

    local TAB = NCS_LOADOUTS.LIST[UID]

    if !TAB then
        SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noEquipAccess"))
    else
        if !NCS_LOADOUTS.CanEquipLoadout(P, UID) then
            return
        end

        SendNotification(P, NCS_LOADOUTS.GetLang(nil, "equipSuccess", {(TAB.name or UID)}))

        EquipLoadout(P, UID)

        NCS_LOADOUTS.SavePlayerLoadout(P)

        if NCS_LOADOUTS.CONFIG.forcedrespawn then
            P:KillSilent()
        end
    end
end )

net.Receive("NCS_LOADOUTS_UnequipLoadout", function(_, P)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if P_DATA.antiSpamDelay and P_DATA.antiSpamDelay > CurTime() then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "antiSpamDelay")) return end
    
    P_DATA.antiSpamDelay = CurTime() + 5

    if P_DATA.LOADOUT then
        UnequipLoadout(P, P_DATA.LOADOUT)

        NCS_LOADOUTS.SavePlayerLoadout(P)
    end
end )

util.AddNetworkString("NCS_LOADOUTS_UpdateSettings")
net.Receive("NCS_LOADOUTS_UpdateSettings", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        if !ACCESS then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noPermsAccess")) return end

        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local uncompressed = util.Decompress(data)

        if (!uncompressed) then
            return
        end

        local D = util.JSONToTable(uncompressed)

        if D.accessoption then
            local AO = { [1] = true, [2] = true, [3] = true }

            if !AO[D.accessoption] then return end
        end
        
        for k, v in pairs(D) do
            if ( NCS_LOADOUTS.CONFIG[k] ~= nil ) then
                NCS_LOADOUTS.CONFIG[k] = v
            end
        end


        if !D.admins["superadmin"] then
            D.admins["superadmin"] = "World"
        end

        local json = util.TableToJSON(D)
        local compressed = util.Compress(json)
        local length = compressed:len()

        net.Start("NCS_LOADOUTS_UpdateSettings")
            net.WriteUInt(length, 32)
            net.WriteData(compressed, length)
        net.Broadcast()

        SaveSettings()

        SendNotification(P, NCS_LOADOUTS.GetLang(nil, "savedSettings"))
    end )
end )

util.AddNetworkString("NCS_LOADOUTS_CreateCertification")
net.Receive("NCS_LOADOUTS_CreateCertification", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        if !ACCESS then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noPermsAccess")) return end

        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local uncompressed = util.Decompress(data)

        if (!uncompressed) then
            return
        end

        local D = util.JSONToTable(uncompressed)
        
        local UID

        if D.uid then
            UID = D.uid
        else
            UID = table.maxn(NCS_LOADOUTS.CERTS) + 1
        end
        
        if !D.name or ( string.Trim(D.name) == "" ) then return end

        if !D.icon or ( string.Trim(D.icon) == "" ) then
            D.icon = "Hk1RYWm"
        end

        D.uid = UID

        NCS_LOADOUTS.CERTS[UID] = D

        SaveCertifications()
    end )
end )

util.AddNetworkString("NCS_LOADOUTS_DelCert")
net.Receive("NCS_LOADOUTS_DelCert", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        if !ACCESS then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "noPermsAccess")) return end

        local UID = net.ReadUInt(16)
        
        if NCS_LOADOUTS.CERTS[UID] then
            NCS_LOADOUTS.CERTS[UID] = nil
        end

        SaveCertifications()
    end )
end )

hook.Add("PlayerLoadout", "NCS_LOADOUTS_PlayerSpawn", function(P)
    local oHealth = P:Health()
    local oArmor = P:Armor()

    local function RunFuck(original)
        local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

            P_DATA.OriginalModel = P:GetModel() 
            
            if oHealth and ( ( oHealth ~= P:Health() ) ) then
                P_DATA.OriginalHealth = P:Health()
            else
                P_DATA.OriginalHealth = 100
            end

            if oArmor and ( oArmor ~= P:Armor() ) then
                P_DATA.OriginalArmor = P:Armor()
            else
                P_DATA.OriginalArmor = 0
            end

        if P_DATA.LOADOUT then
            local TAB = NCS_LOADOUTS.LIST[P_DATA.LOADOUT]

            if !TAB then return end

            if !NCS_LOADOUTS.CanEquipLoadout(P, P_DATA.LOADOUT) then
                UnequipLoadout(P, P_DATA.LOADOUT)
                return
            end

            EquipLoadout(P, P_DATA.LOADOUT) 
        end
    end

    timer.Simple(2, function()        
        RunFuck()
    end )
end )

function NCS_LOADOUTS.CanEquipLoadout(P, UID)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if P_DATA then
        local TAB = NCS_LOADOUTS.LIST[UID]

        if !TAB then return end

        local CanEquip = hook.Run("NCS_LOADOUTS_CanEquipLoadout", P, UID)
        if ( CanEquip == false ) then return end

        if !TAB.allteams and ( TAB.teams and !TAB.teams[team.GetName(P:Team())] )  then
            return false
        end

        if TAB.certs and !table.IsEmpty(TAB.certs) then
            if !P_DATA.CERTS then return end

            for k, v in pairs(TAB.certs) do
                if !P_DATA.CERTS[k] then
                    return false
                end
            end
        end

        if TAB.steamids and !table.IsEmpty(TAB.steamids) then
            if !TAB.steamids[P:SteamID()] then return false end
        end
    end

    return true
end

util.AddNetworkString("NCS_LOADOUTS_GivePlayerCert")

net.Receive("NCS_LOADOUTS_GivePlayerCert", function(_, P)
    NCS_LOADOUTS.IsAdmin(P, function(ACCESS)
        local B, R = nil, nil

        if RDV and RDV.RANK then
            B = RDV.RANK.GetPlayerRankTree(P)
            R = RDV.RANK.GetPlayerRank(P)
        elseif MRS then
            B = MRS.GetPlayerGroup(P:Team())
            R = MRS.GetPlyRank(P, B)
        end

        if NCS_LOADOUTS.CONFIG.ranks and table.Count(NCS_LOADOUTS.CONFIG.ranks) > 0 and NCS_LOADOUTS.CONFIG.ranks[B] then
            if ( NCS_LOADOUTS.CONFIG.ranks[B] <= R ) then 
                ACCESS = true
            end
        end

        if NCS_LOADOUTS.CONFIG.teamrestrictcerts and table.Count(NCS_LOADOUTS.CONFIG.teamrestrictcerts) > 0 and NCS_LOADOUTS.CONFIG.teamrestrictcerts[team.GetName(P:Team())] then
            ACCESS = true
        end

        if !ACCESS then return end

        local PID = net.ReadUInt(8)
            
        if PID and IsValid(Player(PID)) then
            local P_R = Player(PID)
            local CID = net.ReadUInt(16)

            NCS_LOADOUTS.P_DATA[P_R:SteamID64()] = NCS_LOADOUTS.P_DATA[P_R:SteamID64()] or {}

            local P_DATA = NCS_LOADOUTS.P_DATA[P_R:SteamID64()]
            P_DATA.CERTS = P_DATA.CERTS or {}

            if !NCS_LOADOUTS.CERTS[CID] then return end

            local C_NAME = NCS_LOADOUTS.CERTS[CID].name

            if P_DATA.InitialCertsUpdated then
                net.Start("NCS_LOADOUTS_ChangePlayerCert")
                    net.WriteUInt(CID, 16)
                if P_DATA.CERTS[CID] then
                    net.WriteBool(false)
                else
                    net.WriteBool(true)
                end
                net.Send(P_R)
            end

            local GIVE = true 

            if P_DATA.CERTS[CID] then
                GIVE = false
                P_DATA.CERTS[CID] = nil
            else
                P_DATA.CERTS[CID] = true
            end
            
            NCS_LOADOUTS.SavePlayerCerts(P_R)

            if GIVE then
                if ( P_R ~= P ) then
                    SendNotification(P_R, NCS_LOADOUTS.GetLang(nil, "givenCertification", {(C_NAME or "N/A"), P:Name()}))
                    SendNotification(P, NCS_LOADOUTS.GetLang(nil, "youGivenCert", {(C_NAME or "N/A"), P_R:Name()}))
                else
                    SendNotification(P_R, NCS_LOADOUTS.GetLang(nil, "selfGivenCertification", {(C_NAME or "N/A")}))
                end

                hook.Run("NCS_LOADOUTS_PlayerGiveCert", P_R, P, CID)
            else
                if ( P_R ~= P ) then
                    SendNotification(P_R, NCS_LOADOUTS.GetLang(nil, "takenCertification", {(C_NAME or "N/A"), P:Name()}))
                    SendNotification(P, NCS_LOADOUTS.GetLang(nil, "youTakenCert", {(C_NAME or "N/A"), P_R:Name()}))
                else
                    SendNotification(P_R, NCS_LOADOUTS.GetLang(nil, "selfTakenCertification", {(C_NAME or "N/A")}))
                end

                hook.Run("NCS_LOADOUTS_PlayerTakeCert", P_R, P, CID)
            end
        end
    end )
end )

function NCS_LOADOUTS.SavePlayerCerts(P)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()].CERTS or {} )

    local q = NCS_LOADOUTS_Mysql:Update("NCS_LOADOUTS_V1")
        q:Update("CertFlags", util.TableToJSON(P_DATA))
        q:Where("PlayerID", NCS_LOADOUTS.PlayerID(P))
    q:Execute()
end

function NCS_LOADOUTS.SavePlayerLoadout(P)
    local LOADOUT = (NCS_LOADOUTS.P_DATA[P:SteamID64()].LOADOUT or 0)

    local q = NCS_LOADOUTS_Mysql:Update("NCS_LOADOUTS_V1")
        q:Update("PerLoadout", LOADOUT)
        q:Where("PlayerID", NCS_LOADOUTS.PlayerID(P))
    q:Execute()
end


local function NCS_LOADOUTS_ApplyPlayerData(P)
    NCS_LOADOUTS.P_DATA[P:SteamID64()] = {}

    local PID = NCS_LOADOUTS.PlayerID(P)

    local q = NCS_LOADOUTS_Mysql:Select("NCS_LOADOUTS_V1")
        q:Select("CertFlags")
        q:Select("PerLoadout")
        q:Where("PlayerID", PID)
        q:Callback(function(data, idk, last)
            if !IsValid(P) then return end

            if !data or data[1] == nil then
                local q = NCS_LOADOUTS_Mysql:Insert("NCS_LOADOUTS_V1")
                    q:Insert("PlayerID", PID)
                q:Execute()
                
            else
                data = data[1]
                
                if data.CertFlags then
                    NCS_LOADOUTS.P_DATA[P:SteamID64()].CERTS = util.JSONToTable(data.CertFlags)
                end

                if data.PerLoadout and NCS_LOADOUTS.LIST[tonumber(data.PerLoadout)] and NCS_LOADOUTS.CanEquipLoadout(P, tonumber(data.PerLoadout)) then
                    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

                    EquipLoadout(P, data.PerLoadout)
                end
            end
		end)
    q:Execute()
end

util.AddNetworkString("NCS_LOADOUTS_InitialCerts")
hook.Add("NCS_LOADOUTS_PlayerReadyForNetworking", "NCS_LOADOUTS_PlayerNetworkingInitial", function(P)
    local json = util.TableToJSON(NCS_LOADOUTS.CONFIG)
    local compressed = util.Compress(json)
    local length = compressed:len()

    if json and json ~= "" then
        net.Start("NCS_LOADOUTS_UpdateSettings")
            net.WriteUInt(length, 32)
            net.WriteData(compressed, length)
        net.Broadcast()
    end

    if NCS_LOADOUTS.GetCharacterEnabled() then return end

    NCS_LOADOUTS_ApplyPlayerData(P)
end )

NCS_LOADOUTS.OnCharacterLoaded(nil, function(P, NEW)
    NCS_LOADOUTS_ApplyPlayerData(P)
end )

ReadVendors()
