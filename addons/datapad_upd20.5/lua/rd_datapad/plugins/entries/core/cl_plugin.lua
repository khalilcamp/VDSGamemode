local OBJ = NCS_DATAPAD.GetPlugin()

function OBJ:DoClick(player, MENU, PAGE)
    local w, h = MENU:GetSize()

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_noEntriesSaved")

    local SCROLL = vgui.Create("RDV_DAP_SCROLL", PAGE)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(0, h * 0.02, w * 0.02, h * 0.02)
    SCROLL.Think = function(self)
        OBJ.SCROLL = SCROLL
        OBJ.MENU = MENU

        PAGE.PaintOver = function(self, w, h)
            local COUNT = ( NCS_DATAPAD.E_COUNT[LocalPlayer()] or 0 )

            if COUNT <= 0 then
                draw.SimpleText(LANG, "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        net.Start("RDV_DATAPAD_GetEntry")
        net.SendToServer()

        net.Receive("RDV_DATAPAD_GetEntry", function()
            local TAB = net.ReadTable()

            NCS_DATAPAD.E_DATA[LocalPlayer()] = TAB
            
            NCS_DATAPAD.E_COUNT[LocalPlayer()] = 0
            
            OBJ:RefreshEntries()
        end)

        local LANG = NCS_DATAPAD.GetLang(nil, "DAP_createEntryLabel")

        local but = vgui.Create("RDV_DAP_TextButton", PAGE)
        but:SetHeight(h * 0.125)
        but:Dock(BOTTOM)
        but:SetText(LANG)
        but:DockMargin(0, h * 0.02, w * 0.02, h * 0.02)

        but.DoClick = function()
            MENU:SetVisible(false)
            
            OBJ:CreateEntryMenu(MENU)
        end

        self.Think = function() end
    end
end

net.Receive("RDV_DATAPAD_OpenConsoleMenu", function()
    local CONSOLE = net.ReadEntity()

    if !CONSOLE or !IsValid(CONSOLE) then
        return
    end

    local CONTENT = CONSOLE:GetEntryDescription()
    local TITLE_TXT = CONSOLE:GetEntryTitle()

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_consoleLabel")

    local FRAME = vgui.Create("RDV_DAP_FRAME")
    FRAME:SetSize(ScrW() * 0.3, ScrH() * 0.4)
    FRAME:Center()
    FRAME:SetVisible(true)
    FRAME:MakePopup()
    FRAME:SetTitle(LANG)

    --
    -- Properties
    --

    local w, h = FRAME:GetSize()

    local SIDE = vgui.Create("RDV_DAP_SIDEBAR", FRAME)

    local PANEL = vgui.Create("DPanel", FRAME)
    PANEL:Dock(FILL)
    PANEL.Paint = function() end
    
    --
    -- Hack Panel
    -- https://icons8.com/icon/CEDsWKyKeA9z/hacker

    SIDE:AddPage(NCS_DATAPAD.GetLang(nil, "DAP_hackLabel"), "tFkxLWl", function()
        if IsValid(PANEL) then
            PANEL:Clear()
        end

        local LANG = NCS_DATAPAD.GetLang(nil, "DAP_hackLabel")

        --
        -- Hack Panel
        --
        local LANG = NCS_DATAPAD.GetLang(nil, "DAP_startHackLabel")

        local BUTTON = vgui.Create("RDV_DAP_TextButton", PANEL)
        BUTTON:SetText(LANG)
        BUTTON:Dock(FILL)
        BUTTON.DoClick = function()
            net.Start("RDV_DATAPAD_StartConsoleHack")
                net.WriteEntity(CONSOLE)
            net.SendToServer()

            FRAME:Remove()
        end
        BUTTON.Paint = function() end

    end) 

    --
    -- Admin Panel
    -- https://icons8.com/icon/102929/admin-settings-male
    NCS_DATAPAD.IsAdmin(LocalPlayer(), function(ACCESS)
        if !ACCESS then return end
        
        SIDE:AddPage(NCS_DATAPAD.GetLang(nil, "DAP_adminLabel"), "OjN8ei7", function()
            if IsValid(PANEL) then
                PANEL:Clear()
            end

            local LANG = NCS_DATAPAD.GetLang(nil, "DAP_adminLabel")
            local COMPLETED = false

            PANEL.Think = function(self)
                if COMPLETED then
                    return
                end

                local w, h = PANEL:GetSize()

                --
                -- Title
                --

                local LANG = NCS_DATAPAD.GetLang(nil, "DAP_placeTitleHere")
                
                local TITLE = vgui.Create("RDV_DAP_TextEntry", PANEL)
                TITLE:Dock(TOP)
                TITLE:SetMultiline(false)
                TITLE:SetValue( (TITLE_TXT or LANG) )
                TITLE:SetHeight(w * 0.075)
                TITLE:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                --
                -- Description
                --

                local LANG = ""
                local LastGenerate = CurTime()
                
                local DESCRIPTION = vgui.Create("RDV_DAP_TextEntry", PANEL)

                local function Generate()
                    LANG = NCS_DATAPAD.GetLang(nil, "DAP_charactersLabel", {
                        #DESCRIPTION:GetValue(),
                        ( NCS_DATAPAD.CONFIG.DescLimit or 2000 ),
                    })
                end

                DESCRIPTION:Dock(FILL)
                DESCRIPTION:SetMultiline(true)
                DESCRIPTION:SetValue(CONTENT or NCS_DATAPAD.GetLang(nil, "DAP_placeDescHere"))
                DESCRIPTION:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                DESCRIPTION:SetMouseInputEnabled(true)
                DESCRIPTION:SetVerticalScrollbarEnabled(true)
                DESCRIPTION.PaintOver = function(self, w, h)
                    draw.SimpleText((LANG or ""), "RDV_DAP_FRAME_TITLE", w * 0.95, h * 0.95, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

                    if LastGenerate > CurTime() then
                        return
                    end

                    Generate()

                    LastGenerate = CurTime() + 1
                end
                
                --
                -- Save
                --

                local SAVE = vgui.Create("RDV_DAP_TextButton", PANEL)
                SAVE:SetText(NCS_DATAPAD.GetLang(nil, "DAP_saveLabel"))
                SAVE:Dock(BOTTOM)
                SAVE:SetHeight(h * 0.15)
                SAVE:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)

                SAVE.DoClick = function()
                    net.Start("RDV_DATAPAD_ConsoleEdited")
                        net.WriteEntity(CONSOLE)
                        net.WriteString((DESCRIPTION:GetValue() or ""))
                        net.WriteString((TITLE:GetValue() or ""))
                    net.SendToServer()
                end
                
                COMPLETED = true
            end
        end)
    end )
end)

net.Receive("NS_DATAPAD_ArchiveConsole", function()
    local DATA = net.ReadTable()
    local PAGE = 0
    local SEARCH = false

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_commandArchiveConsole")

    local FRAME = vgui.Create("RDV_DAP_FRAME")
    FRAME:SetSize(ScrW() * 0.3, ScrH() * 0.4)
    FRAME:Center()
    FRAME:SetVisible(true)
    FRAME:MakePopup()
    FRAME:SetTitle(LANG)

    local SCROLL = vgui.Create("RDV_DAP_SCROLL", FRAME)
    SCROLL:Dock(FILL)

    local w, h = FRAME:GetSize()

    local TEXT = vgui.Create("RDV_DAP_TextEntry", FRAME)
    TEXT:Dock(TOP)
    TEXT:DockMargin(w * 0.02, h * 0.02, w * 0.6, h * 0.02)
    
    local BOT = vgui.Create("DPanel", FRAME)
    BOT:Dock(BOTTOM)
    BOT.Paint = function() end

    local function RetrievePage(PAGE, FAILCB)
        net.Start("NS_DATAPAD_GetArchived")
            net.WriteUInt(PAGE, 8)
            if SEARCH and isstring(SEARCH) then
                net.WriteString(SEARCH)
            end
        net.SendToServer()
        
        net.Receive("NS_DATAPAD_GetArchived", function()
            local SUCCESS = net.ReadBool()

            if !SUCCESS and FAILCB then FAILCB(PAGE) end

            SCROLL:Clear()

            local TAB = net.ReadTable()

            for k, v in ipairs(TAB) do
                local ARCHIVER = "CONSOLE"

                steamworks.RequestPlayerInfo(v.ARCHIVER, function(NAME)
                    ARCHIVER = NAME
                end )

                local but = SCROLL:Add("RDV_DAP_TextButton")
                but:Dock(TOP)
                but:SetText("")
                but:SetHeight(h * 0.165)
                but:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
                but.DoClick = function(s)
                    if !v.ENTRY or string.Trim(v.ENTRY) == "" then return end

                    local F = vgui.Create("RDV_DAP_FRAME")
                    F:SetSize(ScrW() * 0.3, ScrH() * 0.4)
                    F:Center()
                    F:MakePopup()
                    F:SetTitle(LANG)
                    F.OnRemove = function(s)
                        if IsValid(FRAME) then
                            FRAME:SetVisible(true)
                        end
                    end

                    local w, h = F:GetSize()

                    local TEXT = F:Add("RDV_DAP_TextEntry")
                    TEXT:Dock(FILL)
                    TEXT:SetMultiline(true)
                    TEXT:SetValue(v.ENTRY)
                    TEXT:SetEditable(false)
                    TEXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
                    TEXT:SetMouseInputEnabled(true)
                    TEXT:SetVerticalScrollbarEnabled(true)

                    FRAME:SetVisible(false)
                end

                but.PaintOver = function(s, w, h)
                    local HOV = s:IsHovered()
                    local HCOL = Color(252,180,9,255)
                    local RED = Color(255,0,0)
                    
                    local COL = color_white

                    draw.SimpleText(v.TITLE, "RDV_DAP_FRAME_TITLE", w * 0.05, h * 0.35, COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    draw.SimpleText(("Archived at [ "..os.date("%x / %I:%M%p", (v.TIME or os.time()))).." ] by "..ARCHIVER, "RDV_DAP_FRAME_TITLE", w * 0.05, h * 0.65, RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end 
                but.DoRightClick = function(s)        
                    local MenuButtonOptions = DermaMenu()
        
                    MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_deleteEntryLabel"), function()
                        if !v.CONTENT_ID then return end

                        net.Start("NS_DATAPAD_DeleteArchived")
                            net.WriteUInt(v.CONTENT_ID, 32)
                        net.SendToServer()
                        
                        RetrievePage(PAGE, function(FAIL)
                            if FAIL then
                                PAGE = ( FAIL - 1 )
                
                                RetrievePage(PAGE)
                            end
                        end )
                    end)
                    MenuButtonOptions:Open()
                end
            end
        end )
    end

    TEXT.OnEnter = function(s, data)
        if s:GetText() == "" then
            SEARCH = false
        else
            SEARCH = s:GetText()
        end

        RetrievePage(0)
    end

    RetrievePage(PAGE)

    local NEXT = vgui.Create("RDV_DAP_TextButton", BOT)
    NEXT:SetText("Next >")
    NEXT:SetWide(w * 0.5)
    NEXT:Dock(RIGHT)
    NEXT.DoClick = function()
        PAGE = PAGE + 1

        RetrievePage(0)
    end 

    local BACK = vgui.Create("RDV_DAP_TextButton", BOT)
    BACK:SetText("< Back")
    BACK:SetWide(w * 0.5)

    BACK:Dock(LEFT)
    BACK.DoClick = function()
        PAGE = PAGE - 1

        RetrievePage(PAGE, function(FAIL)
            if FAIL then
                PAGE = ( FAIL + 1 )

                RetrievePage(PAGE)
            end
        end )
    end 
end )