local color_Gold = Color(252,180,9,255)
local color_Grey = Color(122,132,137, 180)

LayoutCertifications = function() end
RefreshLoadouts = function() end

local function CreateLoadout(oldFrame, UID, CB)
    local DATA = {}

    local LIST = NCS_LOADOUTS.LIST
    
    if UID and LIST[UID] then
        DATA = table.Copy(LIST[UID])
    end

    DATA.teams = DATA.teams or {}
    DATA.noloadouts = DATA.noloadouts or {}
    DATA.weps = DATA.weps or {}
    DATA.models = DATA.models or {}
    DATA.steamids = DATA.steamids or {}
    
    if DATA.allteams == nil then
        DATA.allteams = true
    end

    DATA.certs = DATA.certs or {}

    if COPY then DATA.uid = nil end

    local F = vgui.Create("NCS_LOD_FRAME")
    F:MakePopup(true)
    F:SetSize(ScrW() * 0.35, ScrH() * 0.55)
    F:Center()
    F:SetTitle(NCS_LOADOUTS.GetLang(nil, "addonTitle"))
    F.OnRemove = function(s)
        if IsValid(oldFrame) then oldFrame:SetVisible(true) end
    end

    local w, h = F:GetSize()

    local S = vgui.Create("NCS_LOD_SCROLL", F)
    S:Dock(FILL)

    --[[----------------------------------------]]
    --  Name
    --]]----------------------------------------]]
    
    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutName"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
    local d_NAME = S:Add("DTextEntry")
    d_NAME:Dock(TOP)
    d_NAME:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    d_NAME.OnTextChanged = function(s)
        DATA.name = s:GetValue()
    end
    
    if DATA.name then
        d_NAME:SetValue(DATA.name)
    end

    --[[----------------------------------------]]
    --  Loadout Icon
    --]]----------------------------------------]]
    
    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutIcon"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
    local d_ICON = S:Add("DTextEntry")
    d_ICON:Dock(TOP)
    d_ICON:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    d_ICON.OnTextChanged = function(s)
        DATA.icon = s:GetValue()
    end
    
    if DATA.icon then
        d_ICON:SetValue(DATA.icon)
    end

    --[[----------------------------------------]]
    --  Loadout Health
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutHealth"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local HEALTH = S:Add("DTextEntry")
    HEALTH:Dock(TOP)
    HEALTH:SetNumeric(true)
    HEALTH:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    HEALTH.OnChange = function(s)
        local NUM = math.Round(s:GetValue(), 0)

        if NUM > 999999 then return end

        DATA.health = NUM
    end

    if DATA.health then
        HEALTH:SetValue(DATA.health)
    end

    --[[----------------------------------------]]
    --  Loadout Armor
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutArmor"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local ARMOR = S:Add("DTextEntry")
    ARMOR:Dock(TOP)
    ARMOR:SetNumeric(true)
    ARMOR:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    ARMOR.OnChange = function(s)
        local NUM = math.Round(s:GetValue(), 0)

        if NUM > 999999 then return end

        DATA.armor = NUM
    end
    if DATA.armor then
        ARMOR:SetValue(DATA.armor)
    end

    --[[----------------------------------------]]
    --  Loadout Salary
    --]]----------------------------------------]]

    if DarkRP then
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutSalary"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

        local SALARY = S:Add("DTextEntry")
        SALARY:Dock(TOP)
        SALARY:SetNumeric(true)
        SALARY:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

        SALARY.OnChange = function(s)
            local NUM = math.Round(s:GetValue(), 0)

            if NUM > 999999 then return end

            DATA.salary = NUM
        end

        if DATA.salary then
            SALARY:SetValue(DATA.salary)
        end
    end

    --[[----------------------------------------]]
    --  Team Availability
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "allTeamsEnabled"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local LABEL = S:Add("DLabel")
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.1)
    LABEL:Dock(TOP)
    LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    LABEL:SetMouseInputEnabled(true)

    local CHECK_L = LABEL:Add("DLabel")
    CHECK_L:SetMouseInputEnabled(true)
    CHECK_L:Dock(RIGHT)
    CHECK_L:SetText("")

    local CHECK = CHECK_L:Add("DCheckBox")
    CHECK:Center()
    CHECK.OnChange = function(s, val)
        DATA.allteams = val
    end

    if DATA.allteams then
        CHECK:SetChecked(true)
    end

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "teamAvailability"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local d_TEAMS = S:Add("DListView")
    d_TEAMS:Dock(TOP)
    d_TEAMS:SetTall(h * 0.3)
    d_TEAMS:AddColumn(NCS_LOADOUTS.GetLang(nil, "teamAvailability"), 1)
    d_TEAMS:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    for k, v in ipairs(team.GetAllTeams()) do
        local L = d_TEAMS:AddLine(v.Name)
        L.teamName = v.Name

        L.Think = function(s)
            if DATA.teams and DATA.teams[v.Name] then
                s:SetSelected(true)
            end
        end
        if DATA.teams and DATA.teams[v.Name] then
            L:SetSelected(true)
        end
    end

    d_TEAMS.OnRowSelected = function(s, ind, row)
        if DATA.allteams then
            row:SetSelected(false)
            return
        end

        DATA.teams[row.teamName] = true
    end
    
    d_TEAMS.OnRowRightClick = function(s, ind, row)
        row:SetSelected(false)
        DATA.teams[row.teamName] = nil
    end

    --[[----------------------------------------]]
    --  Certification Requirements
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "certRequirements"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local d_CERTS = S:Add("DListView")
    d_CERTS:Dock(TOP)
    d_CERTS:SetTall(h * 0.3)
    d_CERTS:AddColumn(NCS_LOADOUTS.GetLang(nil, "certRequirements"), 1)
    d_CERTS:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    NCS_LOADOUTS.GetConfigData(2, function(rData)
        if !IsValid(d_CERTS) then return end

        for k, v in pairs(rData) do
            local L = d_CERTS:AddLine(v.name)
            L.certIdent = v.uid
            L.Think = function(s) if DATA.certs[s.certIdent] then s:SetSelected(true) end end

            if DATA.certs and DATA.certs[v.uid] then
                L:SetSelected(true)
            end
        end
    end )

    d_CERTS.OnRowSelected = function(s, ind, row)
        DATA.certs[row.certIdent] = true
    end
    
    d_CERTS.OnRowRightClick = function(s, ind, row)
        row:SetSelected(false)
        DATA.certs[row.certIdent] = nil
    end

    --[[----------------------------------------]]
    --  SteamID Restriction
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "steamIDRestrict"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetMouseInputEnabled(true)

    local d_SteamID64Text
    local d_SteamID64List

    local LABEL_TOP = S:Add("DLabel")
    LABEL_TOP:Dock(TOP)
    LABEL_TOP:SetTall(LABEL_TOP:GetTall() * 1.5)
    LABEL_TOP:SetText("")
    LABEL_TOP:SetMouseInputEnabled(true)
    LABEL_TOP:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local ADD = LABEL_TOP:Add("DButton")
    ADD:SetImage("icon16/add.png")
    ADD:Dock(LEFT)
    ADD:SetText("")
    ADD:SetWide(ADD:GetWide() * 0.4)
    ADD.DoClick = function(s)
        local steamIDText = d_SteamID64Text:GetValue()

        if ( !steamIDText or steamIDText == "" ) then return end
        
        local newSteamID

        if !string.find(steamIDText, "STEAM") then
            newSteamID = util.SteamIDFrom64(steamIDText)

            if !newSteamID then return end
        else
            newSteamID = steamIDText
            steamIDText = util.SteamIDTo64(steamIDText)
        end
            
        steamworks.RequestPlayerInfo(steamIDText, function(name)
            local LINE = d_SteamID64List:AddLine(steamIDText, name)
            LINE.steamid = newSteamID
                    
            DATA.steamids[newSteamID] = true

            d_SteamID64Text:SetText("")
        end )
    end

    d_SteamID64Text = vgui.Create("DTextEntry", LABEL_TOP)
    d_SteamID64Text:Dock(LEFT)
    d_SteamID64Text:SetKeyboardInputEnabled(true)
    d_SteamID64Text:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "steamID"))
    d_SteamID64Text:SetWide(d_SteamID64Text:GetWide() * 2)

    local LABEL = vgui.Create("DLabel", S)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)
    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    LABEL:SetMouseInputEnabled(true)

    d_SteamID64List = vgui.Create("DListView", LABEL)
    d_SteamID64List:Dock(FILL)
    d_SteamID64List:AddColumn( NCS_LOADOUTS.GetLang(nil, "steamID"), 1 )
    d_SteamID64List:AddColumn( NCS_LOADOUTS.GetLang(nil, "steamName"), 2 )

    d_SteamID64List.OnRowRightClick = function(sm, ID, LINE)
        local WEP = LINE.steamid
        
        if DATA.steamids[WEP] then
            DATA.steamids[WEP] = nil
        end

        d_SteamID64List:RemoveLine(ID)
    end
    d_SteamID64List.OnRowSelected = function(_, I, ROW)
        ROW:SetSelected(false)
    end

    if DATA.steamids then
        for k, v in pairs(DATA.steamids) do
            local newSteamID = util.SteamIDTo64(k)
    
            if !newSteamID then return end

            print(k, newSteamID)
            steamworks.RequestPlayerInfo(newSteamID, function(name)
                local LINE = d_SteamID64List:AddLine(newSteamID, name)
                LINE.steamid = k
            end )
        end
    end

    --[[----------------------------------------]]
    --  Weapons
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutWeapons"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetMouseInputEnabled(true)

    local d_WEAPONS
    local d_WEAPONSL

    local LABEL_TOP = S:Add("DLabel")
    LABEL_TOP:Dock(TOP)
    LABEL_TOP:SetTall(LABEL_TOP:GetTall() * 1.5)
    LABEL_TOP:SetText("")
    LABEL_TOP:SetMouseInputEnabled(true)
    LABEL_TOP:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local ADD = LABEL_TOP:Add("DButton")
    ADD:SetImage("icon16/add.png")
    ADD:Dock(LEFT)
    ADD:SetText("")
    ADD:SetWide(ADD:GetWide() * 0.4)
    ADD.DoClick = function(s)
        local WEP = d_WEAPONS:GetValue()

        if ( !WEP or WEP == "" ) then return end

        local swepTab = weapons.Get(WEP)

        if !swepTab then return end

        local LINE = d_WEAPONSL:AddLine(WEP, swepTab.PrintName)
        LINE.WEAPON = WEP

        DATA.weps[WEP] = true

        d_WEAPONS:SetText("")
    end

    d_WEAPONS = vgui.Create("DTextEntry", LABEL_TOP)
    d_WEAPONS:Dock(LEFT)
    d_WEAPONS:SetKeyboardInputEnabled(true)
    d_WEAPONS:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "weaponClass"))
    d_WEAPONS:SetWide(d_WEAPONS:GetWide() * 2)

    local LABEL = vgui.Create("DLabel", S)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)
    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    LABEL:SetMouseInputEnabled(true)

    d_WEAPONSL = vgui.Create("DListView", LABEL)
    d_WEAPONSL:Dock(FILL)
    d_WEAPONSL:AddColumn( NCS_LOADOUTS.GetLang(nil, "weaponName"), 1 )
    d_WEAPONSL:AddColumn( NCS_LOADOUTS.GetLang(nil, "weaponClass"), 2 )

    d_WEAPONSL.OnRowRightClick = function(sm, ID, LINE)
        local WEP = LINE.WEAPON
        
        if DATA.weps[WEP] then
            DATA.weps[WEP] = nil
        end

        d_WEAPONSL:RemoveLine(ID)
    end
    d_WEAPONSL.OnRowSelected = function(_, I, ROW)
        ROW:SetSelected(false)
    end

    if DATA.weps then
        for k, v in pairs(DATA.weps) do
            local WEP = weapons.Get(k)

            if !WEP then continue end

            local LINE = d_WEAPONSL:AddLine(k, WEP.PrintName)
            LINE.WEAPON = k
        end
    end

    --[[----------------------------------------]]
    --  Loadout Models
    --]]----------------------------------------]]

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutModels"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetMouseInputEnabled(true)

    local d_ModelTextEntry
    local d_ModelListView
    local d_TeamTextEntry

    local LABEL_TOP = S:Add("DLabel")
    LABEL_TOP:Dock(TOP)
    LABEL_TOP:SetTall(LABEL_TOP:GetTall() * 1.5)
    LABEL_TOP:SetText("")
    LABEL_TOP:SetMouseInputEnabled(true)
    LABEL_TOP:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local ADD = LABEL_TOP:Add("DButton")
    ADD:SetImage("icon16/add.png")
    ADD:Dock(LEFT)
    ADD:SetText("")
    ADD:SetWide(ADD:GetWide() * 0.4)
    ADD.DoClick = function(s)
        local MODEL = d_ModelTextEntry:GetValue()

        if ( !MODEL or MODEL == "" ) then return end

        local T, DT = d_TeamTextEntry:GetSelected()

        DATA.models[MODEL] = DATA.models[MODEL] or {
            teams = {},
        }

        if DT then
            if DT == "ALL" then
                for k, v in pairs(team.GetAllTeams()) do
                    DATA.models[MODEL].teams[v.Name] = true
                end
            else
                DATA.models[MODEL].teams[T] = true
            end
        else
            if !RPExtraTeams then return end

            for k, v in pairs(RPExtraTeams) do
                if ( T == v.category ) then
                    DATA.models[MODEL].teams[v.name] = true
                end
            end
        end

        for k, v in ipairs(d_ModelListView:GetLines()) do
            if v.MODEL == MODEL then d_ModelListView:RemoveLine(k) end
        end

        local LINE = d_ModelListView:AddLine(MODEL, table.Count(DATA.models[MODEL].teams))
        LINE.MODEL = MODEL
    end

    d_ModelTextEntry = vgui.Create("DTextEntry", LABEL_TOP)
    d_ModelTextEntry:Dock(LEFT)
    d_ModelTextEntry:SetKeyboardInputEnabled(true)
    d_ModelTextEntry:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "modelPath"))
    d_ModelTextEntry:SetWide(d_ModelTextEntry:GetWide() * 2)

    d_TeamTextEntry = vgui.Create("DComboBox", LABEL_TOP)
    d_TeamTextEntry:Dock(RIGHT)
    d_TeamTextEntry:SetText(NCS_LOADOUTS.GetLang(nil, "selectTeams"))
    d_TeamTextEntry:SetWide(d_TeamTextEntry:GetWide() * 2)

    local addedCats = {}

    local tabRun

    if RPExtraTeams then
        tabRun = RPExtraTeams
    else
        tabRun = team.GetAllTeams()
    end

    for k, v in pairs(tabRun) do
        d_TeamTextEntry:AddChoice((( RPExtraTeams and v.name ) or v.Name ), k)

        if RPExtraTeams and !addedCats[v.category] then
            addedCats[v.category] = true

            d_TeamTextEntry:AddChoice(v.category)
        end
    end

    d_TeamTextEntry:AddChoice(NCS_LOADOUTS.GetLang(nil, "allTeams"), "ALL")


    local LABEL = vgui.Create("DLabel", S)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)
    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    LABEL:SetMouseInputEnabled(true)

    d_ModelListView = vgui.Create("DListView", LABEL)
    d_ModelListView:Dock(FILL)
    d_ModelListView:AddColumn( NCS_LOADOUTS.GetLang(nil, "modelPath"), 1 )
    d_ModelListView:AddColumn( NCS_LOADOUTS.GetLang(nil, "teamCount"), 2 )

    d_ModelListView.OnRowRightClick = function(sm, ID, LINE)
        local MODEL = LINE.MODEL
        
        if DATA.models[MODEL] then
            DATA.models[MODEL] = nil
        end

        d_ModelListView:RemoveLine(ID)
    end
    d_ModelListView.OnRowSelected = function(_, I, ROW)
        ROW:SetSelected(false)
    end

    if DATA.models then
        for modelClass, info in pairs(DATA.models) do
            local LINE = d_ModelListView:AddLine(modelClass, table.Count(info.teams))
            LINE.MODEL = modelClass
        end
    end

    --
    local LABEL_customCode = S:Add("DLabel")
    LABEL_customCode:SetText(NCS_LOADOUTS.GetLang(nil, "customCodeExecute"))
    LABEL_customCode:Dock(TOP)
    LABEL_customCode:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
    local TEXTE_customCode = S:Add("DTextEntry")
    TEXTE_customCode:SetMultiline(true)
    TEXTE_customCode:Dock(TOP)
    TEXTE_customCode:SetTall(h * 0.1)
    TEXTE_customCode:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    TEXTE_customCode.OnTextChanged = function(s)
        DATA.customcode = s:GetValue()
    end
    
    if DATA.customcode then
        TEXTE_customCode:SetValue(DATA.customcode)
    end

    --[[----------------------------------------]]
    --  Final Submit
    --]]----------------------------------------]]

    local SUBMIT = vgui.Create("NCS_LOD_TextButton", F)
    SUBMIT:Dock(BOTTOM)
    SUBMIT:SetTall(h * 0.1)
    SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
    SUBMIT:SetText(NCS_LOADOUTS.GetLang(nil, "submitLabel"))
    SUBMIT.DoClick = function()
        if !DATA.icon or ( string.Trim(DATA.icon) == "" ) then DATA.icon = "Hk1RYWm" end

        if !DATA.name or ( string.Trim(DATA.name) == "" ) then return end

        if table.Count(DATA.teams) <= 0 then DATA.teams = false end
        if table.Count(DATA.models) <= 0 then DATA.models = false end
        if table.Count(DATA.weps) <= 0 then DATA.weps = false end

        if DATA.allteams then DATA.teams = false end

        local json = util.TableToJSON(DATA)
        local compressed = util.Compress(json)
        local length = compressed:len()
    
        net.Start("NCS_LOADOUTS_AddLoadout")
            net.WriteUInt(length, 32)
            net.WriteData(compressed, length)
        net.SendToServer()

        F:Remove()
    end
