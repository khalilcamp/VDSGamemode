local R_DELAY = {}

local function SendNotification(P, MSG)
    RDV.LIBRARY.AddText(P, Color(255,0,0), "[MEDALS] ", color_white, MSG)

end

util.AddNetworkString("RDV_MEDALS_RETRIEVE")

net.Receive("RDV_MEDALS_RETRIEVE", function(_, P)
    if R_DELAY[P] and R_DELAY[P] > CurTime() then return end

    R_DELAY[P] = CurTime() + 0.5

    local PAGE = net.ReadUInt(16)
    local ADMIN = net.ReadBool()
    local PID = RDV.MEDALS.GetPlayerID(P)

    if ADMIN then
        if !RDV.MEDALS.CFG.Admins[P:GetUserGroup()] then SendNotification(P, RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

        local IND = net.ReadPlayer()

        if IsValid(IND) then
            PID = RDV.MEDALS.GetPlayerID(IND)
        end
    end

    if !RDV.MEDALS.P_TAB[PID] then return end

    local COUNT = #RDV.MEDALS.P_TAB[PID]
    local PAGE_COUNT = ( COUNT / 6 )

    if PAGE > PAGE_COUNT or PAGE < 0 then return end

    local T_PAGES = {}
    local T_COUNT = 0
    local P_COUNT = 0

    for i = 1, COUNT do
        if !RDV.MEDALS.P_TAB[PID][i] then continue end
            
        T_PAGES[P_COUNT] = T_PAGES[P_COUNT] or {}

        table.insert(T_PAGES[P_COUNT], RDV.MEDALS.P_TAB[PID][i])

        if ( ( T_COUNT + 1 ) == 6 ) then
            P_COUNT = P_COUNT + 1
            T_COUNT = 0
        end

        T_COUNT = T_COUNT + 1
    end

    if !T_PAGES[PAGE] then return end

    net.Start("RDV_MEDALS_RETRIEVE")
        for i = 1, 6 do
            local DATA = T_PAGES[PAGE][i]

            if !DATA then continue end
                
            net.WriteUInt(DATA.UID, 32)

            net.WriteUInt(DATA.Medal, 16)
            net.WriteString(DATA.Giver)
            net.WriteString(DATA.Time)
        end
    net.Send(P)
end )

util.AddNetworkString("RDV_MEDALS_GIVE")

net.Receive("RDV_MEDALS_GIVE", function(_, P)
    if !RDV.MEDALS.CFG.Admins[P:GetUserGroup()] then SendNotification(P, RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

    local E_RECEIVER = net.ReadPlayer()
    local E_MEDAL = net.ReadUInt(16)

    local CFG = RDV.MEDALS.LIST[E_MEDAL]

    if !CFG then return end

    RDV.MEDALS.Give(CFG.ID, E_RECEIVER, P)
end )

util.AddNetworkString("RDV_MEDALS_SetPrimary")

local P_DELAY = {}

net.Receive("RDV_MEDALS_SetPrimary", function(_, P)
    if R_DELAY[P] and R_DELAY[P] > CurTime() then return end

    R_DELAY[P] = CurTime() + 0.5

    local UID = net.ReadUInt(32)

    local PID = RDV.MEDALS.GetPlayerID(P)
    local TAB = RDV.MEDALS.P_TAB[PID]

    if !TAB then return end
    
    local FOUND = false
    local MID = false

    for k, v in ipairs(TAB) do
        if ( tonumber(UID) == tonumber(v.UID) ) then
            FOUND = true
            MID = v.Medal

            break
        end
    end

    if !FOUND then return end
    
    local q = RDV_Mysql:Select("RDV_ADDON_MEDALS_SE")
        q:Select("M_RECEIVER")
        q:Select("M_PRIMARY")
        q:Where("M_RECEIVER", PID)
        q:Callback(function(D)
            if D and D[1] then
                local U = RDV_Mysql:Update("RDV_ADDON_MEDALS_SE")
                    U:Update("M_PRIMARY", UID)
                    U:Where("M_RECEIVER", PID)
                U:Execute()
            else
                local U = RDV_Mysql:Insert("RDV_ADDON_MEDALS_SE")
                    U:Insert("M_PRIMARY", UID)
                    U:Insert("M_RECEIVER", PID)
                U:Execute()
            end
        end)
    q:Execute()

    P:SetNWInt("RDV_MEDALS_PRIMARY", UID)
    P:SetNWInt("RDV_MEDALS_MedID", MID)
end )

util.AddNetworkString("RDV_MEDALS_MENU")


util.AddNetworkString("RDV_MEDALS_CREATE")

net.Receive("RDV_MEDALS_CREATE", function(_, P)
    if !RDV.MEDALS.CFG.Admins[P:GetUserGroup()] then SendNotification(P, RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

    local EDIT = net.ReadBool()
    local UID = ( table.maxn(RDV.MEDALS.LIST) + 1 )

    if EDIT then
        UID = net.ReadUInt(32)
    end

    local NAME = net.ReadString()
    local IMGUR = net.ReadString()
    local MAX = net.ReadUInt(8)
    local CASH = net.ReadUInt(32)

    if string.find(IMGUR, "imgur") then
        local SLASHES = {}

        for i = 1, #IMGUR do
            if IMGUR[i] == "/" then
                SLASHES[i] = true
            end
        end

        local LINK = string.sub(IMGUR, ( table.maxn(SLASHES) + 1) )

        IMGUR = LINK
    end

    if EDIT then
        local OTAB = RDV.MEDALS.LIST[tonumber(UID)]

        if !OTAB then return end

        for k, v in ipairs(player.GetAll()) do
            local PID = RDV.MEDALS.GetPlayerID(v)
            local TAB = RDV.MEDALS.P_TAB[PID]
            
            if !TAB then continue end

            local FOUND = false

            for NKEY, DATA in pairs(TAB) do
                if ( DATA.Medal == OTAB.Name ) then
                    RDV.MEDALS.P_TAB[PID][NKEY].Medal = NAME

                    FOUND = true
                end
            end
        end

        local U = RDV_Mysql:Update("RDV_ADDON_MEDALS_V2")
            U:Update("M_MEDAL", NAME)
            U:Where("M_MEDAL", OTAB.Name)
        U:Execute()
    end

    RDV.MEDALS.Register(NAME, {
        ID = UID,
        ICON = IMGUR,
        REWARD = (CASH or 0),
        MAX = ( MAX or 0 ),
        COLOR = Color(226,230,28),
    })

    net.Start("RDV_MEDALS_CREATE")
        net.WriteUInt(UID, 32)
        net.WriteString(NAME)
        net.WriteString(IMGUR)
        net.WriteUInt( (MAX or 0 ), 8 )
        net.WriteUInt( (CASH or 0 ), 32 )
    net.Broadcast()

    RDV.MEDALS.Save()
end )

util.AddNetworkString("RDV_MEDALS_DELETE")

net.Receive("RDV_MEDALS_DELETE", function(_, P)
    if !RDV.MEDALS.CFG.Admins[P:GetUserGroup()] then SendNotification(P, RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

    local UID = net.ReadUInt(32)
    local M_NAME = RDV.MEDALS.LIST[UID]

    if !M_NAME then return end

    for k, v in ipairs(player.GetAll()) do
        local RLIST = {}

        local PID = RDV.MEDALS.GetPlayerID(v)
        local TAB = RDV.MEDALS.P_TAB[PID]

        if !TAB then continue end

        for NKEY, DATA in pairs(TAB) do
            if ( tonumber(DATA.Medal) == tonumber(UID) ) then
                table.insert(RLIST, NKEY)
            end
        end
        
        table.sort( RLIST, function(a, b) return a > b end )

        for k, v in ipairs(RLIST) do
            table.remove(RDV.MEDALS.P_TAB[PID], v)
        end
    end

    local q = RDV_Mysql:Delete("RDV_ADDON_MEDALS_V2")
        q:Where("M_MEDAL", UID)
    q:Execute()

    RDV.MEDALS.LIST[UID] = nil
    RDV.MEDALS.CACHE_LIST[M_NAME] = nil

    net.Start("RDV_MEDALS_DELETE")
        net.WriteUInt(UID, 32)
    net.Broadcast()

    RDV.MEDALS.Save()
end )

util.AddNetworkString("RDV_MEDALS_PDELETE")

net.Receive("RDV_MEDALS_PDELETE", function(_, P)
    if !RDV.MEDALS.CFG.Admins[P:GetUserGroup()] then SendNotification(P, RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

    local TAKE = net.ReadPlayer()
    local UID = net.ReadUInt(32)

    local PID = RDV.MEDALS.GetPlayerID(TAKE)
    local TAB = RDV.MEDALS.P_TAB[PID]
    local FOUND = false

    if !TAB then return end
    
    for k, v in pairs(TAB) do
        if ( tonumber(v.UID) == tonumber(UID) ) then
            table.remove(RDV.MEDALS.P_TAB[PID], k)

            FOUND = true
            continue
        end
    end

    if !FOUND then return end

    local q = RDV_Mysql:Delete("RDV_ADDON_MEDALS_V2")
        q:Where("M_RECEIVER", PID)
        q:Where("M_UID", UID)
    q:Execute()
end )