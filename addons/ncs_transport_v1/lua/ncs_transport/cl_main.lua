surface.CreateFont( "NCS_TRANSPORT_configMenuLabel", {
	font = "Bebas Neue",
	extended = false,
	size = ScreenScale(5.5),
} )

surface.CreateFont("NCS_TRANSPORT_CoreOverhead", {
    font = "Good Times Rg",
    extended = false,
    size = 40,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true
})

local color_Gold = Color(252,180,9,255)
local color_Grey = Color(122,132,137, 180)
local color_Positive =  Color(66, 134, 50)

local P_TABLE = {}

local awaitingLocationUpdate = {}

hook.Add("PlayerButtonDown", "NCS_TRANSPORT_CapturePositionData2", function(P, BTN)
    if P ~= LocalPlayer() or !( BTN == KEY_E ) or !P_TABLE[P:SteamID64()] then return end

    P_TABLE[P:SteamID64()](P:GetPos(), P:GetAngles())
end )

local function SendNotification(ply, msg)
    local CFG = NCS_TRANSPORT.CONFIG
	local PC = CFG.prefixColor
	local PT = CFG.prefixText

    NCS_SHARED.AddText(ply, Color(PC.r, PC.g, PC.b), "["..PT.."] ", color_white, msg)
end

local function AddLocationConfiguration(oldFrame, configurationID, quack)
    local configData

    if ( configurationID and NCS_TRANSPORT.LOCATIONS[configurationID] ) then
        configData = table.Copy(NCS_TRANSPORT.LOCATIONS[configurationID])
    else
        configData = table.Copy(NCS_TRANSPORT.C_LOCATION)
    end

    if IsValid(oldFrame) then oldFrame:SetVisible(false) end
    
    local w, h = ScreenScale(500), ScreenScaleH(500)

    local F = vgui.Create("NCS_TRANSPORT_FRAME")
    F:SetSize(w * 0.25, h * 0.5)
    F:Center()
    F:MakePopup()
    F.OnRemove = function(s)
        if IsValid(oldFrame) then oldFrame:SetVisible(true) end
    end

    local S = vgui.Create("NCS_TRANSPORT_SCROLL", F)
    S:DockMargin(0, 0, 0, h * 0.025)
    S:Dock(FILL)

    --[[-------------------------------------------]]--
    --  Location Name
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "locationName"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local locationName = S:Add("DTextEntry")
    locationName:Dock(TOP)
    locationName:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
    locationName.OnTextChanged = function(s)
        configData.name = s:GetValue()
    end

    if configData.name then
        locationName:SetValue(configData.name)
    end

    --[[-------------------------------------------]]--
    --  Location Icon
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "locationIcon"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local locationIcon = S:Add("DTextEntry")
    locationIcon:Dock(TOP)
    locationIcon:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
    locationIcon.OnTextChanged = function(s)
        configData.icon = s:GetValue()
    end

    if configData.icon then
        locationIcon:SetValue(configData.icon)
    end

    --[[-------------------------------------------]]--
    --  Location Distanced-Scaled
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "distanceScaled"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local LABEL = S:Add("DLabel")
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.05)
    LABEL:Dock(TOP)
    LABEL:DockMargin(w * 0.025, h * 0.005, w * 0.025, 0)
    LABEL:SetMouseInputEnabled(true)

    local CHECK_L = LABEL:Add("DLabel")
    CHECK_L:SetMouseInputEnabled(true)
    CHECK_L:Dock(RIGHT)
    CHECK_L:SetText("")

    local CHECK = CHECK_L:Add("DCheckBox")
    CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetWide() * 1.5)
    CHECK:Center()
    CHECK.OnChange = function(s, val)
        configData.distanceScaled = val
    end

    if configData.distanceScaled then
        CHECK:SetChecked(true)
    end

    --[[-------------------------------------------]]--
    --  Location Price
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "locationPrice"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local locationPrice = S:Add("DTextEntry")
    locationPrice:Dock(TOP)
    locationPrice:SetNumeric(true)
    locationPrice:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
    locationPrice.OnTextChanged = function(s)
        configData.price = math.Clamp(s:GetValue(), 0, math.huge)
    end
    locationPrice.PaintOver = function(s, w, h)
        if configData.distanceScaled then s:SetDisabled(true) else s:SetDisabled(false) end
    end

    if configData.price then
        locationPrice:SetValue(configData.price)
    end

    --[[-------------------------------------------]]--
    --  Team Restriction
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "teamRestriction"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local LABEL = vgui.Create("DLabel", S)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)

    local teamRestriction = LABEL:Add("DListView")
    teamRestriction:Dock(FILL)
    teamRestriction:AddColumn( NCS_TRANSPORT.GetLang(nil, "teamRestriction"), 1 )
    teamRestriction:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)


    teamRestriction.OnRowRightClick = function(sm, ID, LINE)
        local BR = LINE.TEAM

        if configData.teams and configData.teams[BR] then
            configData.teams[BR] = nil
        end

        LINE:SetSelected(false)
    end
    teamRestriction.OnRowSelected = function(s, _, LINE)
        local BR = LINE.TEAM

        configData.teams = configData.teams or {}
        configData.teams[BR] = true
    end

    for k, v in ipairs(team.GetAllTeams()) do
        local LINE = teamRestriction:AddLine(v.Name)
        LINE.TEAM = v.Name

        if configData.teams and configData.teams[v.Name] then
            LINE:SetSelected(true)
        end

        LINE.PaintOver = function(s)
            configData.teams = configData.teams  or {}

            if !configData.teams[v.Name] then
                LINE:SetSelected(false)
            else
                LINE:SetSelected(true)
            end
        end
    end

    --[[-------------------------------------------]]--
    --  Button for Positions
    --[[-------------------------------------------]]--

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "positionButton"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

    local positionButton = S:Add("NCS_TRANSPORT_TextButton")
    positionButton:SetText(NCS_TRANSPORT.GetLang(nil, "positionButton"))
    positionButton:SetTall(h * 0.05)
    positionButton:Dock(TOP)
    positionButton:SetMouseInputEnabled(true)
    positionButton:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
    positionButton.DoClick = function(s)
        P_TABLE[LocalPlayer():SteamID64()] = function(VEC, ANG)
            if !IsValid(positionButton) then
                P_TABLE[LocalPlayer():SteamID64()] = nil
                return
            end

            configData.pos = VEC
            configData.ang = ANG

            positionButton:SetText("Position: "..tostring(VEC).."\nAngle: "..tostring(ANG))

            F:SetVisible(true)
        end

        F:SetVisible(false)
    end

    if configData.pos and configData.ang then
        positionButton:SetText("Position: "..tostring(configData.pos).."\nAngle: "..tostring(configData.ang))
    end

    local SUBMIT = vgui.Create("NCS_TRANSPORT_TextButton", F)
    SUBMIT:Dock(BOTTOM)
    SUBMIT:SetText(NCS_TRANSPORT.GetLang(nil, "submitChanges"))
    SUBMIT:SetTall(h * 0.05)
    SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
    SUBMIT.DoClick = function(s)    
        if !configData.pos or !configData.ang then return end
        if !configData.name or string.Trim(configData.name) == "" then return end
        if ( !isnumber(configData.price) ) and !configData.distanceScaled then return end

        local json = util.TableToJSON(configData)
        local compressed = util.Compress(json)
        local length = compressed:len()
    
        net.Start("NCS_TRANSPORT_UpdateLocation")
            net.WriteUInt(length, 32)
            net.WriteData(compressed, length)
        net.SendToServer()

        if quack then
            awaitingLocationUpdate[LocalPlayer()] = function()
                quack()

                awaitingLocationUpdate[LocalPlayer()] = nil
            end
        end

        F:Remove()
    end
