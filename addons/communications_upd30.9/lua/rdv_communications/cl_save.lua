surface.CreateFont("RDV_COMMUNICATIONS_LABEL", {
	font = "Bebas Neue",
	extended = false,
	size = ScrW() * 0.0135,
})

local COL_GREEN = Color(0,255,0)
local COL_RED = Color(255,0,0)

local function CreateDivider(PANEL, SP, TEXT)
	local w, h = PANEL:GetSize()

    local TLABEL = SP:Add("PIXEL.Label")
    TLABEL:Dock(TOP)
    TLABEL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    TLABEL:SetText(TEXT)
    TLABEL:SetTextColor(color_white)
	TLABEL:SetMouseInputEnabled(false)
end

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG
    local COL = Color(CFG.chatColor.r, CFG.chatColor.g, CFG.chatColor.b)

    RDV.LIBRARY.AddText(ply, COL, "["..CFG.chatPrefix.."] ", color_white, msg)
end

local function Create(FRAME)
    local S = vgui.Create("PIXEL.Frame")
    S:SetSize(ScrW() * 0.3, ScrH() * 0.6)
    S:Center()
    S:MakePopup(true)
    S:SetTitle(RDV.LIBRARY.GetLang(nil, "COMMS_communicationsLabel"))
    S.OnRemove = function(s)
        if IsValid(FRAME) then
            FRAME:SetVisible(true)
        end
    end

    local w, h = S:GetSize()

    local SCROLL = vgui.Create("DScrollPanel", S)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)

    CreateDivider(S, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_modelLabel"))

    local MODEL = SCROLL:Add("DTextEntry")
    MODEL:Dock(TOP)

    CreateDivider(S, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_nameLabel"))

    local NAME = SCROLL:Add("DTextEntry")
    NAME:Dock(TOP)

    -- Channels
    CreateDivider(S, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_blackoutTeams"))

    local LABEL = vgui.Create("DLabel", SCROLL)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)

    local LIST = vgui.Create("DListView", LABEL)
    LIST:Dock(FILL)
    LIST:AddColumn( RDV.LIBRARY.GetLang(nil, "COMMS_nameLabel"), 1 )
    LIST.OnRowRightClick = function(sm, ID, LINE)
        LINE:SetSelected(false)
    end

    for k, v in ipairs(team.GetAllTeams()) do
        local L = LIST:AddLine(v.Name)
        L.NAME = v.Name
    end

    -- Sounds
    CreateDivider(S, SCROLL, "Console Sounds (Right Click Line to Remove)")

    local SOUND
    local S_RANK

    local LABEL = SCROLL:Add("DLabel")
    LABEL:Dock(TOP)
    LABEL:SetTall(LABEL:GetTall() * 1.5)
    LABEL:SetText("")
    LABEL:SetMouseInputEnabled(true)
    
    local ADD = LABEL:Add("DButton", LABEL)
    ADD:SetImage("icon16/add.png")
    ADD:Dock(LEFT)
    ADD:SetText("")
    ADD:SetWide(ADD:GetWide() * 0.4)
    ADD.DoClick = function(s)
        local BR = SOUND:GetValue()

        if ( !BR or BR == "" ) then return end

        local LINE = S_RANK:AddLine(BR, RA)
        LINE.SOUND = BR
    end

    SOUND = vgui.Create("DTextEntry", LABEL)
    SOUND:Dock(LEFT)
    SOUND:SetKeyboardInputEnabled(true)
    SOUND:SetPlaceholderText("Sound")
    SOUND:SetWide(SOUND:GetWide() * 2)

    local LABEL = vgui.Create("DLabel", SCROLL)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)

    S_RANK = vgui.Create("DListView", LABEL)
    S_RANK:Dock(FILL)
    S_RANK:AddColumn( "Sound", 1 )

    S_RANK.OnRowRightClick = function(sm, ID, LINE)    
        S_RANK:RemoveLine(ID)
    end

    local SOUNDS = {        
        "rdv/communications/sw_rc_ambradio_01.ogg",
        "rdv/communications/sw_rc_ambradio_02.ogg",
        "rdv/communications/sw_rc_ambradio_03.ogg",
        "rdv/communications/sw_rc_ambradio_04.ogg",
        "rdv/communications/sw_rc_ambradio_05.ogg"
    }

    for k, v in pairs(SOUNDS) do
        local LINE = S_RANK:AddLine(v)
        LINE.SOUND = v
    end

    local ADD = vgui.Create("PIXEL.TextButton", S)
    ADD:SetSize(w, h * 0.1)
    ADD:Dock(BOTTOM)
    ADD:SetText(RDV.LIBRARY.GetLang(nil, "COMMS_createLabel"))
    ADD:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)

    ADD.DoClick = function(self)
        local COUNT = #LIST:GetSelected()

        net.Start("RDV_COMMUNICATIONS_AddRelay")
            net.WriteString(NAME:GetValue())
            net.WriteString(MODEL:GetValue())
            net.WriteUInt(COUNT, 8)

            for i = 1, COUNT do
                net.WriteString(LIST:GetSelected()[i].NAME)
            end
            
            local S_COUNT = table.Count(S_RANK:GetLines())

            net.WriteUInt(S_COUNT, 8)

            for k, v in pairs(S_RANK:GetLines()) do
                net.WriteString(v.SOUND)
            end
        net.SendToServer()

        S:Remove()

        if IsValid(FRAME) then
            FRAME:Remove()
        end
    end
