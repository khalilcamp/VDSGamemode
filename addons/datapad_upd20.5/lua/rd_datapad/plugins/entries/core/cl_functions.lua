--]]------------------------------------------[[--
--  Send the Datapad Entry to the Server.
--]]------------------------------------------[[--

local OBJ = NCS_DATAPAD.GetPlugin()

local function GetEntryCount()
    return (NCS_DATAPAD.E_COUNT[LocalPlayer()] or 0)
end

local function CreateDatapadEntry(TITLE, DESCRIPTION)
    local ABLE, MSG = OBJ:IsDatapadEntrySafe(TITLE, DESCRIPTION)

    if not ABLE then
        return false, MSG
    end

    net.Start("RDV_DATAPAD_CreateEntry")
        net.WriteString(TITLE)
        net.WriteString(DESCRIPTION)
    net.SendToServer()

    net.Receive("RDV_DATAPAD_CreateEntry", function()
        local VAL = net.ReadUInt(16)

        NCS_DATAPAD.E_DATA[LocalPlayer()] = NCS_DATAPAD.E_DATA[LocalPlayer()] or {}

        NCS_DATAPAD.E_DATA[LocalPlayer()][VAL] = {
            TITLE = TITLE,
            DESCRIPTION = DESCRIPTION,
            GIVER = LocalPlayer():SteamID64()
        }
        
        OBJ:RefreshEntries()
    end)
end

--]]------------------------------------------[[--
--  Delete a Datapad Entry.
--]]------------------------------------------[[--

local function DeleteEntry(KEY, CALLBACK)
    local TAB = LocalPlayer():GetDatapadEntries()[KEY]

    if not TAB then
        return
    end

    net.Start("RDV_DATAPAD_DeleteEntry")
        net.WriteUInt(KEY, 16)
    net.SendToServer()

    NCS_DATAPAD.E_DATA[LocalPlayer()] = NCS_DATAPAD.E_DATA[LocalPlayer()] or {}

    if NCS_DATAPAD.E_DATA[LocalPlayer()][KEY] then
        NCS_DATAPAD.E_DATA[LocalPlayer()][KEY] = nil
        NCS_DATAPAD.E_COUNT[LocalPlayer()] = NCS_DATAPAD.E_COUNT[LocalPlayer()] - 1
    end  

    CALLBACK()
end

local function GetDescription(KEY, CALLBACK)
    KEY = tonumber(KEY)

    if not LocalPlayer():GetDatapadEntries()[KEY] then
        CALLBACK(false)
        return
    end

    if not LocalPlayer():GetDatapadEntries()[KEY].CONTENT then
        net.Start("RDV_DATAPAD_GetDescription")
            net.WriteUInt(KEY, 16)
        net.SendToServer()

        net.Receive("RDV_DATAPAD_GetDescription", function()
            local DESCRIPTION = net.ReadString()

            LocalPlayer():GetDatapadEntries()[KEY].CONTENT = DESCRIPTION

            CALLBACK(KEY, DESCRIPTION)
        end)
    else
        local DESCRIPTION = LocalPlayer():GetDatapadEntries()[KEY].CONTENT

        CALLBACK(KEY, DESCRIPTION)
    end
end

--]]------------------------------------------[[--
--  Open the Description of a Datapad Entry.
--]]------------------------------------------[[--

local function OpenDescription(KEY)
    KEY = tonumber(KEY)

    local TAB = LocalPlayer():GetDatapadEntries()[KEY]

    if not TAB then
        return
    end
    
    local DATAPAD = vgui.Create("RDV_DAP_FRAME")
    DATAPAD:SetSize(ScrW() * 0.3, ScrH() * 0.4)
    DATAPAD:Center()
    DATAPAD:SetVisible(true)
    DATAPAD:MakePopup()
    DATAPAD:SetTitle(TAB.TITLE)

    local w, h = DATAPAD:GetSize()

    local TEXT = DATAPAD:Add("RDV_DAP_TextEntry")
    TEXT:Dock(FILL)
    TEXT:SetMultiline(true)
    TEXT:SetValue(TAB.CONTENT)
    TEXT:SetEditable(false)
    TEXT:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    TEXT:SetMouseInputEnabled(true)
    TEXT:SetVerticalScrollbarEnabled(true)

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_deleteEntryLabel")

    local DELETE = vgui.Create("RDV_DAP_TextButton", DATAPAD)
    DELETE:SetText(LANG)
    DELETE:Dock(BOTTOM)
    DELETE:SetHeight(h * 0.15)
    DELETE:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)

    DELETE.DoClick = function()
        if not KEY then return end

        DeleteEntry(KEY, function()
            if IsValid(DATAPAD) then DATAPAD:Remove() end

            surface.PlaySound("reality_development/ui/ui_accept.ogg")

            OBJ:RefreshEntries()
        end)
    end
end

--]]------------------------------------------[[--
--  Create Datapad Entry Label using Key.
--]]------------------------------------------[[--

--]]------------------------------------------[[--
--  Create Entry Menu
--]]------------------------------------------[[--

function OBJ:RefreshEntries()
    NCS_DATAPAD.E_DATA[LocalPlayer()] = NCS_DATAPAD.E_DATA[LocalPlayer()] or {}

    local SCROLL = OBJ.SCROLL

    if not IsValid(SCROLL) then
        return
    end

    SCROLL:Clear()

    local PARENT = OBJ.MENU
    
    local w, h = PARENT:GetSize()

    NCS_DATAPAD.E_COUNT[LocalPlayer()] = 0

    for k, v in pairs(NCS_DATAPAD.E_DATA[LocalPlayer()]) do
        if !v.TITLE or !v.GIVER then continue end
        
        NCS_DATAPAD.E_COUNT[LocalPlayer()] = NCS_DATAPAD.E_COUNT[LocalPlayer()] + 1

        local NAME
        local KEY = k

        steamworks.RequestPlayerInfo(v.GIVER, function(name)
            if name == nil or name == "" then return end
    
            NAME = name
        end)

        local but = SCROLL:Add("RDV_DAP_TextButton")
        but:Dock(TOP)
        but:SetText(v.TITLE.." ("..(NAME or "N/A")..")")
        but:SetHeight(h * 0.125)
        but:DockMargin(0, 0, 0, h * 0.01)

        but.DoClick = function()
            GetDescription(KEY, function(KEY, DESCRIPTION)
                if not KEY then return end

                OpenDescription(KEY)
            end)
        end
        but.DoRightClick = function()
            local MenuButtonOptions = DermaMenu()

            MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_copyDescriptionLabel"), function()
                if not KEY then return end

                GetDescription(KEY, function(KEY, DESCRIPTION)
                    surface.PlaySound("reality_development/ui/ui_accept.ogg")

                    SetClipboardText(DESCRIPTION)
                end)
            end)

            MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_deleteEntryLabel"), function()
                if not KEY then return end

                DeleteEntry(KEY, function()
                    surface.PlaySound("reality_development/ui/ui_accept.ogg")
                end)

                self:RefreshEntries()
            end)

            MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_archiveEntryLabel"), function()
                if not KEY then return end

                net.Start("NS_DATAPAD_ArchiveConsole")
                    net.WriteUInt(KEY, 16)
                net.SendToServer()
            end )

            MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_editEntryLabel"), function()
                if not KEY then return end

                local DATAPAD = vgui.Create("RDV_DAP_FRAME")
                DATAPAD:SetSize(ScrW() * 0.3, ScrH() * 0.4)
                DATAPAD:Center()
                DATAPAD:SetVisible(true)
                DATAPAD:MakePopup()
                DATAPAD:SetTitle(NCS_DATAPAD.GetLang(nil, "DAP_dapLabel"))
            
                local w, h = DATAPAD:GetSize()
                    
                local TITLE = vgui.Create("RDV_DAP_TextEntry", DATAPAD)
                TITLE:Dock(TOP)
                TITLE:SetMultiline(false)
                TITLE:SetValue(v.TITLE)
                TITLE:SetHeight(ScrW() * 0.02)
                TITLE:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

                local TEXT = vgui.Create("RDV_DAP_TextEntry", DATAPAD)
                
                local LANG = NCS_DATAPAD.GetLang(nil, "DAP_charactersLabel")
                local LastGenerate = CurTime()
                
                local function Generate()
                    LANG = NCS_DATAPAD.GetLang(nil, "DAP_charactersLabel", {
                        #TEXT:GetValue(),
                        NCS_DATAPAD.CONFIG.DescLimit,
                    })
                end
            
                TEXT:Dock(FILL)
                TEXT:SetMultiline(true)
                TEXT:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                TEXT:SetMouseInputEnabled(true)
                TEXT:SetVerticalScrollbarEnabled(true)
                
                GetDescription(KEY, function(KEY, DESCRIPTION)
                    TEXT:SetValue(DESCRIPTION)
                end)

                TEXT.PaintOver = function(self, w, h)
                    draw.SimpleText(LANG, "RDV_DAP_FRAME_TITLE", w * 0.95, h * 0.95, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            
                    if LastGenerate > CurTime() then
                        return
                    end
            
                    Generate()
            
                    LastGenerate = CurTime() + 1
                end
            
                local LANG = NCS_DATAPAD.GetLang(nil, "DAP_saveLabel")
            
                local UPDATE = vgui.Create("RDV_DAP_TextButton", DATAPAD)
                UPDATE:SetText(LANG)
                UPDATE:Dock(BOTTOM)
                UPDATE:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)

                UPDATE.DoClick = function()
                    local DESCRIPTION = TEXT:GetValue()
                    local TITLE = TITLE:GetValue()
            
                    if not OBJ:IsDatapadEntrySafe(TITLE, DESCRIPTION) then
                        surface.PlaySound("reality_development/ui/ui_denied.ogg")
                        return
                    end
            
                    net.Start("RDV_DATAPAD_ENTRIES_EDIT")
                        net.WriteUInt(KEY, 16)
                        net.WriteString(TITLE)
                        net.WriteString(DESCRIPTION)
                    net.SendToServer()
                    
                    net.Receive("RDV_DATAPAD_ENTRIES_EDIT", function()
                        local UID = net.ReadUInt(16)

                        if UID == KEY then
                            local OBJ = LocalPlayer():GetDatapadEntries()[UID]

                            if !OBJ then return end

                            OBJ.TITLE = TITLE
                            OBJ.CONTENT = DESCRIPTION

                            v.TITLE = TITLE

                            self:RefreshEntries()
                        end
                    end )

                    surface.PlaySound("reality_development/ui/ui_accept.ogg")
            
                    DATAPAD:Remove()
                end
                UPDATE:SetHeight(h * 0.15)
            end)

            if NCS_DATAPAD.CONFIG.SendEnabled then
                MenuButtonOptions:AddOption(NCS_DATAPAD.GetLang(nil, "DAP_sendEntryLabel"), function()
                    if not KEY then return end

                    if IsValid(SCROLL:GetParent():GetParent()) then
                        SCROLL:GetParent():GetParent():SetVisible(false)
                    end

                    local FRAME = vgui.Create("RDV_DAP_FRAME")
                    FRAME:SetSize(ScrW() * 0.25, ScrH() * 0.5)
                    FRAME:Center()
                    FRAME:SetVisible(true)
                    FRAME:MakePopup()
                    FRAME:SetTitle(NCS_DATAPAD.GetLang(nil, "DAP_selectPlayer"))
                    FRAME.OnRemove = function(self)
                        if IsValid(SCROLL:GetParent():GetParent()) then
                            SCROLL:GetParent():GetParent():SetVisible(true)
                        end
                    end

                    local SCROLL = vgui.Create("RDV_DAP_SCROLL", FRAME)
                    SCROLL:Dock(FILL)
                    SCROLL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)

                    SCROLL.Think = function(self)
                        local w, h = self:GetSize()

                        for k, v in ipairs(player.GetHumans()) do
                            local COLOR = team.GetColor(v:Team())
                
                            local label = self:Add("DLabel")
                            label:SetSize(0, h * 0.125)
                            label:DockMargin(0, h * 0.01, 0, 0)
                            label:Dock(TOP)
                            label:SetText("")
                            label:SetMouseInputEnabled(true)

                            label.Paint = function(self, w, h)
                                if !IsValid(v) then
                                    self:Remove()
                                    return
                                end

                                surface.SetDrawColor(Color(122,132,137, 180))
                                surface.DrawOutlinedRect( 0, 0, w, h )

                                draw.SimpleText(v:Name(), "RDV_DAP_FRAME_TITLE", w * 0.2, h * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                                draw.SimpleText(team.GetName(v:Team()), "RDV_DAP_FRAME_TITLE", w * 0.2, h * 0.65, COLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                            end

                            local avatar = vgui.Create("AvatarImage", label)
                            avatar:SetPlayer(v, 64)
                            avatar:Dock(LEFT)

                            local BUTTON = vgui.Create("RDV_DAP_TextButton", label)
                            BUTTON:SetText(NCS_DATAPAD.GetLang(nil, "DAP_sendLabel"))
                            BUTTON:Dock(RIGHT)
                            BUTTON.DoClick = function(len, ply)
                                net.Start("RDV_DATAPAD_SendEntry")
                                    net.WriteUInt(KEY, 16)
                                    net.WritePlayer(v)
                                net.SendToServer()

                                FRAME:Remove()
                            end
                        end

                        SCROLL.Think = function() end
                    end
                end)
            end

            MenuButtonOptions:Open()
        end
    end
end

function OBJ:CreateEntryMenu(OLD_FRAME)
    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_createEntryLabel")

    local DATAPAD = vgui.Create("RDV_DAP_FRAME")
    DATAPAD:SetSize(ScrW() * 0.3, ScrH() * 0.4)
    DATAPAD:Center()
    DATAPAD:SetVisible(true)
    DATAPAD:MakePopup()
    DATAPAD:SetTitle(LANG)

    DATAPAD.OnRemove = function()
        OLD_FRAME:SetVisible(true)
    end

    local w, h = DATAPAD:GetSize()

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_placeTitleHere")

    local TITLE = vgui.Create("RDV_DAP_TextEntry", DATAPAD)
    TITLE:Dock(TOP)
    TITLE:SetMultiline(false)
    TITLE:SetValue(LANG)
    TITLE:SetHeight(ScrW() * 0.02)
    TITLE:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local TEXT = vgui.Create("RDV_DAP_TextEntry", DATAPAD)
    
    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_charactersLabel")
    local LastGenerate = CurTime()
    
    local function Generate()
        LANG = NCS_DATAPAD.GetLang(nil, "DAP_charactersLabel", {
            #TEXT:GetValue(),
            NCS_DATAPAD.CONFIG.DescLimit,
        })
    end

    TEXT:Dock(FILL)
    TEXT:SetMultiline(true)
    TEXT:SetValue(NCS_DATAPAD.GetLang(nil, "DAP_placeDescHere"))
    TEXT:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    TEXT:SetMouseInputEnabled(true)
    TEXT:SetVerticalScrollbarEnabled(true)

    TEXT.PaintOver = function(self, w, h)
        draw.SimpleText(LANG, "RDV_DAP_FRAME_TITLE", w * 0.95, h * 0.95, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)

        if LastGenerate > CurTime() then
            return
        end

        Generate()

        LastGenerate = CurTime() + 1
    end

    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_saveLabel")

    local SAVE = vgui.Create("RDV_DAP_TextButton", DATAPAD)
    SAVE:SetText(LANG)
    SAVE:Dock(BOTTOM)
    SAVE:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    SAVE:SetHeight(h * 0.15)

    SAVE.DoClick = function()
        local DESCRIPTION = TEXT:GetValue()
        local TITLE = TITLE:GetValue()

        if not OBJ:IsDatapadEntrySafe(TITLE, DESCRIPTION) then
            surface.PlaySound("reality_development/ui/ui_denied.ogg")
            return
        end

        CreateDatapadEntry(TITLE, DESCRIPTION)
        
        surface.PlaySound("reality_development/ui/ui_accept.ogg")

        DATAPAD:Remove()
    end
end