end

--[[----------------------------------------]]
--  Loadout Refreshing (Admin Menu)
--]]----------------------------------------]]

local panelLoadouts
local frameLoadouts
local loadoutsCount = 0

--[[----------------------------------------]]
--  Delete Loadout Data
--]]----------------------------------------]]

--[[----------------------------------------]]
--  Core Admin Menu
--]]----------------------------------------]]

local waitingPlayerCerts = {}

hook.Add("NCS_LOADOUTS_CertificationsUpdated", "NCS_LOADOUTS_RefreshMenu", function()
    if LayoutCertifications and isfunction(LayoutCertifications) then
        LayoutCertifications()
    end
end )

hook.Add("NCS_LOADOUTS_LoadoutsUpdated", "NCS_LOADOUTS_RefreshMenu", function()
    if RefreshLoadouts and isfunction(RefreshLoadouts) then
        RefreshLoadouts()
    end
end )

net.Receive("NCS_LOADOUTS_GetPlayerCerts", function()
    local PID = net.ReadUInt(8)

    if waitingPlayerCerts[PID] and isfunction(waitingPlayerCerts[PID]) then
        waitingPlayerCerts[PID](net.ReadTable())
    end
end )

local function AdmLoadout(oldFrame)
    local F = vgui.Create("NCS_LOD_FRAME")
    F:MakePopup(true)
    F:SetSize(ScrW() * 0.35, ScrH() * 0.55)
    F:Center()
    F:SetTitle(NCS_LOADOUTS.GetLang(nil, "addonTitle"))
    F.OnRemove = function(s)
        if IsValid(oldFrame) then oldFrame:SetVisible(true) oldFrame:RefreshLoadouts() end
    end

    local SB = F:Add("NCS_LOD_SIDEBAR")
    local w, h = F:GetSize()

    local M_PANEL = F:Add("DPanel")
    M_PANEL:Dock(FILL)
    M_PANEL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    M_PANEL.Paint = function() end

    --[[----------------------------------------]]
    --  Settings Menu
    --]]----------------------------------------]]

    NCS_LOADOUTS.IsAdmin(LocalPlayer(), function(ACCESS)
        local newAccess = ACCESS

        local B, R = nil, nil

        if RDV and RDV.RANK then
            B = RDV.RANK.GetPlayerRankTree(LocalPlayer())
            R = RDV.RANK.GetPlayerRank(LocalPlayer())
        elseif MRS then
            B = MRS.GetPlayerGroup(LocalPlayer():Team())
            R = MRS.GetPlyRank(LocalPlayer(), B)
        end

        if NCS_LOADOUTS.CONFIG.ranks and table.Count(NCS_LOADOUTS.CONFIG.ranks) > 0 and NCS_LOADOUTS.CONFIG.ranks[B] then
            if ( NCS_LOADOUTS.CONFIG.ranks[B] <= R ) then 
                newAccess = true
            end
        end

        if NCS_LOADOUTS.CONFIG.teamrestrictcerts and table.Count(NCS_LOADOUTS.CONFIG.teamrestrictcerts) > 0 and NCS_LOADOUTS.CONFIG.teamrestrictcerts[team.GetName(LocalPlayer():Team())] then
            newAccess = true
        end

        if ACCESS or newAccess then
            SB:AddPage(NCS_LOADOUTS.GetLang(nil, "playersLabel"), "cEmntWn", function()
                M_PANEL:Clear()

                local SP = M_PANEL:Add("NCS_LOD_SCROLL")
                SP:Dock(FILL)

                SP.OnSizeChanged = function()
                    SP:Clear()

                    for k, v in ipairs(player.GetAll()) do        
                        local LB = SP:Add("DLabel")
                        LB:SetText("")
                        LB:SetTall(h * 0.1)
                        LB:Dock(TOP)
                        LB:SetMouseInputEnabled(true)
                        LB:DockMargin(0, 0, 0, h * 0.025)

                        LB.Paint = function(self, w, h)
                            if IsValid(v) and v.Name then
                                draw.SimpleText(v:Name(), "NCS_LOD_FRAME_TITLE", w * 0.25, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            else
                                self:Remove()
                                return
                            end
                
                            surface.SetDrawColor(color_Grey)

                            surface.DrawOutlinedRect(0, 0, w, h)
                        end

                        local w, h = SP:GetSize()

                        local IC_PAD = LB:Add("DLabel")
                        IC_PAD:Dock(LEFT)
                        IC_PAD:SetWide(w * 0.15)
                        IC_PAD:DockPadding(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
                        IC_PAD:SetText("")

                        local SICON = IC_PAD:Add("AvatarImage")
                        SICON:Dock( FILL )
                        SICON:SetPlayer( v, 64 )
                        SICON.Paint = function(self, w, h)
                            surface.SetDrawColor(color_Grey)
                            surface.DrawOutlinedRect(0, 0, w, h)
                        end

                        local ICON_EDIT = LB:Add("NCS_LOD_IMGUR")
                        ICON_EDIT:Dock(RIGHT)
                        ICON_EDIT:SetImgurID("hZtHCPZ")
                        ICON_EDIT:SetImageSize(5)
                        ICON_EDIT:SetWide(w * 0.1)

                        ICON_EDIT:SetHoverColor(color_Gold)
                        ICON_EDIT.DoClick = function()
                            local MenuButtonOptions = DermaMenu() -- Creates the menu
                            MenuButtonOptions:SetParent(ICON_EDIT)
                            
                            NCS_LOADOUTS.GetConfigData(2, function(r_Data)
                                local function RequestPlayerCerts(P, CALLBACK)
                                    if !IsValid(P) then return end
                                    
                                    net.Start("NCS_LOADOUTS_GetPlayerCerts")
                                        net.WriteUInt(P:UserID(), 8)
                                    net.SendToServer()

                                    waitingPlayerCerts[P:UserID()] = CALLBACK
                                end

                                RequestPlayerCerts(v, function(P_DATA)
                                    if !IsValid(MenuButtonOptions) then return end
                                    if !IsValid(v) then return end

                                    for _, d in pairs(r_Data) do
                                        local O = MenuButtonOptions:AddOption(d.name, function()
                                            net.Start("NCS_LOADOUTS_GivePlayerCert")
                                                net.WriteUInt(v:UserID(), 8)
                                                net.WriteUInt(d.uid, 16)
                                            net.SendToServer()
                                        end )

                                        if P_DATA[d.uid] then
                                            O:SetChecked(true)
                                        end
                                    end
                                end )
                            end )

                            MenuButtonOptions:Open()
                        end
                        ICON_EDIT.OnCursorEntered = function(s)
                            surface.PlaySound("ncs/ui/slider.mp3")
                        end
                    end
                end
            end )
        end

        if ACCESS then
            SB:AddPage(NCS_LOADOUTS.GetLang(nil, "settingsLabel"), "svNpHqn", function()
                M_PANEL:Clear()

                local DATA = table.Copy(NCS_LOADOUTS.CONFIG)
                
                local S = M_PANEL:Add("NCS_LOD_SCROLL")
                S:Dock(FILL)


                -- Language Systems
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "addonLang"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            
                local LANG = S:Add("DComboBox")
                LANG:Dock(TOP)
                LANG:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                LANG.OnSelect = function(s, IND, VAL)
                    DATA.langset = VAL
                end
            
                for k, v in pairs(NCS_LOADOUTS.GetLanguages()) do
                    local OPT = LANG:AddChoice(k)
            
                    if ( DATA.langset == k ) then
                        LANG:ChooseOption(k, OPT)
                    end
                end

                -- Characters
                    local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "characterSystem"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            
                local CHAR = S:Add("DComboBox")
                CHAR:Dock(TOP)
                CHAR:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            
                local IND = CHAR:AddChoice("Disabled", false)
                CHAR:ChooseOptionID(IND)
                
                CHAR.OnSelect = function(s, IND, VAL, S_VAL)
                    DATA.charsysselected = S_VAL or false
                end
            
                for k, v in pairs(NCS_LOADOUTS.CharSystems) do
                    local OPT = CHAR:AddChoice(k, k)
            
                    if ( DATA.charsysselected == k ) then
                        CHAR:ChooseOptionID(OPT)
                    end
                end

                -- Vendor Model
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "vendorModel"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                local d_PREFIXT = S:Add("DTextEntry")
                d_PREFIXT:Dock(TOP)
                d_PREFIXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                d_PREFIXT.OnTextChanged = function(s)
                    DATA.vendormodel = s:GetValue()
                end
                
                if DATA.vendormodel then
                    d_PREFIXT:SetValue(DATA.vendormodel)
                end

                -- Menu Command
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "menuCommand"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                local d_PREFIXT = S:Add("DTextEntry")
                d_PREFIXT:Dock(TOP)
                d_PREFIXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                d_PREFIXT.OnTextChanged = function(s)
                    DATA.menucommand = s:GetValue()
                end
                
                if DATA.menucommand then
                    d_PREFIXT:SetValue(DATA.menucommand)
                end

                -- Save Vendor Command
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "saveVendorCommand"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                local d_PREFIXT = S:Add("DTextEntry")
                d_PREFIXT:Dock(TOP)
                d_PREFIXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                d_PREFIXT.OnTextChanged = function(s)
                    DATA.savevendorcommand = s:GetValue()
                end
                
                if DATA.savevendorcommand then
                    d_PREFIXT:SetValue(DATA.savevendorcommand)
                end

                -- Access Options
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "accessOptions"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local openTypeLabel = S:Add("DPanel")
                openTypeLabel:Dock(TOP)
                openTypeLabel:SetHeight(h * 0.1)
                openTypeLabel:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                openTypeLabel.Paint = function() end

                local OPTIONS = {[1] = "allAccessible", [2] = "onlyCommand", [3] = "onlyVendor"}

                for k, v in ipairs(OPTIONS) do
                    local NAME = NCS_LOADOUTS.GetLang(nil, v)

                    local optionSubmenu = openTypeLabel:Add("DButton")
                    optionSubmenu:Dock(LEFT)
                    optionSubmenu:SetText(" ")
                    optionSubmenu:SetWide(w * 0.1875)
                    optionSubmenu.DoClick = function(s)
                        surface.PlaySound("ncs/ui/activate.mp3")
                        
                        DATA.accessoption = k
                    end
                    optionSubmenu.Paint = function(s, w, h)
                        surface.SetDrawColor(color_Grey)
                        surface.DrawOutlinedRect( 0, 0, w, h )
                        draw.SimpleText(NAME, "NCS_LOD_DESCRIPTION", w * 0.5, h * 0.5, ( (DATA.accessoption == k ) and color_Gold ) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                        if DATA.accessoption == k then
                            draw.RoundedBox(0, 0, h * 0.95, w, h * 0.05, color_Gold)
                        end
                    end
                end

                -- Prefix
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "prefixText"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                local d_PREFIXT = S:Add("DTextEntry")
                d_PREFIXT:Dock(TOP)
                d_PREFIXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                d_PREFIXT.OnTextChanged = function(s)
                    DATA.prefixtext = s:GetValue()
                end
                
                if DATA.prefixtext then
                    d_PREFIXT:SetValue(DATA.prefixtext)
                end

                -- Color
                
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "prefixColor"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                local d_prefixColor = S:Add("DColorMixer")
                d_prefixColor:Dock(TOP)
                d_prefixColor:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                
                if DATA.prefixcolor then
                    local C = DATA.prefixcolor
                
                    if C.r and C.g and C.b then
                        C = Color(C.r, C.g, C.b)
                        d_prefixColor:SetColor(DATA.prefixcolor)
                    end
                else
                    d_prefixColor:SetColor(Color(255,0,0))
                end
                
                d_prefixColor.Think = function(s)
                    DATA.prefixcolor = s:GetColor()
                end

                -- Ranks

                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "rankRestrictCerts"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local BRANCH
                local RANK
                local vgui_rankMenu
            
                local LABEL = S:Add("DLabel")
                LABEL:Dock(TOP)
                LABEL:SetTall(LABEL:GetTall() * 1.5)
                LABEL:SetText("")
                LABEL:SetMouseInputEnabled(true)
                LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local ADD = LABEL:Add("DButton", LABEL)
                ADD:SetImage("icon16/add.png")
                ADD:Dock(LEFT)
                ADD:SetText("")
                ADD:SetWide(ADD:GetWide() * 0.4)
                ADD.DoClick = function(s)
                    local S_BRANCH = BRANCH:GetValue()
                    local S_RANK = tonumber(RANK:GetValue())
            
                    if ( !S_BRANCH or string.Trim(S_BRANCH) == "" ) or ( !S_RANK or string.Trim(S_RANK) == "" ) then return end
            
                    local LINE = vgui_rankMenu:AddLine(S_BRANCH, S_RANK)
                    LINE.BRANCH = S_BRANCH
                    LINE.RANK = S_RANK

                    DATA.ranks[S_BRANCH] = S_RANK
                end
            
                BRANCH = vgui.Create("DTextEntry", LABEL)
                BRANCH:Dock(LEFT)
                BRANCH:SetKeyboardInputEnabled(true)
                BRANCH:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "branchLabel"))
                BRANCH:SetWide(BRANCH:GetWide() * 2)
            
                RANK = vgui.Create("DTextEntry", LABEL)
                RANK:Dock(LEFT)
                RANK:SetKeyboardInputEnabled(true)
                RANK:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "rankLabel"))
                RANK:SetWide(RANK:GetWide() * 2)
                RANK:SetNumeric(true)
            
                local LABEL = vgui.Create("DLabel", S)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.3)
                LABEL:Dock(TOP)
                LABEL:SetMouseInputEnabled(true)
            
                vgui_rankMenu = vgui.Create("DListView", LABEL)
                vgui_rankMenu:Dock(FILL)
                vgui_rankMenu:AddColumn( NCS_LOADOUTS.GetLang(nil, "branchLabel"), 1 )
                vgui_rankMenu:AddColumn( NCS_LOADOUTS.GetLang(nil, "rankLabel"), 2 )
                vgui_rankMenu:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                vgui_rankMenu.OnRowRightClick = function(sm, ID, LINE)
                    local BR = LINE.BRANCH
            
                    if DATA.ranks[BR] then
                        DATA.ranks[BR] = nil
                    end
            
                    vgui_rankMenu:RemoveLine(ID)
                end
            
                if DATA.ranks then
                    for k, v in pairs(DATA.ranks) do
                        local LINE = vgui_rankMenu:AddLine(k, v)
                        LINE.BRANCH = k
                        LINE.RANK = v
                    end
                end

                -- Teams Permissions

                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "teamRestrictCerts"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            
                local LABEL = vgui.Create("DLabel", S)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.3)
                LABEL:Dock(TOP)
                LABEL:SetMouseInputEnabled(true)

                local V_teamRestrictCerts = LABEL:Add("DListView")
                V_teamRestrictCerts:Dock(FILL)
                V_teamRestrictCerts:AddColumn( NCS_LOADOUTS.GetLang(nil, "teamRestrictCerts"), 1 )
                V_teamRestrictCerts:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)


                V_teamRestrictCerts.OnRowRightClick = function(sm, ID, LINE)
                    local BR = LINE.TEAM
            
                    if DATA.teamrestrictcerts and DATA.teamrestrictcerts[BR] then
                        DATA.teamrestrictcerts[BR] = nil
                    end
            
                    LINE:SetSelected(false)
                end
                V_teamRestrictCerts.OnRowSelected = function(s, _, LINE)
                    local BR = LINE.TEAM

                    DATA.teamrestrictcerts = DATA.teamrestrictcerts or {}
                    DATA.teamrestrictcerts[BR] = true
                end

                for k, v in pairs(team.GetAllTeams()) do
                    local LINE = V_teamRestrictCerts:AddLine(v.Name)
                    LINE.TEAM = v.Name

                    if DATA.teamrestrictcerts and DATA.teamrestrictcerts[v.Name] then
                        LINE:SetSelected(true)
                    end

                    LINE.PaintOver = function(s)
                        DATA.teamrestrictcerts = DATA.teamrestrictcerts  or {}

                        if !DATA.teamrestrictcerts[v.Name] then
                            LINE:SetSelected(false)
                        else
                            LINE:SetSelected(true)
                        end
                    end
                end

                -- Cami Time
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "showdisabledloadouts"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local LABEL = S:Add("DLabel")
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.1)
                LABEL:Dock(TOP)
                LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                LABEL:SetMouseInputEnabled(true)

                local CHECK_L = LABEL:Add("DLabel")
                CHECK_L:SetMouseInputEnabled(true)
                CHECK_L:Dock(RIGHT)
                CHECK_L:SetText("")

                local CHECK = CHECK_L:Add("DCheckBox")
                CHECK:Center()
                CHECK.OnChange = function(s, val)
                    DATA.showdisabled = val
                end

                if DATA.showdisabled then
                    CHECK:SetChecked(true)
                end

                --[[----------------------------------------]]
                --  Forced Respawn
                --]]----------------------------------------]]

                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "forcedRespawn"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local LABEL = S:Add("DLabel")
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.1)
                LABEL:Dock(TOP)
                LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                LABEL:SetMouseInputEnabled(true)

                local CHECK_L = LABEL:Add("DLabel")
                CHECK_L:SetMouseInputEnabled(true)
                CHECK_L:Dock(RIGHT)
                CHECK_L:SetText("")

                local CHECK = CHECK_L:Add("DCheckBox")
                CHECK:Center()
                CHECK.OnChange = function(s, val)
                    DATA.forcedrespawn = val
                end

                if DATA.forcedrespawn then
                    CHECK:SetChecked(true)
                end

                local SUBMIT = vgui.Create("NCS_LOD_TextButton", M_PANEL)
                SUBMIT:Dock(BOTTOM)
                SUBMIT:SetTall(h * 0.1)
                SUBMIT:DockMargin(0, h * 0.02, 0, 0)
                SUBMIT:SetText(NCS_LOADOUTS.GetLang(nil, "saveSettings"))
                SUBMIT.DoClick = function()
                    local json = util.TableToJSON(DATA)
                    local compressed = util.Compress(json)
                    local length = compressed:len()
                
                    net.Start("NCS_LOADOUTS_UpdateSettings")
                        net.WriteUInt(length, 32)
                        net.WriteData(compressed, length)
                    net.SendToServer()
                end
            end )

            --[[----------------------------------------]]
            --  Admins Menu
            --]]----------------------------------------]]

            SB:AddPage(NCS_LOADOUTS.GetLang(nil, "adminLabel"), "6JrFWlz", function()
                if IsValid(M_PANEL) then
                    M_PANEL:Clear()
                end

                local DATA = table.Copy(NCS_LOADOUTS.CONFIG)

                local NoCAMIFuckU
                local NoCAMIDerma = {}

                local w, h = F:GetSize()

                local S = vgui.Create("NCS_LOD_SCROLL", M_PANEL)
                S:Dock(FILL)

                -- Cami Time
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "camiEnabled"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local LABEL = S:Add("DLabel")
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.1)
                LABEL:Dock(TOP)
                LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                LABEL:SetMouseInputEnabled(true)

                local CHECK_L = LABEL:Add("DLabel")
                CHECK_L:SetMouseInputEnabled(true)
                CHECK_L:Dock(RIGHT)
                CHECK_L:SetText("")

                local CHECK = CHECK_L:Add("DCheckBox")
                CHECK:Center()
                CHECK.OnChange = function(s, val)
                    DATA.camienabled = val

                    if !val then
                        NoCAMIFuckU()
                    else
                        for k, v in ipairs(NoCAMIDerma) do
                            if IsValid(v) then v:Remove() end
                        end

                        NoCAMIDerma = {}
                    end
                end

                if DATA.camienabled then
                    CHECK:SetChecked(true)
                end

                -- No Cami
                
                NoCAMIFuckU = function()
                    local M_LABEL = S:Add("DLabel")
                    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "adminGroups"))
                    M_LABEL:Dock(TOP)
                    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    M_LABEL:SetMouseInputEnabled(true)

                    local TX_USERGROUP
                    local TX_UGLIST
                
                    local LABEL_TOP = S:Add("DLabel")
                    LABEL_TOP:Dock(TOP)
                    LABEL_TOP:SetTall(LABEL_TOP:GetTall() * 1.5)
                    LABEL_TOP:SetText("")
                    LABEL_TOP:SetMouseInputEnabled(true)
                    LABEL_TOP:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                    local ADD = LABEL_TOP:Add("DButton")
                    ADD:SetImage("icon16/add.png")
                    ADD:Dock(LEFT)
                    ADD:SetText("")
                    ADD:SetWide(ADD:GetWide() * 0.4)
                    ADD.DoClick = function(s)
                        local UG = TX_USERGROUP:GetValue()
                
                        if ( !UG or UG == "" ) then return end
                
                        local LINE = TX_UGLIST:AddLine(UG, LocalPlayer():SteamID64())
                        LINE.USERGROUP = UG

                        DATA.admins[UG] = LocalPlayer():SteamID64()

                        TX_USERGROUP:SetText("")
                    end
                
                    TX_USERGROUP = vgui.Create("DTextEntry", LABEL_TOP)
                    TX_USERGROUP:Dock(LEFT)
                    TX_USERGROUP:SetKeyboardInputEnabled(true)
                    TX_USERGROUP:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "adminGroups"))
                    TX_USERGROUP:SetWide(TX_USERGROUP:GetWide() * 2)
                
                    local LABEL = vgui.Create("DLabel", S)
                    LABEL:SetText("")
                    LABEL:SetHeight(h * 0.3)
                    LABEL:Dock(TOP)
                    LABEL:SetMouseInputEnabled(true)
                    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    LABEL:SetMouseInputEnabled(true)

                    table.insert(NoCAMIDerma, M_LABEL)
                    table.insert(NoCAMIDerma, LABEL_TOP)
                    table.insert(NoCAMIDerma, LABEL)

                    TX_UGLIST = vgui.Create("DListView", LABEL)
                    TX_UGLIST:Dock(FILL)
                    TX_UGLIST:AddColumn( NCS_LOADOUTS.GetLang(nil, "adminGroups"), 1 )
                    TX_UGLIST:AddColumn( NCS_LOADOUTS.GetLang(nil, "addedBy"), 2 )

                    TX_UGLIST.OnRowRightClick = function(sm, ID, LINE)
                        local UG = LINE.USERGROUP
                        
                        if ( UG == "superadmin" ) then return end

                        if DATA.admins[UG] then
                            DATA.admins[UG] = nil
                        end
                
                        TX_UGLIST:RemoveLine(ID)
                    end
                    TX_UGLIST.OnRowSelected = function(_, I, ROW)
                        ROW:SetSelected(false)
                    end

                    if DATA.admins then
                        for k, v in pairs(DATA.admins) do
                            local LINE = TX_UGLIST:AddLine(k, v)
                            LINE.USERGROUP = k
                            LINE.ADDEDBY = v
                        end
                    end
                end

                if !DATA.camienabled then
                    NoCAMIFuckU()
                end

                local SUBMIT = vgui.Create("NCS_LOD_TextButton", M_PANEL)
                SUBMIT:Dock(BOTTOM)
                SUBMIT:SetTall(h * 0.1)
                SUBMIT:DockMargin(0, h * 0.02, 0, 0)
                SUBMIT:SetText(NCS_LOADOUTS.GetLang(nil, "saveSettings"))
                SUBMIT.DoClick = function()
                    local json = util.TableToJSON(DATA)
                    local compressed = util.Compress(json)
                    local length = compressed:len()
                
                    net.Start("NCS_LOADOUTS_UpdateSettings")
                        net.WriteUInt(length, 32)
                        net.WriteData(compressed, length)
                    net.SendToServer()
                end
            end )

            --[[----------------------------------------]]
            --  Loadouts Menu
            --]]----------------------------------------]]

            SB:AddPage("Loadouts", "x53KTMQ", function()
                local loadoutsCount = 0

                M_PANEL:Clear()
                
                local SP = M_PANEL:Add("NCS_LOD_SCROLL")
                SP:Dock(FILL)
                SP:DockMargin(0, 0, 0, h * 0.025)

                SP.PaintOver = function(s, w, h)
                    if loadoutsCount <= 0 then
                        draw.SimpleText(NCS_LOADOUTS.GetLang(nil, "noAvailableLoadouts"), "NCS_LOD_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end

                local panelLoadouts = SP
                local frameLoadouts = F

                RefreshLoadouts = function()
                    loadoutsCount = 0

                
                    local w, h = F:GetSize()
                    
                    if IsValid(panelLoadouts) then
                        NCS_LOADOUTS.GetConfigData(1, function(DATA)
                            panelLoadouts:Clear()

                            for k, v in pairs(DATA) do
                                loadoutsCount = loadoutsCount + 1
                
                                local LB = SP:Add("DPanel")
                                LB:SetText(k)
                                LB:SetTall(h * 0.1)
                                LB:Dock(TOP)
                                LB:DockMargin(0, 0, 0, h * 0.025)
                        
                                LB.Paint = function(self, w, h)
                                    surface.SetDrawColor(color_Grey)
                                    surface.DrawOutlinedRect(0, 0, w, h)
                        
                                    if v.name then
                                        draw.SimpleText(v.name, "NCS_LOD_FRAME_TITLE", w * 0.25, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                    end
                                end
                                local w, h = SP:GetSize()

                                if v.icon then
                                    local ICON = LB:Add("NCS_LOD_IMGUR")
                                    ICON:Dock(LEFT)
                                    ICON:SetImgurID(v.icon)
                                    ICON:SetNormalColor(Color(255,0,0))
                                    ICON:SetImageSize(5)
                                    ICON:SetWide(w * 0.125)
                                    ICON:SetMouseInputEnabled(false)
                                    ICON.PaintOver = function(s, w, h)
                                        surface.SetDrawColor(color_Grey)
                                        surface.DrawOutlinedRect(0, 0, w, h)
                                    end
                                end
                                
                                
                                local ICON_EDIT = LB:Add("NCS_LOD_IMGUR")
                                ICON_EDIT:Dock(RIGHT)
                                ICON_EDIT:SetImgurID("iYVNWgE")
                                ICON_EDIT:SetImageSize(3)
                                ICON_EDIT:SetHoverColor(color_Gold)
                                ICON_EDIT:SetWide(w * 0.1)

                                ICON_EDIT.DoClick = function()
                                    F:SetVisible(false)
                
                                    CreateLoadout(F, v.uid)
                                end
                                ICON_EDIT.OnCursorEntered = function(s)
                                    surface.PlaySound("ncs/ui/slider.mp3")
                                end
                
                                local ICON_TRASH = LB:Add("NCS_LOD_IMGUR")
                                ICON_TRASH:Dock(RIGHT)
                                ICON_TRASH:SetImgurID("r40KL7Z")
                                ICON_TRASH:SetImageSize(3)
                                ICON_TRASH:SetWide(w * 0.1)

                                ICON_TRASH:SetHoverColor(color_Gold)
                                ICON_TRASH.DoClick = function()
                                    net.Start("NCS_LOADOUTS_DelLoadout")
                                        net.WriteUInt(k, 16)
                                    net.SendToServer()
                
                                    LB:Remove()
                                end
                                ICON_TRASH.OnCursorEntered = function(s)
                                    surface.PlaySound("ncs/ui/slider.mp3")
                                end
                            end
                        end )
                    end
                end

                SP.OnSizeChanged = function()
                    SP:Clear()

                    RefreshLoadouts()
                end

                local AddLoadout = M_PANEL:Add("NCS_LOD_TextButton")
                AddLoadout:SetText(NCS_LOADOUTS.GetLang(nil, "addLoadout"))
                AddLoadout:Dock(BOTTOM)
                AddLoadout:SetTall(h * 0.1)

                AddLoadout.DoClick = function(s)
                    CreateLoadout(F)

                    F:SetVisible(false)
                end
            end )

            --[[----------------------------------------]]
            --  Certifications Menu (Core)
            --]]----------------------------------------]]

            SB:AddPage("Certs", "UGpxlzI", function()
                M_PANEL:Clear()
                
                local certCount = 0
                local CreateCertification

                local SP = M_PANEL:Add("NCS_LOD_SCROLL")
                SP:Dock(FILL)
                SP:DockMargin(0, 0, 0, h * 0.025)

                SP.PaintOver = function(s, w, h)
                    if certCount <= 0 then
                        draw.SimpleText(NCS_LOADOUTS.GetLang(nil, "noAvailableCerts"), "NCS_LOD_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                end

                --[[----------------------------------------]]
                --  Network Retrieval
                --]]----------------------------------------]]

                LayoutCertifications = function()
                    SP:Clear()

                    certCount = 0
            
                    for k, v in pairs(NCS_LOADOUTS.CERTS) do
                        certCount = certCount + 1
            
                        local LB = SP:Add("DLabel")
                        LB:SetText("")
                        LB:SetTall(h * 0.1)
                        LB:Dock(TOP)
                        LB:SetMouseInputEnabled(true)
                        LB:DockMargin(0, 0, 0, h * 0.025)
                        LB.OnCursorEntered = function()
                            surface.PlaySound("ncs/ui/slider.mp3")
                        end
            
                        LB.Paint = function(self, w, h)
                            if v.name then
                                draw.SimpleText(v.name, "NCS_LOD_FRAME_TITLE", w * 0.25, h * 0.5, ( ( self:IsHovered() and color_Gold ) or color_white ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end
                
                            if self:IsHovered() then
                                surface.SetDrawColor(color_Gold)
                            else
                                surface.SetDrawColor(color_Grey)
                            end
            
                            surface.DrawOutlinedRect(0, 0, w, h)
                        end

                            local w, h = SP:GetSize()

                            local ICON_EDIT = LB:Add("NCS_LOD_IMGUR")
                            ICON_EDIT:Dock(RIGHT)
                            ICON_EDIT:SetImgurID("iYVNWgE")
                            ICON_EDIT:SetImageSize(3)
                            ICON_EDIT:SetWide(w * 0.1)

                            ICON_EDIT:SetHoverColor(color_Gold)
                            ICON_EDIT.DoClick = function()
                                F:SetVisible(false)
                
                                CreateCertification(F, v.uid)
                            end
                            ICON_EDIT.OnCursorEntered = function(s)
                                surface.PlaySound("ncs/ui/slider.mp3")
                            end
                
                            local ICON_TRASH = LB:Add("NCS_LOD_IMGUR")
                            ICON_TRASH:Dock(RIGHT)
                            ICON_TRASH:SetImgurID("r40KL7Z")
                            ICON_TRASH:SetImageSize(3)
                            ICON_TRASH:SetWide(w * 0.1)
                            ICON_TRASH:SetHoverColor(color_Gold)
                            ICON_TRASH.DoClick = function()
                                net.Start("NCS_LOADOUTS_DelCert")
                                    net.WriteUInt(k, 16)
                                net.SendToServer()
                
                                certCount = certCount - 1

                                LB:Remove()
                            end
                            ICON_TRASH.OnCursorEntered = function(s)
                                surface.PlaySound("ncs/ui/slider.mp3")
                            end

                            if v.icon then
                                local ICON = LB:Add("NCS_LOD_IMGUR")
                                ICON:Dock(LEFT)
                                ICON:SetImgurID(v.icon)
                                ICON:SetImageSize(5)
                                ICON:SetNormalColor(Color(255,0,0))
                                ICON:SetMouseInputEnabled(false)
                                ICON:SetWide(w * 0.125)

                                ICON.PaintOver = function(s, w, h)
                                    if s:IsHovered() or s:GetParent():IsHovered() then
                                        surface.SetDrawColor(color_Gold)
                                    else
                                        surface.SetDrawColor(color_Grey)
                                    end
                
                                    surface.DrawOutlinedRect(0, 0, w, h)
                                end
                            end
                        end
                end

                --[[----------------------------------------]]
                --  Menu for Certification Creation
                --]]----------------------------------------]]

                CreateCertification = function(OLDFRAME, UID)
                    
                    local DATA = table.Copy(NCS_LOADOUTS.CERTS) or {}

                    if DATA[UID] then
                        DATA = DATA[UID]
                    else
                        DATA = {icon = "fTqhkAU"}
                    end

                    DATA.seats = DATA.seats or {}

                    local certCount = 0

                    local F = vgui.Create("NCS_LOD_FRAME")
                    F:MakePopup(true)
                    F:SetSize(ScrW() * 0.35, ScrH() * 0.55)
                    F:Center()
                    F:SetTitle(NCS_LOADOUTS.GetLang(nil, "addonTitle"))
                    F.OnRemove = function()
                        if IsValid(OLDFRAME) then OLDFRAME:SetVisible(true) end
                    end

                    local S = F:Add("NCS_LOD_SCROLL")
                    S:Dock(FILL)

                    local w, h = F:GetSize()

                    --[[----------------------------------------]]
                    --  Name
                    --]]----------------------------------------]]
                    
                    local M_LABEL = S:Add("DLabel")
                    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutName"))
                    M_LABEL:Dock(TOP)
                    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    
                    local d_NAME = S:Add("DTextEntry")
                    d_NAME:Dock(TOP)
                    d_NAME:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    d_NAME.OnTextChanged = function(s)
                        DATA.name = s:GetValue()
                    end
                    
                    if DATA.name then
                        d_NAME:SetValue(DATA.name)
                    end

                    --[[----------------------------------------]]
                    --  Loadout Icon
                    --]]----------------------------------------]]
                    
                    local M_LABEL = S:Add("DLabel")
                    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "loadoutIcon"))
                    M_LABEL:Dock(TOP)
                    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    
                    local d_ICON = S:Add("DTextEntry")
                    d_ICON:Dock(TOP)
                    d_ICON:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    d_ICON.OnTextChanged = function(s)
                        DATA.icon = s:GetValue()
                    end
                    
                    if DATA.icon then
                        d_ICON:SetValue(DATA.icon)
                    end

                    --goher

                    local M_LABEL = S:Add("DLabel")
                    M_LABEL:SetText(NCS_LOADOUTS.GetLang(nil, "seatsRestriction"))
                    M_LABEL:Dock(TOP)
                    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                    local TE_CLASS
                    local TE_SEATS
                    local DL_VehicleRestrict
                
                    local LABEL = S:Add("DLabel")
                    LABEL:Dock(TOP)
                    LABEL:SetTall(LABEL:GetTall() * 1.5)
                    LABEL:SetText("")
                    LABEL:SetMouseInputEnabled(true)
                    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                    local ADD = LABEL:Add("DButton", LABEL)
                    ADD:SetImage("icon16/add.png")
                    ADD:Dock(LEFT)
                    ADD:SetText("")
                    ADD:SetWide(ADD:GetWide() * 0.4)
                    ADD.DoClick = function(s)
                        local S_CLASS = TE_CLASS:GetValue()
                        local S_SEATS = TE_SEATS:GetValue()
                
                        if ( !S_CLASS or string.Trim(S_CLASS) == "" ) or ( !S_SEATS or string.Trim(S_SEATS) == "" ) then return end
                
                        local LINE = DL_VehicleRestrict:AddLine(S_CLASS, S_SEATS)
                        LINE.CLASS = S_CLASS
                        LINE.SEATS = S_SEATS

                        local TDATA = {}

                        if string.find(S_SEATS, "-") then
                            TDATA["-"] = true
                        else
                            local T = string.Explode(".", S_SEATS)

                            for k, v in ipairs(T) do
                                TDATA[v] = true
                            end
                        end

                        DATA.seats[S_CLASS] = TDATA
                    end
                
                    TE_CLASS = vgui.Create("DTextEntry", LABEL)
                    TE_CLASS:Dock(LEFT)
                    TE_CLASS:SetKeyboardInputEnabled(true)
                    TE_CLASS:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "classLabel"))
                    TE_CLASS:SetWide(TE_CLASS:GetWide() * 2)
                
                    TE_SEATS = vgui.Create("DTextEntry", LABEL)
                    TE_SEATS:Dock(LEFT)
                    TE_SEATS:SetKeyboardInputEnabled(true)
                    TE_SEATS:SetPlaceholderText(NCS_LOADOUTS.GetLang(nil, "seatsLabel"))
                    TE_SEATS:SetWide(TE_SEATS:GetWide() * 2)
                    TE_SEATS:SetNumeric(true)
                
                    local LABEL = vgui.Create("DLabel", S)
                    LABEL:SetText("")
                    LABEL:SetHeight(h * 0.3)
                    LABEL:Dock(TOP)
                    LABEL:SetMouseInputEnabled(true)
                
                    DL_VehicleRestrict = vgui.Create("DListView", LABEL)
                    DL_VehicleRestrict:Dock(FILL)
                    DL_VehicleRestrict:AddColumn( NCS_LOADOUTS.GetLang(nil, "classLabel"), 1 )
                    DL_VehicleRestrict:AddColumn( NCS_LOADOUTS.GetLang(nil, "seatsLabel"), 2 )
                    DL_VehicleRestrict:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                    DL_VehicleRestrict.OnRowSelected = function(sm, ID, LINE)
                        local BR = LINE.CLASS
                
                        if !DATA.seats[BR] then return end

                        TE_CLASS:SetText(BR)

                        local stringVal

                        for k, v in pairs(DATA.seats[BR]) do
                            if !stringVal then
                                stringVal = k
                            else
                                stringVal = stringVal.."."..k
                            end
                        end

                        TE_SEATS:SetText(stringVal)
                    end

                    DL_VehicleRestrict.OnRowRightClick = function(sm, ID, LINE)
                        local BR = LINE.CLASS
                
                        if DATA.seats[BR] then
                            DATA.seats[BR] = nil
                        end
                
                        DL_VehicleRestrict:RemoveLine(ID)
                    end
                    
                    if DATA.seats then
                        for k, v in pairs(DATA.seats) do
                            local stringVal

                            for k, v in pairs(v) do
                                if !stringVal then
                                    stringVal = k
                                else
                                    stringVal = stringVal.."."..k
                                end
                            end

                            local LINE = DL_VehicleRestrict:AddLine(k, stringVal)
                            LINE.CLASS = k
                            LINE.SEATS = v
                        end
                    end

                    local SUBMIT = vgui.Create("NCS_LOD_TextButton", F)
                    SUBMIT:Dock(BOTTOM)
                    SUBMIT:SetTall(h * 0.15)
                    SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
                    SUBMIT:SetText(NCS_LOADOUTS.GetLang(nil, "submitLabel"))
                    SUBMIT.DoClick = function()
                        local json = util.TableToJSON(DATA)
                        local compressed = util.Compress(json)
                        local length = compressed:len()

                        LayoutCertifications()

                        net.Start("NCS_LOADOUTS_CreateCertification")
                            net.WriteUInt(length, 32)
                            net.WriteData(compressed, length)
                        net.SendToServer()

                        F:Remove()
                    end
                end

                SP.OnSizeChanged = function(SP)
                    NCS_LOADOUTS.GetConfigData(2, function(DATA)
                        LayoutCertifications()
                    end )
                end
                
                local AddLoadout = M_PANEL:Add("NCS_LOD_TextButton")
                AddLoadout:SetText(NCS_LOADOUTS.GetLang(nil, "addCertification"))
                AddLoadout:Dock(BOTTOM)
                AddLoadout:SetTall(h * 0.1)

                AddLoadout.DoClick = function(s)
                    CreateCertification(F)

                    F:SetVisible(false)
                end
            end )

            --[[----------------------------------------]]
            --  Support Menu
            --]]----------------------------------------]]

            SB:AddPage(NCS_LOADOUTS.GetLang(nil, "supportLabel"), "A5YPY4p", function()
                if IsValid(M_PANEL) then
                    M_PANEL:Clear()
                end

                local DISCORD = vgui.Create("NCS_LOD_IMGUR", M_PANEL)
                DISCORD:Dock(FILL)
                DISCORD:SetImgurID("A5YPY4p")
                DISCORD:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
                DISCORD:SetImageSize(3)

                local SUBMIT = vgui.Create("NCS_LOD_TextButton", M_PANEL)
                SUBMIT:Dock(BOTTOM)
                SUBMIT:SetTall(h * 0.15)
                SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
                SUBMIT:SetText(NCS_LOADOUTS.GetLang(nil, "clickToOpen"))
                SUBMIT.DoClick = function()
                    gui.OpenURL("https://discord.gg/Th6xu4xybb")
                end
            end )
        end
    end )