end

local CATEGORIES = {}
local function GetCat(FRAME, SCROLL, NAME)
    local w, h = FRAME:GetSize()

    if !IsValid(CATEGORIES[NAME]) then
        local CAT = SCROLL:Add("PIXEL.Category")
        CAT:Dock(TOP)
        CAT:SetTitle( NAME )
        CAT:DockMargin(w * 0.015, h * 0.015, w * 0.015, h * 0.015)
        CAT:DockPadding(w * 0.015, h * 0.015, w * 0.015, h * 0.015)

        CAT:SetExpanded(true)

        CATEGORIES[NAME] = CAT
    end

    return CATEGORIES[NAME]
end

net.Receive("RDV.COMMUNICATIONS.OpenConfig", function()
    if !LocalPlayer():IsAdmin() then return end

    local DATA = table.Copy(RDV.COMMUNICATIONS.S_CFG) or {}
    local BUTTONS = {}

    local NOTIFICATION

    local FRAMED = vgui.Create("PIXEL.Frame")
    FRAMED:SetSize(ScrW() * 0.4, ScrH() * 0.6)
    FRAMED:Center()
    FRAMED:MakePopup(true)
    FRAMED:SetMouseInputEnabled(true)
    FRAMED:SetTitle(RDV.LIBRARY.GetLang(nil, "COMMS_communicationsLabel"))


    local S = FRAMED:CreateSidebar("configurationSide", nil)

    local w, h = FRAMED:GetSize()

    local SCROLL = vgui.Create("DScrollPanel", FRAMED)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    SCROLL.PaintOver = function(self, w, h)
        if NOTIFICATION and NOTIFICATION ~= "" then
            draw.SimpleText(NOTIFICATION, "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local function CLEAR()
        for k, v in ipairs(BUTTONS) do
            if IsValid(v) then table.remove(BUTTONS, k) v:Remove() end
        end

        SCROLL:Clear()
    end

    S:AddItem("settingsMain", RDV.LIBRARY.GetLang(nil, "COMMS_settingsLabel"), "LV2brnv", function()
        CATEGORIES = {}

        CLEAR()
        
        NOTIFICATION = false

        local CAT = GetCat(FRAMED, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_commands"))

        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_menuCommand"))

        local DC_MENUCOMMAND = vgui.Create("DTextEntry", CAT)
        DC_MENUCOMMAND:SetText("")
        DC_MENUCOMMAND:Dock(TOP)
        DC_MENUCOMMAND:SetHeight(DC_MENUCOMMAND:GetTall() * 1.5)
        DC_MENUCOMMAND:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
        DC_MENUCOMMAND.OnChange = function(s, val)
            DATA.menuCommand = s:GetValue()
        end

        if DATA.menuCommand and ( DATA.menuCommand ~= "" ) then
            DC_MENUCOMMAND:SetText(DATA.menuCommand)
        end

        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_groupCommand"))

        local DC_CHATCOMMAND = vgui.Create("DTextEntry", CAT)
        DC_CHATCOMMAND:SetText("")
        DC_CHATCOMMAND:SetHeight(DC_CHATCOMMAND:GetTall() * 1.5)
        DC_CHATCOMMAND:Dock(TOP)
        DC_CHATCOMMAND:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
        DC_CHATCOMMAND.OnChange = function(s, val)
            DATA.chatCommand = s:GetValue()
        end

        if DATA.chatCommand and ( DATA.chatCommand ~= "" ) then
            DC_CHATCOMMAND:SetText(DATA.chatCommand)
        end

        local CAT = GetCat(FRAMED, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_generalSettings"))

        -- Console Health Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_maxPassiveCount"))

        local DC_PASSIVE = vgui.Create("DNumSlider", CAT)
        DC_PASSIVE:Dock(TOP)
        DC_PASSIVE:DockMargin(0, 0, w * 0.01, h * 0.01)
        DC_PASSIVE:SetMax(10)
        DC_PASSIVE:SetDecimals(0)
        DC_PASSIVE.OnValueChange = function(s, val)
            DATA.passiveChannelCount = val
        end

        if DATA.passiveChannelCount then
            DC_PASSIVE:SetValue(DATA.passiveChannelCount)
        end

        -- Disallow Team Chat
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_disallowChatRelay"))

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
                
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
            
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.disableTeamChat = val
        end

        if DATA.disableTeamChat then
            CHECK:SetChecked(true)
        end

        -- Halo Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_haloEnabled"))

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
            
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
            
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.haloEnabled = val
        end

        if DATA.haloEnabled then
            CHECK:SetChecked(true)
        end

        -- Start Muted
        CreateDivider(FRAMED, CAT, "Start Muted")

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
            
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
            
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.startMuted = val
        end

        if DATA.startMuted then
            CHECK:SetChecked(true)
        end

        -- Default Channel
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_defaultChannel"))

        local CH_DEFAULT = vgui.Create("DComboBox", CAT)
        CH_DEFAULT:SetText( RDV.LIBRARY.GetLang(nil, "COMMS_defaultChannel") )
        CH_DEFAULT:Dock(TOP)
        CH_DEFAULT:SetSortItems(false)
        CH_DEFAULT:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
        CH_DEFAULT.OnSelect = function(self, index, value)
            if value == RDV.LIBRARY.GetLang(nil, "COMMS_noDefault") then
                DATA.defaultChannel = false
                return
            end

            DATA.defaultChannel = value
        end

        CH_DEFAULT:AddChoice(RDV.LIBRARY.GetLang(nil, "COMMS_noDefault"))

        for k, v in pairs(RDV.COMMUNICATIONS.LIST) do
            CH_DEFAULT:AddChoice(k)
        end

        if DATA.defaultChannel then
            for k, v in pairs(CH_DEFAULT.Choices) do
                if ( v == DATA.defaultChannel ) then
                    CH_DEFAULT:ChooseOption( DATA.defaultChannel, k)
                    break
                end
            end
        end

        local CAT = GetCat(FRAMED, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_consoleData"))

        -- Default Console Model

        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_consoleModel"))

        local DC_MODEL = vgui.Create("DTextEntry", CAT)
        DC_MODEL:Dock(TOP)
        DC_MODEL:SetText("")
        DC_MODEL:SetHeight(DC_MODEL:GetTall() * 1.5)
        DC_MODEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)

        DC_MODEL.OnChange = function(s, val)
            DATA.consoleModel = s:GetValue()
        end

        if DATA.consoleModel and ( DATA.consoleModel ~= "" ) then
            DC_MODEL:SetText(DATA.consoleModel)
        end

        -- Console Health Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_consoleHealthEnabled"))

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
    
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
    
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.consoleHealthEnabled = val
        end

        if DATA.consoleHealthEnabled then
            CHECK:SetChecked(true)
        end

        -- Console Health Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_consoleHealth"))

        local DC_HEALTH = vgui.Create("DNumSlider", CAT)
        DC_HEALTH:Dock(TOP)
        DC_HEALTH:DockMargin(0, 0, w * 0.01, h * 0.01)
        DC_HEALTH:SetMax(10000)
        DC_HEALTH:SetDecimals(0)
        DC_HEALTH.OnValueChange = function(s, val)
            DATA.consoleHealthValue = val
        end

        if DATA.consoleHealthValue then
            DC_HEALTH:SetValue(DATA.consoleHealthValue)
        end

        local CAT = GetCat(FRAMED, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_hudSettings"))

        -- Console Health Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_hudLocation"))

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
            
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
            
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.HUDLocation = val
        end

        if DATA.HUDLocation then
            CHECK:SetChecked(DATA.HUDLocation)
        end

        local CAT = GetCat(FRAMED, SCROLL, RDV.LIBRARY.GetLang(nil, "COMMS_speakBind"))

        -- Speak Bind Enabled
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_speakBindEnabled"))

        local LABEL = vgui.Create("DLabel", CAT)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:DockMargin(0, 0, w * 0.01, h * 0.01)
        LABEL:SetMouseInputEnabled(true)
            
        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
            
        local CHECK = vgui.Create("DCheckBox", CHECK_L)
        CHECK:Center()
        CHECK.OnChange = function(s, val)
            DATA.speakBindEnabled = val
        end

        if DATA.speakBindEnabled then
            CHECK:SetChecked(DATA.speakBindEnabled)
        end

        -- Custom Speak Bind
        CreateDivider(FRAMED, CAT, RDV.LIBRARY.GetLang(nil, "COMMS_speakBind"))

        local BINDER = vgui.Create("DBinder", CAT)
        BINDER:SetText("")
        BINDER:SetHeight(h * 0.1)
        BINDER:Dock(TOP)
        BINDER:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
        BINDER:SetMouseInputEnabled(true)
        BINDER.OnChange = function(self, but)
            BINDER:SetText(input.GetKeyName(but))
            DATA.speakBindValue = but
        end

        if DATA.speakBindValue then
            BINDER:SetValue(DATA.speakBindValue)
            BINDER:SetText(input.GetKeyName(DATA.speakBindValue))
        end

        local ADD = vgui.Create("PIXEL.TextButton", FRAMED)
        ADD:SetSize(w, h * 0.1)
        ADD:Dock(BOTTOM)
        ADD:SetText(RDV.LIBRARY.GetLang(nil, "COMMS_saveLabel"))
        ADD:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)

        ADD.DoClick = function(self)
            if ( DATA.menuCommand == "" ) or ( DATA.chatCommand == "" ) or ( DATA.consoleModel == "" ) then
                return
            end

            local COMPRESS = util.Compress(util.TableToJSON(DATA))

            local BYTES = #COMPRESS
    
            net.Start( "RDV_COMMUNICATIONS_UPDCFG" )
                net.WriteUInt( BYTES, 16 )
                net.WriteData( COMPRESS, BYTES )
            net.SendToServer()
        end

        table.insert(BUTTONS, ADD)
    end )

    S:AddItem("settingsRelay", RDV.LIBRARY.GetLang(nil, "COMMS_relaysLabel"), "ENRwIRe", function()
        CLEAR()
        
        NOTIFICATION = false

        local COUNT = 0

        for k, v in ipairs(ents.GetAll()) do
            if v:GetClass() == "rdv_console_comms" then
                COUNT = COUNT + 1

                local ENABLED = v:GetRelayEnabled()
                local COL = ( ENABLED and COL_GREEN ) or COL_RED

                local LABEL = SCROLL:Add("DPanel")
                LABEL:SetSize(w, h * 0.1)
                LABEL:Dock(TOP)
                LABEL:SetText("")
                LABEL:DockMargin(0, 0, 0, h * 0.01)
                LABEL.Paint = function(S, w, h)
                    if !IsValid(v) then
                        S:Remove()
                        return
                    end

                    draw.RoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.CopyColor(PIXEL.Colors.Header))

                    draw.SimpleText(v:GetRelayName(), "RDV_COMMUNICATIONS_LABEL", w * 0.03, h * 0.325, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText((v:GetRelayEnabled() and RDV.LIBRARY.GetLang(nil, "COMMS_enabledLabel")) or RDV.LIBRARY.GetLang(nil, "COMMS_disabledLabel"), "RDV_COMMUNICATIONS_LABEL", w * 0.03, h * 0.675, COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local w, h = LABEL:GetSize()

                local EDIT = vgui.Create("PIXEL.TextButton", LABEL)
                EDIT:SetText(RDV.LIBRARY.GetLang(nil, "COMMS_editLabel"))
                EDIT:Dock(RIGHT)
                EDIT.DoClick = function(self)
                    local OPTIONS = DermaMenu()

                    OPTIONS:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_gotoLabel"), function()
                        net.Start("RDV_COMMUNICATIONS_GotoRelay")
                            net.WriteString(v:GetRelayName())
                        net.SendToServer()
                    end)

                    OPTIONS:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_deleteLabel"), function()
                        net.Start("RDV_COMMUNICATIONS_RemoveRelay")
                            net.WriteString(v:GetRelayName())
                        net.SendToServer()
                    end)

                    OPTIONS:Open()
                end
            end
        end

        if COUNT <= 0 then
            NOTIFICATION = RDV.LIBRARY.GetLang(nil, "COMMS_noRelays")
        end

        local ADD = vgui.Create("PIXEL.TextButton", FRAMED)
        ADD:SetSize(w, h * 0.1)
        ADD:Dock(BOTTOM)
        ADD:SetText(RDV.LIBRARY.GetLang(nil, "COMMS_createLabel"))
        ADD:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)

        ADD.DoClick = function(self)
            Create(FRAMED)

            FRAMED:SetVisible(false)
        end

        table.insert(BUTTONS, ADD)
    end )

    S.PaintOver = function()
        S:SelectItem("settingsMain") 
        S.PaintOver = nil
    end
end)

net.Receive("RDV_COMMUNICATIONS_ToggleComms", function()
    RDV.COMMUNICATIONS.RELAY = net.ReadBool()
end )

net.Receive("RDV_COMMUNICATIONS_UPDCFG", function()
    local BYTES = net.ReadUInt( 16 )
    local DATA = net.ReadData(BYTES)

    local DECOMPRESSED = util.Decompress(DATA)
    local TAB = util.JSONToTable(DECOMPRESSED)

    RDV.COMMUNICATIONS.S_CFG = TAB
end )