end

concommand.Add("ncs_transport_cfg", function(P)
    NCS_TRANSPORT.IsAdmin(LocalPlayer(), function(ACCESS)
        if !ACCESS then return end

        local F = vgui.Create("NCS_TRANSPORT_FRAME")
        F:SetSize(ScreenScale(500) * 0.5, ScreenScaleH(500) * 0.5)
        F:Center()
        F:MakePopup()

        local SIDE = vgui.Create("NCS_TRANSPORT_SIDEBAR", F)

        local P = vgui.Create("DPanel", F)
        P:Dock(FILL)
        P.Paint = function() end

        local w, h = F:GetSize()

        SIDE:AddPage("Settings", "JokvF2A", function()
            if IsValid(P) then
                P:Clear()
            end

            local CFG = table.Copy(NCS_TRANSPORT.CONFIG)
            
            local w, h = F:GetSize()

            local S = vgui.Create("NCS_TRANSPORT_SCROLL", P)
            S:DockMargin(0, 0, 0, h * 0.025)
            S:Dock(FILL)

            --[[-------------------------------------------]]--
            --  Language Settings
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "languageSetting"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local LANG = S:Add("DComboBox")
            LANG:Dock(TOP)
            LANG:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
                    
            LANG.OnSelect = function(s, IND, VAL)
                CFG.LANG = VAL
            end
                
            for k, v in pairs(NCS_TRANSPORT.GetLanguages()) do
                local OPT = LANG:AddChoice(k)
                
                if ( CFG.LANG == k ) then
                    LANG:ChooseOption(k, OPT)
                end
            end

            --[[----------------------------------------]]
            --  Currency Option
            --]]----------------------------------------]]

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "currencyOption"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")
            
            local CHAR = S:Add("DComboBox")
            CHAR:Dock(TOP)
            CHAR:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)

            CHAR.OnSelect = function(s, IND, VAL, S_VAL)
                CFG.currency = S_VAL or false
            end
            
            for k, v in pairs(NCS_TRANSPORT.CURRENCIES) do
                local OPT = CHAR:AddChoice(k, k)
            
                if ( CFG.currency == k ) then
                    CHAR:ChooseOptionID(OPT)
                end
            end

            --[[-------------------------------------------]]--
            --  Randomize Vendor
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "randomizeVendor"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local LABEL = S:Add("DLabel")
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.05)
            LABEL:Dock(TOP)
            LABEL:DockMargin(w * 0.025, h * 0.005, w * 0.025, 0)
            LABEL:SetMouseInputEnabled(true)

            local CHECK_L = LABEL:Add("DLabel")
            CHECK_L:SetMouseInputEnabled(true)
            CHECK_L:Dock(RIGHT)
            CHECK_L:SetText("")

            local CHECK = CHECK_L:Add("DCheckBox")
            CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetWide() * 1.5)
            CHECK:Center()
            CHECK.OnChange = function(s, val)
                CFG.vendorRandomize = val
            end

            if CFG.vendorRandomize then
                CHECK:SetChecked(true)
            end

            --[[-------------------------------------------]]--
            --  Vendor Model
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "vendorModel"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local vendorModel = S:Add("DTextEntry")
            vendorModel:Dock(TOP)
            vendorModel:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            vendorModel.OnTextChanged = function(s)
                CFG.vendormodel = s:GetValue()
            end

            if CFG.vendormodel then
                vendorModel:SetValue(CFG.vendormodel)
            end

            --[[-------------------------------------------]]--
            --  Vendor Save Command
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "vendorSave"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local vendorSave = S:Add("DTextEntry")
            vendorSave:Dock(TOP)
            vendorSave:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            vendorSave.OnTextChanged = function(s)
                CFG.vendorSave = s:GetValue()
            end

            if CFG.vendorSave then
                vendorSave:SetValue(CFG.vendorSave)
            end

            --[[-------------------------------------------]]--
            --  Addon Prefix
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "addonPrefix"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local addonPrefix = S:Add("DTextEntry")
            addonPrefix:Dock(TOP)
            addonPrefix:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            addonPrefix.OnTextChanged = function(s)
                CFG.prefixText = s:GetValue()
            end

            if CFG.prefixText then
                addonPrefix:SetValue(CFG.prefixText)
            end

            --[[-------------------------------------------]]--
            --  Addon Prefix Color
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "addonPrefixColor"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local d_COL = S:Add("DColorMixer")
            d_COL:Dock(TOP)
            d_COL:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            
            if CFG.prefixColor then
                local C = CFG.prefixColor
            
                if C.r and C.g and C.b then
                    C = Color(C.r, C.g, C.b)
                    d_COL:SetColor(C)
                end
            else
                d_COL:SetColor(Color(255,0,0))
            end
            
            d_COL.Think = function(s)
                CFG.prefixColor = s:GetColor()
            end
            
            --[[-------------------------------------------]]--
            --  Sounds Enabled
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "soundsEnabled"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local LABEL = S:Add("DLabel")
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.05)
            LABEL:Dock(TOP)
            LABEL:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            LABEL:SetMouseInputEnabled(true)

            local CHECK_L = LABEL:Add("DLabel")
            CHECK_L:SetMouseInputEnabled(true)
            CHECK_L:Dock(RIGHT)
            CHECK_L:SetText("")

            local CHECK = CHECK_L:Add("DCheckBox")
            CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetWide() * 1.5)
            CHECK:Center()
            CHECK.OnChange = function(s, val)
                CFG.soundsEnabled = val
            end

            if CFG.soundsEnabled then
                CHECK:SetChecked(true)
            end

            --[[-------------------------------------------]]--
            --  Takeoff Sound
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "takeoffSound"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local addonPrefix = S:Add("DTextEntry")
            addonPrefix:Dock(TOP)
            addonPrefix:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            addonPrefix.OnTextChanged = function(s)
                CFG.takeoffSound = s:GetValue()
            end

            if CFG.takeoffSound then
                addonPrefix:SetValue(CFG.takeoffSound)
            end

            --[[-------------------------------------------]]--
            --  Landing Sound
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "landingSound"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

            local addonPrefix = S:Add("DTextEntry")
            addonPrefix:Dock(TOP)
            addonPrefix:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            addonPrefix.OnTextChanged = function(s)
                CFG.landingSound = s:GetValue()
            end

            if CFG.landingSound then
                addonPrefix:SetValue(CFG.landingSound)
            end

            --[[-------------------------------------------]]--
            --  Pricing Scale
            --[[-------------------------------------------]]--

            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "pricingScale"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")
                
            local PRICING = S:Add("DNumSlider")
            PRICING:Dock(TOP)
            PRICING:SetDecimals(2)
            PRICING:SetMax(1)
            PRICING:DockMargin(w * 0.025, h * 0.005, w * 0.025, h * 0.025)
            PRICING.OnValueChanged = function(s)
                CFG.pricing = s:GetValue()
            end

            if CFG.pricing then
                PRICING:SetValue(CFG.pricing)
            end

            local SUBMIT = vgui.Create("NCS_TRANSPORT_TextButton", P)
            SUBMIT:Dock(BOTTOM)
            SUBMIT:SetText(NCS_TRANSPORT.GetLang(nil, "submitChanges"))
            SUBMIT:SetTall(h * 0.1)
            SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
            SUBMIT.DoClick = function(s)    
                local json = util.TableToJSON(CFG)
                local compressed = util.Compress(json)
                local length = compressed:len()
            
                net.Start("NCS_TRANSPORT_UpdateSettings")
                    net.WriteUInt(length, 32)
                    net.WriteData(compressed, length)
                net.SendToServer()

                SendNotification(LocalPlayer(), NCS_TRANSPORT.GetLang(nil, "updatedSettings"))
            end
        end)

        SIDE:AddPage(NCS_TRANSPORT.GetLang(nil, "adminLabel"), "6JrFWlz", function()
            if IsValid(P) then
                P:Clear()
            end

            local CFG = table.Copy(NCS_TRANSPORT.CONFIG)

            local NoCAMIFuckU
            local NoCAMIDerma = {}

            local w, h = F:GetSize()

            local S = vgui.Create("NCS_TRANSPORT_SCROLL", P)
            S:Dock(FILL)

            -- Cami Time
            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "camiEnabled"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")

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
                CFG.camienabled = val

                if !val then
                    NoCAMIFuckU()
                else
                    for k, v in ipairs(NoCAMIDerma) do
                        if IsValid(v) then v:Remove() end
                    end

                    NoCAMIDerma = {}
                end
            end

            if CFG.camienabled then
                CHECK:SetChecked(true)
            end

            -- No Cami
            
            NoCAMIFuckU = function()
                local M_LABEL = S:Add("DLabel")
                M_LABEL:SetText(NCS_TRANSPORT.GetLang(nil, "adminGroups"))
                M_LABEL:Dock(TOP)
                M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                M_LABEL:SetFont("NCS_TRANSPORT_configMenuLabel")
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

                    CFG.admins[UG] = LocalPlayer():SteamID64()

                    TX_USERGROUP:SetText("")
                end
            
                TX_USERGROUP = vgui.Create("DTextEntry", LABEL_TOP)
                TX_USERGROUP:Dock(LEFT)
                TX_USERGROUP:SetKeyboardInputEnabled(true)
                TX_USERGROUP:SetPlaceholderText(NCS_TRANSPORT.GetLang(nil, "adminGroups"))
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
                TX_UGLIST:AddColumn( NCS_TRANSPORT.GetLang(nil, "DEF_adminGroups"), 1 )
                TX_UGLIST:AddColumn( NCS_TRANSPORT.GetLang(nil, "DEF_addedBy"), 2 )

                TX_UGLIST.OnRowRightClick = function(sm, ID, LINE)
                    local UG = LINE.USERGROUP
                    
                    if ( UG == "superadmin" ) then return end

                    if CFG.admins[UG] then
                        CFG.admins[UG] = nil
                    end
            
                    TX_UGLIST:RemoveLine(ID)
                end
                TX_UGLIST.OnRowSelected = function(_, I, ROW)
                    ROW:SetSelected(false)
                end

                if CFG.admins then
                    for k, v in pairs(CFG.admins) do
                        local LINE = TX_UGLIST:AddLine(k, v)
                        LINE.USERGROUP = k
                        LINE.ADDEDBY = v
                    end
                end
            end

            if !CFG.camienabled then
                NoCAMIFuckU()
            end

            local SUBMIT = vgui.Create("NCS_TRANSPORT_TextButton", P)
            SUBMIT:Dock(BOTTOM)
            SUBMIT:SetText(NCS_TRANSPORT.GetLang(nil, "submitChanges"))
            SUBMIT:SetTall(h * 0.1)
            SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
            SUBMIT.DoClick = function(s)    
                local json = util.TableToJSON(CFG)
                local compressed = util.Compress(json)
                local length = compressed:len()
            
                net.Start("NCS_TRANSPORT_UpdateSettings")
                    net.WriteUInt(length, 32)
                    net.WriteData(compressed, length)
                net.SendToServer()
            end
        end )

        SIDE:AddPage("Locations", "JokvF2A", function()
            if IsValid(P) then
                P:Clear()
            end

            local countLocations 
            local S = vgui.Create("NCS_TRANSPORT_SCROLL", P)
            S:Dock(FILL)
            S:DockMargin(0, 0, 0, h * 0.025)
            S.Paint = function(s, w, h)
                if countLocations <= 0 then
                    draw.SimpleText(NCS_TRANSPORT.GetLang(nil, "noDestinations"), "NCS_TRANSPORT_FRAME_TITLE", w * 0.5, h * 0.4, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            local submitButtonOld
            local function refreshDataLocations()
                countLocations = 0

                S:Clear()

                if IsValid(submitButtonOld) then
                    submitButtonOld:Remove()
                end

                NCS_TRANSPORT.RequestLocationData(LocalPlayer(), function(LOCATIONS)
                    for k, v in pairs(LOCATIONS) do
                        countLocations = countLocations + 1

                        local LB = S:Add("DLabel")
                        LB:SetText("")
                        LB:SetTall(h * 0.1)
                        LB:Dock(TOP)
                        LB:SetMouseInputEnabled(true)
                        LB:DockMargin(w * 0.025, h * 0.02, w * 0.025, 0)

                        LB.Paint = function(self, w, h)
                            draw.SimpleText(v.name, "NCS_TRANSPORT_FRAME_TITLE", w * 0.25, h * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                            local textSample = NCS_TRANSPORT.GetLang(nil, "distanceFree")

                            if v.distanceScaled then 
                                textSample = NCS_TRANSPORT.GetLang(nil, "distanceScaled")
                            else
                                if v.price > 0 then textSample = NCS_TRANSPORT.FormatMoney(nil, v.price) end
                            end

                            draw.SimpleText( textSample, "NCS_TRANSPORT_FRAME_TITLE", w * 0.25, h * 0.65, color_Positive, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                            surface.SetDrawColor(color_Grey)

                            surface.DrawOutlinedRect(0, 0, w, h)
                        end

                        local iconEditLocation = LB:Add("NCS_TRANSPORT_IMGUR")
                        iconEditLocation:Dock(RIGHT)
                        iconEditLocation:SetImgurID("iYVNWgE")
                        iconEditLocation:SetImageSize(3)
                        iconEditLocation:SetWide(w * 0.05)
                        iconEditLocation:DockMargin(0, 0, w * 0.01, 0)
                        iconEditLocation:SetHoverColor(color_Gold)
                        iconEditLocation.DoClick = function(s)
                            AddLocationConfiguration(F, v.uid, function()
                                refreshDataLocations()
                            end )
                        end

                        local iconDeleteLocation = LB:Add("NCS_TRANSPORT_IMGUR")
                        iconDeleteLocation:Dock(RIGHT)
                        iconDeleteLocation:SetImgurID("r40KL7Z")
                        iconDeleteLocation:SetImageSize(3)
                        iconDeleteLocation:SetWide(w * 0.05)
                        iconDeleteLocation:SetHoverColor(color_Gold)
                        iconDeleteLocation.DoClick = function(s)
                            net.Start("NCS_TRANSPORT_DeleteLocation")
                                net.WriteUInt(v.uid, 32)
                            net.SendToServer()
                        end


                        local iconTravelIcon = LB:Add("NCS_TRANSPORT_IMGUR")
                        iconTravelIcon:Dock(LEFT)
                        iconTravelIcon:SetImgurID(v.icon)
                        iconTravelIcon:SetImageSize(5)
                        iconTravelIcon:SetWide(w * 0.125)
                        iconTravelIcon:SetMouseInputEnabled(false)
                        iconTravelIcon.PaintOver = function(s, w, h)
                            surface.SetDrawColor(color_Grey)
                            surface.DrawOutlinedRect(0, 0, w, h)
                        end
                    end

                    local SUBMIT = vgui.Create("NCS_TRANSPORT_TextButton", P)
                    SUBMIT:Dock(BOTTOM)
                    SUBMIT:SetText(NCS_TRANSPORT.GetLang(nil, "addLocation"))
                    SUBMIT:SetTall(h * 0.1)
                    SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
                    SUBMIT.DoClick = function(s)    
                        AddLocationConfiguration(F, nil, function()
                            refreshDataLocations()
                        end )
                    end

                    submitButtonOld = SUBMIT
                end )
            end

            refreshDataLocations()
        end )

        SIDE:AddPage(NCS_TRANSPORT.GetLang(nil, "support"), "A5YPY4p", function()
            if IsValid(P) then
                P:Clear()
            end

            local DISCORD = vgui.Create("NCS_TRANSPORT_IMGUR", P)
            DISCORD:Dock(FILL)
            DISCORD:SetImgurID("A5YPY4p")
            DISCORD:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
            DISCORD:SetImageSize(3)

            local SUBMIT = vgui.Create("NCS_TRANSPORT_TextButton", P)
            SUBMIT:Dock(BOTTOM)
            SUBMIT:SetTall(h * 0.1)
            SUBMIT:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
            SUBMIT:SetText(NCS_TRANSPORT.GetLang(nil, "clickToOpen"))
            SUBMIT.DoClick = function()
                gui.OpenURL("https://discord.gg/Th6xu4xybb")
            end
        end )
    end )
end )

net.Receive("NCS_TRANSPORT_UpdateSettings", function(_, P)
    local dataLength = net.ReadUInt(32)
    local dataCompressed = net.ReadData(dataLength)

    if !dataCompressed then return end

    local newData = util.Decompress(dataCompressed)
    newData = util.JSONToTable(newData)

    for k, v in pairs(newData) do
        if ( NCS_TRANSPORT.CONFIG[k] == nil ) then continue end

        NCS_TRANSPORT.CONFIG[k] = v
    end
end )

net.Receive("NCS_TRANSPORT_UpdateLocation", function(_, P)
    local dataLength = net.ReadUInt(32)
    local dataCompressed = net.ReadData(dataLength)

    if !dataCompressed then return end

    local newData = util.Decompress(dataCompressed)
    newData = util.JSONToTable(newData)

    NCS_TRANSPORT.LOCATIONS[newData.uid] = newData

    if awaitingLocationUpdate[LocalPlayer()] then
        awaitingLocationUpdate[LocalPlayer()]()
    end
end )

local colorRed = Color(255,0,0)
local nextDot
local flash

net.Receive("NCS_TRANSPORT_OpenMenu", function()
    local vendorUID = net.ReadUInt(32)
    local availableDestinations = net.ReadTable()

    local countLocations = 0
    local refreshLocationData

    local F = vgui.Create("NCS_TRANSPORT_FRAME")
    F:SetSize(ScreenScale(500) * 0.5, ScreenScaleH(500) * 0.5)
    F:Center()
    F:MakePopup()
    
    local w, h = F:GetSize()
    
    local panelScroller = vgui.Create("DPanel", F)
    panelScroller:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
    panelScroller:Dock(FILL)
    panelScroller.Paint = function(s, w, h)
        surface.SetDrawColor(color_Grey)
        surface.DrawOutlinedRect(0, 0, w, h)

        if countLocations <= 0 then
            draw.SimpleText(NCS_TRANSPORT.GetLang(nil, "noDestinations"), "NCS_TRANSPORT_FRAME_TITLE", w * 0.5, h * 0.4, colorRed, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    NCS_TRANSPORT.IsAdmin(LocalPlayer(), function(ACCESS)
        if !ACCESS then return end

        local adminButton = panelScroller:Add("NCS_TRANSPORT_TextButton")
        adminButton:SetText(NCS_TRANSPORT.GetLang(nil, "manageAvailableDests"))
        adminButton:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
        adminButton:SetTall(h * 0.1)
        adminButton:Dock(BOTTOM)
        adminButton.DoClick = function()
            F:SetVisible(false)

            local newValues = table.Copy(availableDestinations)

            local newF = vgui.Create("NCS_TRANSPORT_FRAME")
            newF:SetSize(ScreenScale(500) * 0.3, ScreenScaleH(500) * 0.3)
            newF:Center()
            newF:MakePopup()
            newF.OnRemove = function(s)
                if IsValid(F) then
                    F:SetVisible(true)
                end
            end

            local listView = newF:Add("DListView")
            listView:Dock(FILL)
            listView:AddColumn( NCS_TRANSPORT.GetLang(nil, "locationName"), 1 )
            listView:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)

            listView.OnRowSelected = function(_, I, ROW)
                newValues[ROW.locationUID] = true
            end
            listView.OnRowRightClick = function(_, I, ROW)
                newValues[ROW.locationUID] = nil
                ROW:SetSelected(false)
            end

            for k, v in pairs(NCS_TRANSPORT.LOCATIONS) do
                local LINE = listView:AddLine(v.name)

                if newValues[k] then
                    LINE:SetSelected(true)
                end

                LINE.locationUID = k

                LINE.PaintOver = function(s)    
                    if !newValues[s.locationUID] then
                        LINE:SetSelected(false)
                    else
                        LINE:SetSelected(true)
                    end
                end
            end
            
            local adminButton = newF:Add("NCS_TRANSPORT_TextButton")
            adminButton:SetText("Submit")
            adminButton:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
            adminButton:SetTall(h * 0.1)
            adminButton:Dock(BOTTOM)
            adminButton.DoClick = function()
                net.Start("NCS_TRANSPORT_UpdateDestinations")
                    net.WriteUInt(vendorUID, 32)
                    net.WriteTable(newValues)
                net.SendToServer()
                
                availableDestinations = newValues

                newF:Remove()

                refreshLocationData()
            end
        end
    end )

    local S = vgui.Create("NCS_TRANSPORT_SCROLL", panelScroller)
    S:Dock(FILL)

    local panelIcon = vgui.Create("DPanel", F)
    panelIcon:SetWide(w * 0.3)
    panelIcon:Dock(RIGHT)
    panelIcon:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)

    panelIcon.Paint = function(s, w, h)
        surface.SetDrawColor(color_Grey)

        surface.DrawOutlinedRect(0, 0, w, h)
    end

    local panelIcon_Top = vgui.Create("DPanel", panelIcon)
    panelIcon_Top:SetTall(h * 0.75)
    panelIcon_Top:Dock(TOP)
    panelIcon_Top.Paint = function()
    end

    local DISCORD = vgui.Create("NCS_TRANSPORT_IMGUR", panelIcon_Top)
    DISCORD:Dock(FILL)
    DISCORD:SetImgurID("F4mZ5Jb")
    DISCORD:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
    DISCORD:SetImageSize(3)
    DISCORD.data = {name = NCS_TRANSPORT.GetLang(nil, "noLocationSelected")}
    DISCORD.PaintOver = function(s, w, h)
        if !nextDot or nextDot < CurTime() then
            flash = !flash
    
            nextDot = CurTime() + 1
        end

        local v = s.data
        draw.SimpleText(v.name, "NCS_TRANSPORT_FRAME_TITLE", w * 0.5, h * 0.1, ( flash and colorRed ) or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local textSample = NCS_TRANSPORT.GetLang(nil, "distanceFree")

        if v.price or v.distanceScaled then
            local finalPrice = NCS_TRANSPORT.GetLocationPrice(LocalPlayer(), v.uid)

            if finalPrice > 0 then
                textSample = NCS_TRANSPORT.FormatMoney(nil, finalPrice)
            end
        end

        draw.SimpleText( textSample, "NCS_TRANSPORT_FRAME_TITLE", w * 0.5, h * 0.15, color_Positive, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    local LB = panelIcon:Add("NCS_TRANSPORT_TextButton")
    LB:SetText(NCS_TRANSPORT.GetLang(nil, "travelLabel"))
    LB:SetTall(h * 0.1)
    LB:Dock(BOTTOM)
    LB:SetMouseInputEnabled(true)
    LB:DockMargin(w * 0.025, h * 0.02, w * 0.025, h * 0.025)
    LB.DoClick = function()
        local v = DISCORD.data

        if !v.pos then return end

        local finalPrice = NCS_TRANSPORT.GetLocationPrice(LocalPlayer(), v.uid)
        if !NCS_TRANSPORT.CanAfford(LocalPlayer(), nil, finalPrice) then return end

        F:Remove()

        net.Start("NCS_TRANSPORT_TravelSuccess")
            net.WriteUInt(vendorUID, 32)
            net.WriteUInt(v.uid, 32)
        net.SendToServer()
    end

    NCS_TRANSPORT.RequestLocationData(LocalPlayer(), function(DATA)
        refreshLocationData = function()
            S:Clear()

            countLocations = 0
            local selectedLocation
            local isEmptyDestinations = false

            if !availableDestinations or table.IsEmpty(availableDestinations) then isEmptyDestinations = true end

            for k, v in pairs(DATA) do
                if !isEmptyDestinations and !availableDestinations[k] then print("Skipping!") continue end

                if v.teams and !table.IsEmpty(v.teams) then
                    if !v.teams[team.GetName(LocalPlayer():Team())] then continue end
                end

                countLocations = countLocations + 1

                local LB = S:Add("NCS_TRANSPORT_TextButton")
                LB:SetText("")
                LB:SetTall(h * 0.1)
                LB:Dock(TOP)
                LB:SetMouseInputEnabled(true)
                LB:DockMargin(w * 0.025, h * 0.02, w * 0.025, 0)

                LB.PaintOver = function(self, w, h)
                    draw.SimpleText(v.name, "NCS_TRANSPORT_FRAME_TITLE", w * 0.25, h * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    local textSample = NCS_TRANSPORT.GetLang(nil, "distanceFree")

                    if v.price or v.distanceScaled then
                        local finalPrice = NCS_TRANSPORT.GetLocationPrice(LocalPlayer(), v.uid)
            
                        if finalPrice > 0 then
                            textSample = NCS_TRANSPORT.FormatMoney(nil, finalPrice)
                        end
                    end

                    draw.SimpleText( textSample, "NCS_TRANSPORT_FRAME_TITLE", w * 0.25, h * 0.65, color_Positive, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    if selectedLocation and ( selectedLocation == k ) or self:IsHovered() then
                        surface.SetDrawColor(color_Gold)
                    else
                        surface.SetDrawColor(color_Grey)
                    end

                    surface.DrawOutlinedRect(0, 0, w, h)
                end
                LB.DoClick = function(s)
                    DISCORD.data = v
                    selectedLocation = k
                    DISCORD:SetImgurID(v.icon)
                end

                local iconTravelIcon = LB:Add("NCS_TRANSPORT_IMGUR")
                iconTravelIcon:Dock(LEFT)
                iconTravelIcon:SetImgurID(v.icon)
                iconTravelIcon:SetImageSize(5)
                iconTravelIcon:SetWide(w * 0.125)
                iconTravelIcon:SetMouseInputEnabled(false)
                iconTravelIcon.PaintOver = function(s, w, h)
                    if LB:IsHovered() or selectedLocation and ( selectedLocation == k ) then
                        surface.SetDrawColor(color_Gold)
                    else
                        surface.SetDrawColor(color_Grey)
                    end

                    surface.DrawOutlinedRect(0, 0, w, h)
                end
            end
        end

        refreshLocationData()
    end )
end )




net.Receive("NCS_TRANSPORT_TravelSuccess", function()
    if NCS_TRANSPORT.CONFIG.soundsEnabled and NCS_TRANSPORT.CONFIG.takeoffSound then
        surface.PlaySound(NCS_TRANSPORT.CONFIG.takeoffSound)
    end

    hook.Add("HUDShouldDraw", "NCS_TRANSPORT_RemoveHUD", function(name)
		if ( name == "CHudWeaponSelection" ) then return true end
		if ( name == "CHudChat" ) then return true end

		return false
	end)

	timer.Simple(4, function()
		hook.Remove("HUDShouldDraw", "NCS_TRANSPORT_RemoveHUD")
	end)
end )

net.Receive("NCS_TRANSPORT_DeleteLocation", function()
    local locationUID = net.ReadUInt(32)

    if NCS_TRANSPORT.LOCATIONS[locationUID] then
        NCS_TRANSPORT.LOCATIONS[locationUID] = nil
    end
end )