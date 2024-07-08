local OBJ = NCS_DATAPAD.CreatePlugin("Entries")

OBJ.Icon = "yZoQW1z"

NCS_DATAPAD.CONFIG.DescLimit = 2000
NCS_DATAPAD.CONFIG.TitleLimit = 100

OBJ:AddConfigurationDerma(function(S, F, CFG)
    local w, h = F:GetSize()

    -- Model

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_consoleModel"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local MODEL = S:Add("DTextEntry")
    MODEL:Dock(TOP)
    MODEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    MODEL.OnTextChanged = function(s)
        CFG.MODEL = s:GetValue()
    end

    if CFG.MODEL then
        MODEL:SetValue(CFG.MODEL)
    end

    -- Hack Time
    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_hackTime"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local NUMBER = S:Add("DNumSlider")
    NUMBER:Dock(TOP)
    NUMBER:SetMax(500)
    NUMBER:SetText( "" )
    NUMBER:SetDecimals(0)
    NUMBER:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    NUMBER.OnValueChanged = function(s, V)
        CFG.HackTime = V
    end

    if CFG.HackTime then
        NUMBER:SetValue(CFG.HackTime)
    else
        NUMBER:SetValue(30)
    end
    
    -- Title Limit
    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_titleLimit"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local NUMBER = S:Add("DNumSlider")
    NUMBER:Dock(TOP)
    NUMBER:SetMax(500)
    NUMBER:SetText( "" )
    NUMBER:SetDecimals(0)
    NUMBER:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    NUMBER.OnValueChanged = function(s, V)
        CFG.TitleLimit = V
    end

    if CFG.TitleLimit then
        NUMBER:SetValue(CFG.TitleLimit)
    else
        NUMBER:SetValue(500)
    end

    -- Title Limit
    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_descLimit"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local NUMBER = S:Add("DNumSlider")
    NUMBER:Dock(TOP)
    NUMBER:SetMax(5000)
    NUMBER:SetText( "" )
    NUMBER:SetDecimals(0)
    NUMBER:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    NUMBER.OnValueChanged = function(s, V)
        CFG.DescLimit = V
    end

    if CFG.DescLimit then
        NUMBER:SetValue(CFG.DescLimit)
    else
        NUMBER:SetValue(2000)
    end

    -- Send Delay

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_sharingEnabled"))
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
        CFG.SendEnabled = val
    end

    if CFG.SendEnabled then
        CHECK:SetChecked(true)
    end

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_sharingDelay"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local NUMBER = S:Add("DNumSlider")
    NUMBER:Dock(TOP)
    NUMBER:SetMax(500)
    NUMBER:SetText( "" )
    NUMBER:SetDecimals(0)
    NUMBER:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    NUMBER.OnValueChanged = function(s, V)
        CFG.SendDelay = V
    end

    if CFG.SendDelay then
        NUMBER:SetValue(CFG.SendDelay)
    else
        NUMBER:SetValue(30)
    end

    -- Engineers

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_engineersList"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local S_TEAM = S:Add("DListView")
    S_TEAM:Dock(TOP)
    S_TEAM:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    S_TEAM:SetTall(h * 0.3)
    S_TEAM:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_nameLabel"), 1 )
    S_TEAM.OnRowRightClick = function(sm, ID, LINE)
        LINE:SetSelected(false)
    end
    S_TEAM.OnRowSelected = function(s, ind, row)
        if !row.TEAM then return end

        CFG.ENGINEERS[row.TEAM] = true
    end

    for k, v in ipairs(team.GetAllTeams()) do
        local L = S_TEAM:AddLine(v.Name)
        L.TEAM = v.Name
        
        if CFG.ENGINEERS[v.Name] then
            L:SetSelected(true)
        end
    end

    -- Archive Access

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_archiveList"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local S_TEAM = S:Add("DListView")
    S_TEAM:Dock(TOP)
    S_TEAM:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    S_TEAM:SetTall(h * 0.3)
    S_TEAM:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_nameLabel"), 1 )
    S_TEAM.OnRowRightClick = function(sm, ID, LINE)
        LINE:SetSelected(false)
    end
    S_TEAM.OnRowSelected = function(s, ind, row)
        if !row.TEAM then return end

        CFG.ArchiveAccess[row.TEAM] = true
    end

    for k, v in ipairs(team.GetAllTeams()) do
        local L = S_TEAM:AddLine(v.Name)
        L.TEAM = v.Name
        
        if CFG.ArchiveAccess[v.Name] then
            L:SetSelected(true)
        end
    end

    local ESAVE = S:Add("RDV_DAP_TextButton")
    ESAVE:Dock(TOP)
    ESAVE:SetText("Save Addon Entities")
    ESAVE.DoClick = function()
        net.Start("RDV_DAP_SaveEntities")
        net.SendToServer()
    end
end)