end

--[[----------------------------------------]]
--  User menu
--]]----------------------------------------]]

net.Receive("NCS_LOADOUTS_MenuOpen", function()
    local B_dataExists = net.ReadBool()
    local T_dataCerts = {}

    if B_dataExists then
        NCS_LOADOUTS.P_DATA = NCS_LOADOUTS.P_DATA or {}

        T_dataCerts = net.ReadTable()

        for k, v in pairs(T_dataCerts) do
            NCS_LOADOUTS.P_DATA[k] = true
        end
    end

    local F = vgui.Create("NCS_LOD_FRAME")
    F:MakePopup(true)
    F:SetSize(ScrW() * 0.35, ScrH() * 0.55)
    F:Center()
    F:SetTitle(NCS_LOADOUTS.GetLang(nil, "addonTitle"))
    
    local w, h = F:GetSize()

    local P_RIGHT = F:Add("DPanel")
    P_RIGHT:Dock(RIGHT)
    P_RIGHT:SetWide(F:GetWide() * 0.4)
    P_RIGHT.Paint = function() end

    --[[----------------------------------------]]
    --  Player Model Icon
    --]]----------------------------------------]]

    local icon = P_RIGHT:Add( "DModelPanel" )
    icon:Dock(FILL)
    icon:SetModel( LocalPlayer():GetModel() )
    icon.PaintOver = function(s, w, h)
        surface.SetDrawColor(color_Grey)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    --
	local mn, mx = icon.Entity:GetRenderBounds()
	local size = 0
	size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
	size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
	size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

	icon:SetFOV(30)
	icon:SetCamPos(Vector(size, size, size))
	icon:SetLookAt((mn + mx) * 0.5)
    icon:DockMargin(w * 0.02, h * 0.015, w * 0.02, h * 0.015)

    --

    local loadoutCount = 0

    local SP = F:Add("NCS_LOD_SCROLL")
    SP:Dock(LEFT)
    SP:SetWide(w * 0.6)
    SP:DockMargin(0, 0, 0, h * 0.025)

    SP.PaintOver = function(s, w, h)
        if loadoutCount <= 0 then
            draw.SimpleText(NCS_LOADOUTS.GetLang(nil, "noAvailableLoadouts"), "NCS_LOD_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local function RefreshLoadouts()
        if !IsValid(SP) then return end
        
        local MODEL = LocalPlayer():GetModel()

        loadoutCount = 0
        SP:Clear()

        NCS_LOADOUTS.GetConfigData(1, function(r_Data)
            if !IsValid(SP) then return end

            local CFG = NCS_LOADOUTS.CONFIG

            NCS_LOADOUTS.P_DATA = NCS_LOADOUTS.P_DATA or {}

            local P_DATA = NCS_LOADOUTS.P_DATA

            for k, v in pairs(r_Data) do
                local hasAccess_c = false
                local hasAccess_t = false
                local hasAccess_s = false

                if v.allteams or !v.teams or table.IsEmpty(v.teams) then
                    hasAccess_t = true
                elseif v.teams and v.teams[team.GetName(LocalPlayer():Team())] then
                    hasAccess_t = true
                end

                if v.steamids and !table.IsEmpty(v.steamids) then
                    if v.steamids[LocalPlayer():SteamID()] then
                        hasAccess_s = true
                    end
                else
                    hasAccess_s = true
                end

                if v.certs and !table.IsEmpty(v.certs) then
                    if !P_DATA then continue end
                    
                    local i_Count = table.Count(v.certs)
                    local i_Counting = 0

                    for k, v in pairs(v.certs) do
                        if P_DATA[k] then
                            i_Counting = i_Counting + 1
                        end
                    end

                    if ( i_Counting == i_Count ) then
                        hasAccess_c = true
                    end
                else
                    hasAccess_c = true
                end

                if CFG and ( CFG.showdisabled == false ) then
                    if !hasAccess_t or !hasAccess_c or !hasAccess_s then
                        continue
                    end
                end

                loadoutCount = loadoutCount + 1

                local LB = SP:Add("DLabel")
                LB:SetText("")
                LB:SetTall(h * 0.1)
                LB:Dock(TOP)
                LB:SetMouseInputEnabled(true)
                LB:DockMargin(w * 0.02, h * 0.015, w * 0.02, h * 0.015)
                LB.OnCursorExited = function()
                    icon:SetModel(LocalPlayer():GetModel())
                end
                LB.OnCursorEntered = function()
                    if !hasAccess_t or !hasAccess_c then return end

                    surface.PlaySound("ncs/ui/slider.mp3")

                    if !istable(v.models) then return end

                    for a, b in pairs(v.models) do
                        if v.models[a].teams[team.GetName(LocalPlayer():Team())] then
                            icon:SetModel(a)

                            break
                        end
                    end
                end

                LB.DoClick = function(s)
                    net.Start("NCS_LOADOUTS_EquipLoadout")
                        net.WriteUInt(v.uid, 16)
                    net.SendToServer()
                end

                LB.Paint = function(self, w, h)
                    if !hasAccess_t or !hasAccess_c or !hasAccess_s then
                        if v.name then
                            draw.SimpleText(v.name, "NCS_LOD_FRAME_TITLE", w * 0.25, h * 0.5, Color(255,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                        surface.SetDrawColor(Color(255,0,0))
                    else
                        if v.name then
                            draw.SimpleText(v.name, "NCS_LOD_FRAME_TITLE", w * 0.25, h * 0.5, ( ( self:IsHovered() and color_Gold ) or color_white ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        end

                        if self:IsHovered() then
                            surface.SetDrawColor(color_Gold)
                        else
                            surface.SetDrawColor(color_Grey)
                        end
                    end

                    surface.DrawOutlinedRect(0, 0, w, h)
                end

                local w, h = SP:GetSize()

                if v.icon then
                    local ICON = LB:Add("NCS_LOD_IMGUR")
                    ICON:Dock(LEFT)
                    ICON:SetImgurID(v.icon)
                    ICON:SetImageSize(5)
                    ICON:SetWide(w * 0.125)
                    ICON:SetNormalColor(Color(255,0,0))
                    ICON:SetMouseInputEnabled(false)
                    ICON.PaintOver = function(s, w, h)
                        if !hasAccess_t or !hasAccess_c or !hasAccess_s then
                            surface.SetDrawColor(Color(255,0,0))
                        else
                            if s:IsHovered() or s:GetParent():IsHovered() then
                                surface.SetDrawColor(color_Gold)
                            else
                                surface.SetDrawColor(color_Grey)
                            end
                        end

                        surface.DrawOutlinedRect(0, 0, w, h)
                    end
                end
        
                local ICON_GLASS = LB:Add("NCS_LOD_IMGUR")
                ICON_GLASS:Dock(RIGHT)
                ICON_GLASS:SetWide(w * 0.125)
                ICON_GLASS:SetImgurID("sZH7Cnq")
                ICON_GLASS:SetImageSize(5)
                ICON_GLASS.PaintOver = function(s, w, h)
                    if !hasAccess_t or !hasAccess_c then
                        s:SetNormalColor(Color(255,0,0))
                        s:SetHoverColor(Color(255,0,0))
                    else
                        if s:IsHovered() or s:GetParent():IsHovered() then
                            s:SetNormalColor(color_Gold)
                        else
                            s:SetNormalColor(color_white)
                        end
                    end
                end

                if hasAccess_t and hasAccess_c then
                    if v.weps then
                        local T
            
                        for k, v in pairs(v.weps) do
                            if !T then T = k continue end

                            T = T..", "..k
                        end
            
                        ICON_GLASS:SetTooltip(T)
                    end
                end
            end
        end )
    end

    F.RefreshLoadouts = function(s)
        RefreshLoadouts()
    end
    
    SP.OnSizeChanged = function()
        SP:Clear()

        RefreshLoadouts()
    end

    NCS_LOADOUTS.IsAdmin(LocalPlayer(), function(ACCESS)        
        local newAccess = ACCESS
    
        local B, R = nil, nil
    
        if RDV and RDV.RANK then
            B = RDV.RANK.GetPlayerRankTree(LocalPlayer())
            R = RDV.RANK.GetPlayerRank(LocalPlayer())
        elseif MRS then
            B = MRS.GetPlayerGroup(LocalPlayer():Team())
            R = MRS.GetPlyRank(LocalPlayer(), B)
        end
    
        if NCS_LOADOUTS.CONFIG.ranks and table.Count(NCS_LOADOUTS.CONFIG.ranks) > 0 and NCS_LOADOUTS.CONFIG.ranks[B] then
            if ( NCS_LOADOUTS.CONFIG.ranks[B] <= R ) then 
                newAccess = true
            end
        end
    
        if NCS_LOADOUTS.CONFIG.teamrestrictcerts and table.Count(NCS_LOADOUTS.CONFIG.teamrestrictcerts) > 0 and NCS_LOADOUTS.CONFIG.teamrestrictcerts[team.GetName(LocalPlayer():Team())] then
            newAccess = true
        end
    
        if ACCESS or newAccess then
            local ADM = P_RIGHT:Add("NCS_LOD_TextButton")
            ADM:Dock(BOTTOM)
            ADM:SetText(NCS_LOADOUTS.GetLang(nil, "adminLabel"))
            ADM:SetTall(h * 0.055)
            ADM:DockMargin(w * 0.02, h * 0.01, w * 0.02, h * 0.02)

            ADM.DoClick = function()
                F:SetVisible(false)

                AdmLoadout(F)
            end
        end
    end )

    local UNEQUIP = P_RIGHT:Add("NCS_LOD_TextButton")
    UNEQUIP:Dock(BOTTOM)
    UNEQUIP:SetText(NCS_LOADOUTS.GetLang(nil, "unequipLabel"))
    UNEQUIP:SetTall(h * 0.055)
    UNEQUIP:DockMargin(w * 0.02, h * 0.01, w * 0.02, h * 0.01)

    UNEQUIP.DoClick = function()
        net.Start("NCS_LOADOUTS_UnequipLoadout")
        net.SendToServer()
    end
end )

net.Receive("NCS_LOADOUTS_UpdateSettings", function(_, P)
    local length = net.ReadUInt(32)
    local data = net.ReadData(length)
    local uncompressed = util.Decompress(data)

    if (!uncompressed) then
        return
    end

    local D = util.JSONToTable(uncompressed)

    for k, v in pairs(D) do
        if ( NCS_LOADOUTS.CONFIG[k] ~= nil ) then
            NCS_LOADOUTS.CONFIG[k] = v
        end
    end
end )

net.Receive("NCS_LOADOUTS_ChangePlayerCert", function()
    local CertUID = net.ReadUInt(16)
    local ChBool = net.ReadBool()

    NCS_LOADOUTS.P_DATA = NCS_LOADOUTS.P_DATA or {}

    if ChBool then
        NCS_LOADOUTS.P_DATA[CertUID] = true
    else
        NCS_LOADOUTS.P_DATA[CertUID] = nil
    end
end )