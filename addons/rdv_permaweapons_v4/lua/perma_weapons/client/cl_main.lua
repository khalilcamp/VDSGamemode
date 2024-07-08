surface.CreateFont("NCS_PW_LABEL", {
	font = "Bebas Neue",
	extended = false,
    size = ScreenScale(7),
})

surface.CreateFont("NCS_PW_LABEL5", {
	font = "Bebas Neue",
	extended = false,
    size = ScreenScale(6),
})

surface.CreateFont("NCS_PMW_Overhead", {
    font = "Bebas Neue",
    extended = false,
    size = 40,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true
})

local function SendNotification(ply, msg)
    local PFC = NCS_PERMAWEAPONS.CFG.prefixcolor
    
    NCS_SHARED.AddText(ply, Color(PFC.r, PFC.g, PFC.b), "["..NCS_PERMAWEAPONS.CFG.prefix.."] ", Color(255,255,255), msg)
end

local function GenerateTab(PANEL, AVAILABLE, WEPS)
    local CATS2 = NCS_PERMAWEAPONS.CATS

    local TOTAL = 0
    local w, h = PANEL:GetSize()

    local SCROLL = vgui.Create("PIXEL.ScrollPanel", PANEL)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
    SCROLL.PaintOver = function()
        if TOTAL <= 0 then
            draw.SimpleText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_NoItems"), "NCS_PW_LABEL", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local CATS = {}

    for k, v in pairs(NCS_PERMAWEAPONS.WEAPONS) do
        if AVAILABLE and ( WEPS[k] or !v.BUYABLE ) then
            continue
        elseif !AVAILABLE and !WEPS[k] then
            continue
        end

        if !NCS_PERMAWEAPONS.CanUse(LocalPlayer(), k) then continue end

        TOTAL = TOTAL + 1

        if !CATS[v.CATEGORY] then
            local CATEGORY_F = SCROLL:Add("PIXEL.Category")
            CATEGORY_F:Dock(TOP)
            CATEGORY_F:SetTitle( v.CATEGORY )
            CATEGORY_F:DockMargin(w * 0.015, 0, w * 0.015, h * 0.015)

            CATS[v.CATEGORY] = CATEGORY_F
        end

        local CATEGORY = CATS[v.CATEGORY]
        
        local label = CATEGORY:Add("DButton")
        label:SetSize(0, h * 0.13)
        label:DockMargin(w * 0.01, h * 0.01, w * 0.01, 0)
        label:Dock(TOP)
        label:SetText("")

        local FORMAT = NCS_PERMAWEAPONS.FormatMoney(nil, v.PRICE)
        local saleFormat
        local timeRemaining
        if v.SALE and v.SALE["DISCOUNT"] then
            saleFormat = NCS_PERMAWEAPONS.FormatMoney(nil,v.SALE["DISCOUNT"])
        end

        label.Paint = function(self, w, h)
            local COL = PIXEL.OffsetColor(PIXEL.CopyColor(PIXEL.Colors.Header), 5)

            draw.RoundedBox(5, 0, 0, w, h, COL)
            
            local NFW2, NFH2 = draw.SimpleText(v.NAME, "NCS_PW_LABEL", w * 0.2, h * 0.35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)            

            if saleFormat then
                if !v.SALE then saleFormat = nil return end

                if v.SALE["DURATION"] then
                    timeRemaining = ( v.SALE["DURATION"] - os.time() )
                end

                surface.SetFont("NCS_PW_LABEL5")
                local NFW = surface.GetTextSize( FORMAT )
                
                if !WEPS[k] then
                    draw.SimpleText("("..string.NiceTime(timeRemaining)..")", "NCS_PW_LABEL", w * 0.21 + NFW2, h * 0.35, PIXEL.CopyColor(PIXEL.Colors.Negative), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(saleFormat, "NCS_PW_LABEL5", ((w * 0.21) + NFW), h * 0.65, PIXEL.CopyColor(PIXEL.Colors.Positive), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    draw.SimpleText(FORMAT, "NCS_PW_LABEL5", w * 0.2, h * 0.65, PIXEL.CopyColor(PIXEL.Colors.Negative), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(FORMAT, "NCS_PW_LABEL5", w * 0.2, h * 0.65, PIXEL.CopyColor(PIXEL.Colors.Positive), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                if !WEPS[k] then
                    draw.RoundedBox(0, w * 0.2, h * 0.65, NFW, h * 0.025, PIXEL.CopyColor(PIXEL.Colors.Negative))
                end
            else
                draw.SimpleText(FORMAT, "NCS_PW_LABEL5", w * 0.2, h * 0.65, PIXEL.CopyColor(PIXEL.Colors.Positive), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        local WEP = vgui.Create("SpawnIcon", label)
        WEP:Dock(LEFT)
        WEP:SetModel(v.MODEL)
        WEP:SetMouseInputEnabled(false)

        local BUY = vgui.Create("PIXEL.TextButton", label)
        BUY:Dock(RIGHT)

        local TAB = WEPS[k]

        if !TAB then
            BUY:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Purchase"))
        elseif TAB then
            if TAB.Equipped then
                NCS_PERMAWEAPONS.CATS[v.CATEGORY] = k
                
                BUY:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Unequip"))
            else
                BUY:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Equip"))
            end
        end

        BUY.DoClick = function(self)
            if !TAB then
                if !NCS_PERMAWEAPONS.CanAfford(LocalPlayer(), nil, v.PRICE) then                    
                    notification.AddLegacy( NCS_PERMAWEAPONS.GetLang(nil, "PMW_CannotAfford", {k}), NOTIFY_GENERIC, 3 )
                    return
                end

                net.Start("ix.PermaWeapons.Purchase")
                    net.WriteString(k)
                net.SendToServer()

                TOTAL = TOTAL - 1

                WEPS[k] = {
                    Equipped = false,
                }

                label:Remove()
            elseif TAB then
                TAB.Equipped = !TAB.Equipped

                if TAB.Equipped then
                    if NCS_PERMAWEAPONS.CFG.onecat then
                        if CATS2[v.CATEGORY] then
                            SendNotification(LocalPlayer(), NCS_PERMAWEAPONS.GetLang(nil, "PMW_oneCat"))

                            return
                        end
                    
                        CATS2[v.CATEGORY] = k
                    end

                    BUY:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Unequip"))
                else
                    if NCS_PERMAWEAPONS.CFG.onecat then
                        if ( CATS2[v.CATEGORY] and CATS2[v.CATEGORY] == k ) then CATS2[v.CATEGORY] = nil end
                    end
                    
                    BUY:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Equip"))
                end

                net.Start("ix.PermaWeapons.Equip")
                    net.WriteString(k)
                net.SendToServer()
            end
        end
    end
end

local function CreateDivider(PANEL, SP, TEXT)
	local w, h = PANEL:GetSize()

    local TLABEL = SP:Add("DLabel")
    TLABEL:Dock(TOP)
    TLABEL:DockMargin(0, 0, 0, h * 0.02)
    TLABEL:SetText("")
    TLABEL:SetHeight(TLABEL:GetTall() * 2)
    TLABEL:SetFont("NCS_PW_LABEL")
    TLABEL:SetTextColor(COL_1)
	TLABEL:SetMouseInputEnabled(true)
    TLABEL.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, PIXEL.CopyColor(PIXEL.Colors.Header))
        draw.RoundedBox(0, 0, 0, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))
        draw.RoundedBox(0, 0, h * 0.95, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))

        draw.SimpleText(TEXT, "NCS_PW_LABEL", w * 0.025, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return TLABEL
end

net.Receive("ix.PermaWeapons.Menu", function(len, ply)
    local TAB = {}

    local COUNT = net.ReadUInt(8)

    for i = 1, COUNT do
        TAB[net.ReadString()] = {
            Equipped = net.ReadBool(),
        }
    end

    LocalPlayer().ixPermaWeapons = TAB

    local FRAMEM = vgui.Create("PIXEL.Frame")
    FRAMEM:SetSize(ScrW() * 0.35, ScrH() * 0.5)
    FRAMEM:Center()
    FRAMEM:SetVisible(true)
    FRAMEM:MakePopup()
    FRAMEM:SetTitle(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Overhead"))

    local w,h = FRAMEM:GetSize()

    local SIDE = vgui.Create("PIXEL.Sidebar", FRAMEM)
    SIDE:Dock(LEFT)
    SIDE:SetWide(w * 0.3)

    local PANEL = vgui.Create("DPanel", FRAMEM)
    PANEL:Dock(FILL)
    PANEL.Paint = function() end
    PANEL.Think = function(self) SIDE:SelectItem("weps") self.Think = function() end end

    SIDE:AddItem("weps", NCS_PERMAWEAPONS.GetLang(nil, "PMW_Available"), "g4w7PtA", function()
        PANEL:Clear()
        
        GenerateTab(PANEL, true, TAB)
    end)

    SIDE:AddItem("purch", NCS_PERMAWEAPONS.GetLang(nil, "PMW_Purchased"), "2pR91kY", function()
        PANEL:Clear()

        GenerateTab(PANEL, false, TAB)
    end)

    NCS_PERMAWEAPONS.IsAdmin(LocalPlayer(), function(ACCESS)
        if !ACCESS then return end
            
        SIDE:AddItem("settings", NCS_PERMAWEAPONS.GetLang(nil, "PMW_Settings"), "lj0H52J", function()
            PANEL:Clear()

            local DATA = table.Copy(NCS_PERMAWEAPONS.CFG)


            local S = vgui.Create("PIXEL.ScrollPanel", PANEL)
            S:Dock(FILL)
            S:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)


            --[[----------------------------------------]]
            --  Character System Option
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "characterSystem"))
        
            local CHAR = S:Add("DComboBox")
            CHAR:Dock(TOP)
            CHAR:DockMargin(0, 0, 0, h * 0.02)

            local IND = CHAR:AddChoice("Disabled", false)
            CHAR:ChooseOptionID(IND)
            
            CHAR.OnSelect = function(s, IND, VAL, S_VAL)
                DATA.charsysselected = S_VAL or false
            end
        
            for k, v in pairs(NCS_PERMAWEAPONS.CharSystems) do
                local OPT = CHAR:AddChoice(k, k)
        
                if ( DATA.charsysselected == k ) then
                    CHAR:ChooseOptionID(OPT)
                end
            end

            --[[----------------------------------------]]
            --  Currency Option
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "currencyOption"))
        
            local CHAR = S:Add("DComboBox")
            CHAR:Dock(TOP)
            CHAR:DockMargin(0, 0, 0, h * 0.02)

            CHAR.OnSelect = function(s, IND, VAL, S_VAL)
                DATA.currency = S_VAL or false
            end
        
            for k, v in pairs(NCS_PERMAWEAPONS.CURRENCIES) do
                local OPT = CHAR:AddChoice(k, k)
        
                if ( DATA.currency == k ) then
                    CHAR:ChooseOptionID(OPT)
                end
            end

            --[[----------------------------------------]]
            --  Vendor Save Command
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "saveVendorsCommand"))
            
            local vendorSave = S:Add("DTextEntry")
            vendorSave:Dock(TOP)
            vendorSave:SetTall(vendorSave:GetTall() * 1.5)
            vendorSave:DockMargin(0, 0, 0, h * 0.02)

            if DATA and DATA.savevendorcommand then
                vendorSave:SetValue(DATA.savevendorcommand)
            end
            vendorSave.OnChange = function(s)
                DATA.savevendorcommand = s:GetValue()
            end

            --[[----------------------------------------]]
            --  Vendor Model
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "vendorModel"))
            
            local vendorModel = S:Add("DTextEntry")
            vendorModel:Dock(TOP)
            vendorModel:SetTall(vendorModel:GetTall() * 1.5)
            vendorModel:DockMargin(0, 0, 0, h * 0.02)

            if DATA and DATA.model then
                vendorModel:SetValue(DATA.model)
            end
            vendorModel.OnChange = function(s)
                DATA.model = s:GetValue()
            end

            --[[----------------------------------------]]
            --  Vendor Color
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "vendorAccentColor"))

            local P_COLOR = vgui.Create("DColorMixer", S)
            P_COLOR:Dock(TOP)
            P_COLOR:DockMargin(0, 0, 0, h * 0.02)

            if DATA.accent then
                P_COLOR:SetColor(DATA.accent)
            else
                P_COLOR:SetColor(Color(255,0,0))
            end

            P_COLOR.ValueChanged = function(s, V)
                DATA.accent = Color(V.r, V.g, V.b)
            end

            --[[----------------------------------------]]
            --  Vendor Randomized
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "vendorRandomized"))

            local LABEL = vgui.Create("DLabel", S)
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.025)
            LABEL:Dock(TOP)
            LABEL:DockMargin(0, 0, 0, h * 0.02)
            LABEL:SetMouseInputEnabled(true)


            local CHECK_L = vgui.Create("DLabel", LABEL)
            CHECK_L:SetMouseInputEnabled(true)
            CHECK_L:Dock(RIGHT)
            CHECK_L:SetText("")

            CHECK_L.Think = function()
                local CHECK = vgui.Create("DCheckBox", CHECK_L)
                CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetTall() * 1.5)
                CHECK:Center()

                CHECK.OnChange = function(s, val)
                    DATA.randomize = val
                end

                if DATA.randomize then
                    CHECK:SetValue(true)
                end

                CHECK_L.Think = function() end
            end

            --[[----------------------------------------]]
            --  Prefix
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "prefixString"))
            
            local PREFIX = S:Add("DTextEntry")
            PREFIX:Dock(TOP)
            PREFIX:SetTall(PREFIX:GetTall() * 1.5)
            PREFIX:DockMargin(0, 0, 0, h * 0.02)

            if DATA and DATA.prefix then
                PREFIX:SetValue(DATA.prefix)
            end
            PREFIX.OnChange = function(s)
                DATA.prefix = s:GetValue()
            end

            --[[----------------------------------------]]
            --  Prefix Color
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "prefixColor"))

            local P_COLOR = vgui.Create("DColorMixer", S)
            P_COLOR:Dock(TOP)
            P_COLOR:DockMargin(0, 0, 0, h * 0.02)

            if DATA.prefixcolor then
                P_COLOR:SetColor(DATA.prefixcolor)
            else
                P_COLOR:SetColor(Color(255,0,0))
            end

            P_COLOR.ValueChanged = function(s, V)
                DATA.prefixcolor = Color(V.r, V.g, V.b)
            end

            --[[----------------------------------------]]
            --  One Category Lock
            --]]----------------------------------------]]

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "oneCategoryOnly"))

            local LABEL = vgui.Create("DLabel", S)
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.025)
            LABEL:Dock(TOP)
            LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
            LABEL:SetMouseInputEnabled(true)
            LABEL:DockMargin(0, 0, 0, h * 0.02)

            local CHECK_L = vgui.Create("DLabel", LABEL)
            CHECK_L:SetMouseInputEnabled(true)
            CHECK_L:Dock(RIGHT)
            CHECK_L:SetText("")

            CHECK_L.Think = function()
                local CHECK = vgui.Create("DCheckBox", CHECK_L)
                CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetTall() * 1.5)
                CHECK:Center()

                CHECK.OnChange = function(s, val)
                    DATA.onecat = val
                end

                if DATA.onecat then
                    CHECK:SetValue(true)
                end

                CHECK_L.Think = function() end
            end

            --[[----------------------------------------]]
            --  Save
            --]]----------------------------------------]]

            local SEND = PANEL:Add("PIXEL.TextButton")
            SEND:SetText(NCS_PERMAWEAPONS.GetLang(nil, "saveOption"))
            SEND:Dock(BOTTOM)
            SEND:DockMargin(w * 0.025, 0, w * 0.025, 0)

            SEND.DoClick = function()
                local COMPRESS = util.Compress(util.TableToJSON((DATA)))
                local BYTES = #COMPRESS
            
                net.Start("NCS_PMW_SaveConfig")
                    net.WriteUInt( BYTES, 16 )
                    net.WriteData( COMPRESS, BYTES )
                net.SendToServer()
            end
        end )

        SIDE:AddItem("adminMenu", NCS_PERMAWEAPONS.GetLang(nil, "permissionSettings"), "6JrFWlz", function()
            if IsValid(PANEL) then PANEL:Clear() end
    
            local DATA = table.Copy(NCS_PERMAWEAPONS.CFG)
    
            local NoCAMIFuckU
            local NoCAMIDerma = {}
        
            local S = vgui.Create("PIXEL.ScrollPanel", PANEL)
            S:Dock(FILL)
            S:DockMargin(w * 0.025, 0, w * 0.025, 0)

            -- Cami Time

            CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "camiEnabled"))
    
            local LABEL = S:Add("DLabel")
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.1)
            LABEL:Dock(TOP)
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
                local M_LABEL = CreateDivider(FRAMEM, S, NCS_PERMAWEAPONS.GetLang(nil, "adminGroups"))
    
                local TX_USERGROUP
                local TX_UGLIST
            
                local LABEL_TOP = S:Add("DLabel")
                LABEL_TOP:Dock(TOP)
                LABEL_TOP:SetTall(LABEL_TOP:GetTall() * 1.5)
                LABEL_TOP:SetText("")
                LABEL_TOP:SetMouseInputEnabled(true)
    
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
                TX_USERGROUP:SetPlaceholderText(NCS_PERMAWEAPONS.GetLang(nil, "adminGroups"))
                TX_USERGROUP:SetWide(TX_USERGROUP:GetWide() * 2)
            
                local LABEL = vgui.Create("DLabel", S)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.3)
                LABEL:Dock(TOP)
                LABEL:SetMouseInputEnabled(true)
                LABEL:SetMouseInputEnabled(true)
    
                table.insert(NoCAMIDerma, M_LABEL)
                table.insert(NoCAMIDerma, LABEL_TOP)
                table.insert(NoCAMIDerma, LABEL)
    
                TX_UGLIST = vgui.Create("DListView", LABEL)
                TX_UGLIST:Dock(FILL)
                TX_UGLIST:AddColumn( NCS_PERMAWEAPONS.GetLang(nil, "adminGroups"), 1 )
                TX_UGLIST:AddColumn( NCS_PERMAWEAPONS.GetLang(nil, "addedBy"), 2 )
    
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
    
            local SUBMIT = PANEL:Add("PIXEL.TextButton")
            SUBMIT:Dock(BOTTOM)
            SUBMIT:DockMargin(w * 0.025, 0, w * 0.025, 0)
            SUBMIT:SetText(NCS_PERMAWEAPONS.GetLang(nil, "saveOption"))
            SUBMIT.DoClick = function()
                local COMPRESS = util.Compress(util.TableToJSON((DATA)))
                local BYTES = #COMPRESS
            
                net.Start("NCS_PMW_SaveConfig")
                    net.WriteUInt( BYTES, 16 )
                    net.WriteData( COMPRESS, BYTES )
                net.SendToServer()
            end
        end )

        SIDE:AddItem("weapons", NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponsTab"), "f4HYEQF", function()
            PANEL:Clear()
            

            local function ExecuteAddWeapon(UID, DUPLICATED, CALLBACK)
                FRAMEM:SetVisible(false)

                local DATA = {}

                if UID and NCS_PERMAWEAPONS.WEAPONS[UID] then
                    DATA = table.Copy(NCS_PERMAWEAPONS.WEAPONS[UID])

                    if !DATA.RANKS then DATA.RANKS = {} end
                else
                    DATA = table.Copy(NCS_PERMAWEAPONS.WEP_TEMPLATE)
                end
            
                if DUPLICATED then
                    DATA.CLASS = false
                    DATA.NAME = DATA.NAME.."_COPY"
                end
            
                local F = vgui.Create("PIXEL.Frame")
                F:SetSize(ScrW() * 0.2, ScrH() * 0.55)
                F:Center()
                F:MakePopup(true)
                F:SetTitle(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Overhead"))
                F.OnRemove = function()
                    if IsValid(FRAMEM) then
                        FRAMEM:SetVisible(true)
                    end
                end
            
                local S = vgui.Create("PIXEL.ScrollPanel", F)
                S:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)

                S:Dock(FILL)
            
                --[[----------------------------------------]]
                --  Weapon Name
                --]]----------------------------------------]]
            
                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponName").."*")
            
                local NAME = S:Add("DTextEntry")
                NAME:Dock(TOP)
                NAME:SetTall(NAME:GetTall() * 2)
                NAME:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.NAME then
                    NAME:SetValue(DATA.NAME)
                end
                NAME.OnChange = function(s)
                    DATA.NAME = s:GetValue()
                end
                --[[----------------------------------------]]
                --  Weapon Class
                --]]----------------------------------------]]
                
                local MODEL

                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_ClassName").."*")
            
                local CLASS = S:Add("DTextEntry")
                CLASS:Dock(TOP)
                CLASS:SetTall(CLASS:GetTall() * 1.5)
                CLASS:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.CLASS then
                    CLASS:SetValue(DATA.CLASS)
                end
                CLASS.OnChange = function(s)
                    DATA.CLASS = s:GetValue()
                end

                --[[----------------------------------------]]
                --  Weapon Category
                --]]----------------------------------------]]
                
                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponCategory").."*")
            
                local CATEGORY = S:Add("DTextEntry")
                CATEGORY:Dock(TOP)
                CATEGORY:SetTall(CATEGORY:GetTall() * 1.5)
                CATEGORY:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.CATEGORY then
                    CATEGORY:SetValue(DATA.CATEGORY)
                end
                CATEGORY.OnChange = function(s)
                    DATA.CATEGORY = s:GetValue()
                end

                local PREVIOUS = vgui.Create( "DComboBox", CATEGORY )
                PREVIOUS:Dock(RIGHT)

                local CACHED = {}
                for k, v in pairs(NCS_PERMAWEAPONS.WEAPONS) do
                    if !CACHED[v.CATEGORY] then
                        CACHED[v.CATEGORY] = true

                        PREVIOUS:AddChoice(v.CATEGORY)
                    end
                end

                PREVIOUS.OnSelect = function( self, index, value )
                    CATEGORY:SetValue(value)

                    DATA.CATEGORY = value
                end

                --[[----------------------------------------]]
                --  Weapon Model
                --]]----------------------------------------]]
                
                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponModel").."*")
            
                MODEL = S:Add("DTextEntry")
                MODEL:Dock(TOP)
                MODEL:SetTall(MODEL:GetTall() * 1.5)
                MODEL:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.MODEL then
                    MODEL:SetValue(DATA.MODEL)
                end
                MODEL.OnChange = function(s)
                    DATA.MODEL = s:GetValue()
                end

                --[[----------------------------------------]]
                --  Weapon Price
                --]]----------------------------------------]]

                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponPrice").."*")
            
                local PRICE = S:Add("DTextEntry")
                PRICE:Dock(TOP)
                PRICE:SetNumeric(true)
                PRICE:SetTall(PRICE:GetTall() * 1.5)
                PRICE:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.PRICE then
                    PRICE:SetValue(DATA.PRICE)
                end

                PRICE.OnChange = function(s)
                    DATA.PRICE = s:GetValue()
                end

                --[[----------------------------------------]]
                --  Weapon Level Requirement
                --]]----------------------------------------]]

                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "weaponLevelRequirement"))
            
                local LEVEL = S:Add("DTextEntry")
                LEVEL:Dock(TOP)
                LEVEL:SetNumeric(true)
                LEVEL:SetTall(LEVEL:GetTall() * 1.5)
                LEVEL:DockMargin(0, 0, 0, h * 0.02)

                if DATA and DATA.LEVEL then
                    LEVEL:SetValue(DATA.LEVEL)
                end

                LEVEL.OnChange = function(s)
                    DATA.LEVEL = s:GetValue()
                end

                --[[----------------------------------------]]
                --  Is Purchaseable
                --]]----------------------------------------]]

                CreateDivider(F, S, NCS_PERMAWEAPONS.GetLang(nil, "PMW_WeaponBuyable").."*")

                local LABEL = vgui.Create("DLabel", S)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.025)
                LABEL:Dock(TOP)
                LABEL:DockMargin(w * 0.025, 0, w * 0.025, h * 0.025)
                LABEL:SetMouseInputEnabled(true)
                LABEL:DockMargin(0, 0, 0, h * 0.02)


                local CHECK_L = vgui.Create("DLabel", LABEL)
                CHECK_L:SetMouseInputEnabled(true)
                CHECK_L:Dock(RIGHT)
                CHECK_L:SetText("")
                
                CHECK_L.Think = function()
                    local CHECK = vgui.Create("DCheckBox", CHECK_L)
                    CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetTall() * 1.5)
                    CHECK:Center()

                    CHECK.OnChange = function(s, val)
                        DATA.BUYABLE = val
                    end

                    if DATA.BUYABLE then
                        CHECK:SetValue(true)
                    end

                    CHECK_L.Think = function() end
                end

                --[[----------------------------------------]]
                --  Team Restriction
                --]]----------------------------------------]]


                local TLABEL = S:Add("DLabel")
                TLABEL:Dock(TOP)
                TLABEL:DockMargin(0, h * 0.01, 0, 0)
                TLABEL:SetText("")
                TLABEL:SetHeight(TLABEL:GetTall() * 2)
                TLABEL:SetFont("NCS_PW_LABEL")
                TLABEL:SetTextColor(COL_1)
                TLABEL:SetMouseInputEnabled(true)
                TLABEL.Paint = function(s, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Header, 0))
                    draw.RoundedBox(0, 0, 0, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))
                    draw.RoundedBox(0, 0, h * 0.95, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))
                    
                    draw.SimpleText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_TeamName"), "NCS_PW_LABEL", w * 0.025, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local TEAMS = S:Add("DPanel")
                TEAMS:Dock(TOP)
                TEAMS:SetTall(F:GetTall() * 0.3)
                TEAMS:DockPadding(w * 0.005, h * 0.005, w * 0.005, h * 0.02)

                TEAMS.Paint = function(s, w, h)
                    surface.SetDrawColor(PIXEL.CopyColor(PIXEL.Colors.Header))
                    surface.DrawOutlinedRect( 0, 0, w, h)
                end

                local ISCROLL = TEAMS:Add("PIXEL.ScrollPanel")
                ISCROLL:Dock(FILL)

                for k, v in ipairs(team.GetAllTeams()) do
                    local LINE = ISCROLL:Add("DPanel")
                    LINE:Dock(TOP)
                    LINE:SetTall(TEAMS:GetTall() * 0.125)
                    LINE.Paint = function(s, w, h)
                        if (k % 2 == 0) then
                            draw.RoundedBox(0, 0, 0, w, h, PIXEL.CopyColor(PIXEL.Colors.Background))
                        else
                            draw.RoundedBox(0, 0, 0, w, h, PIXEL.CopyColor(PIXEL.Colors.Header))
                        end
                        
                        draw.SimpleText(v.Name, "NCS_PW_LABEL5", w * 0.01, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end


                    local CHECK_L = vgui.Create("DLabel", LINE)
                    CHECK_L:SetMouseInputEnabled(true)
                    CHECK_L:Dock(RIGHT)
                    CHECK_L:SetText("")
                    
                    CHECK_L.Think = function()
                        local CHECK = vgui.Create("DCheckBox", CHECK_L)
                        CHECK:SetSize(CHECK:GetWide() * 1.5, CHECK:GetTall() * 1.5)
                        CHECK:Center()

                        CHECK.OnChange = function(s, val)
                            DATA.TEAMS = DATA.TEAMS or {}

                            DATA.TEAMS[v.Name] = val
                        end

                        if DATA.TEAMS[v.Name] then
                            CHECK:SetValue(true)
                        end

                        CHECK_L.Think = function() end
                    end
                end

                --[[----------------------------------------]]
                --  Rank Restriction
                --]]----------------------------------------]]

                local TLABEL = S:Add("DLabel")
                TLABEL:Dock(TOP)
                TLABEL:DockMargin(0, h * 0.01, 0, h * 0.02)
                TLABEL:SetText("")
                TLABEL:SetHeight(TLABEL:GetTall() * 2)
                TLABEL:SetFont("NCS_PW_LABEL")
                TLABEL:SetTextColor(COL_1)
                TLABEL:SetMouseInputEnabled(true)
                TLABEL.Paint = function(s, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, PIXEL.OffsetColor(PIXEL.Colors.Header, 0))
                    draw.RoundedBox(0, 0, 0, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))
                    draw.RoundedBox(0, 0, h * 0.95, w, h * 0.05, PIXEL.CopyColor(PIXEL.Colors.Primary))
                    
                    draw.SimpleText(NCS_PERMAWEAPONS.GetLang(nil, "rankRestrict"), "NCS_PW_LABEL", w * 0.025, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end

                local BRANCH
                local RANK
                local vgui_rankMenu
            
                local LABEL = S:Add("DLabel")
                LABEL:Dock(TOP)
                LABEL:SetTall(LABEL:GetTall() * 1.5)
                LABEL:SetText("")
                LABEL:SetMouseInputEnabled(true)
                LABEL:DockMargin(0, h * 0.01, 0, h * 0.02)

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
        
                    DATA.RANKS[S_BRANCH] = S_RANK
                end
            
                BRANCH = vgui.Create("DTextEntry", LABEL)
                BRANCH:Dock(LEFT)
                BRANCH:SetKeyboardInputEnabled(true)
                BRANCH:SetPlaceholderText(NCS_PERMAWEAPONS.GetLang(nil, "branchLabel"))
                BRANCH:SetWide(BRANCH:GetWide() * 2)
            
                RANK = vgui.Create("DTextEntry", LABEL)
                RANK:Dock(LEFT)
                RANK:SetKeyboardInputEnabled(true)
                RANK:SetPlaceholderText(NCS_PERMAWEAPONS.GetLang(nil, "rankLabel"))
                RANK:SetWide(RANK:GetWide() * 2)
                RANK:SetNumeric(true)
            
                local LABEL = vgui.Create("DLabel", S)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.3)
                LABEL:Dock(TOP)
                LABEL:SetMouseInputEnabled(true)
            
                vgui_rankMenu = vgui.Create("DListView", LABEL)
                vgui_rankMenu:Dock(FILL)
                vgui_rankMenu:AddColumn( NCS_PERMAWEAPONS.GetLang(nil, "branchLabel"), 1 )
                vgui_rankMenu:AddColumn( NCS_PERMAWEAPONS.GetLang(nil, "rankLabel"), 2 )
                vgui_rankMenu:DockMargin(0, h * 0.01, 0, h * 0.02)

                vgui_rankMenu.OnRowRightClick = function(sm, ID, LINE)
                    local BR = LINE.BRANCH
            
                    if DATA.RANKS[BR] then
                        DATA.RANKS[BR] = nil
                    end
            
                    vgui_rankMenu:RemoveLine(ID)
                end
            
                if DATA.RANKS then
                    for k, v in pairs(DATA.RANKS) do
                        local LINE = vgui_rankMenu:AddLine(k, v)
                        LINE.BRANCH = k
                        LINE.RANK = v
                    end
                end

                --[[----------------------------------------]]
                --  Submit
                --]]----------------------------------------]]

                local SEND = F:Add("PIXEL.TextButton")
                SEND:SetText(NCS_PERMAWEAPONS.GetLang(nil, "saveOption"))
                SEND:Dock(BOTTOM)
                SEND.DoClick = function()
                    if !DATA.CLASS or DATA.CLASS == "" then return end

                    local COMPRESS = util.Compress(util.TableToJSON((DATA)))
                    local BYTES = #COMPRESS
                
                    net.Start("NCS_PW_AddWeaponConfirm")
                        net.WriteUInt( BYTES, 16 )
                        net.WriteData( COMPRESS, BYTES )
                    net.SendToServer()

                    F:Remove()
                    if CALLBACK then CALLBACK(DATA.CLASS, DATA.NAME) end
                end
            end

            local VIEW
            local LABEL = PANEL:Add("PIXEL.TextButton")
            LABEL:Dock(TOP)
            LABEL:SetTall(h * 0.04)
            LABEL:SetText("Add Weapon")

            LABEL:DockMargin(w * 0.025, 0, w * 0.025, 0)
            LABEL.DoClick = function()
                ExecuteAddWeapon(nil, nil, function(CLASS, NAME)
                    local LINE = VIEW:AddLine(NAME)
                    LINE.CLASS = CLASS
                end)
            end

            VIEW = PANEL:Add("DListView")
            VIEW:Dock(FILL)
            VIEW:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
            VIEW:AddColumn("Weapon")
            VIEW.OnRowSelected = function(s, ind, row)
                local MenuButtonOptions = DermaMenu()

                MenuButtonOptions:AddOption(NCS_PERMAWEAPONS.GetLang(nil, "PMW_DiscountWeapon"), function()
                    local FRAMEM = vgui.Create("PIXEL.Frame")
                    FRAMEM:SetSize(ScrW() * 0.15, ScrH() * 0.2)
                    FRAMEM:Center()
                    FRAMEM:SetVisible(true)
                    FRAMEM:MakePopup()
                    FRAMEM:SetTitle(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Overhead"))

                    local w, h = FRAMEM:GetSize()

                    CreateDivider(FRAMEM, FRAMEM, NCS_PERMAWEAPONS.GetLang(nil, "salePrice"))

                    local DISCOUNT = FRAMEM:Add("DTextEntry")
                    DISCOUNT:SetValue(NCS_PERMAWEAPONS.WEAPONS[row.CLASS].PRICE)
                    DISCOUNT:Dock(TOP)
                    DISCOUNT:SetNumeric(true)
                    DISCOUNT:DockMargin(0, h * 0.02, 0, h * 0.02)
                    DISCOUNT:SetTall(DISCOUNT:GetTall() * 2)
                    
                    CreateDivider(FRAMEM, FRAMEM, NCS_PERMAWEAPONS.GetLang(nil, "saleDuration"))

                    local DURATION = FRAMEM:Add("DTextEntry")
                    DURATION:SetValue(60)
                    DURATION:Dock(TOP)
                    DURATION:SetNumeric(true)
                    DURATION:DockMargin(0, h * 0.02, 0, h * 0.02)
                    DURATION:SetTall(DURATION:GetTall() * 2)
                    
                    local BUTTON_CANCEL = FRAMEM:Add("PIXEL.TextButton")
                    BUTTON_CANCEL:Dock(BOTTOM)
                    BUTTON_CANCEL:SetText(NCS_PERMAWEAPONS.GetLang(nil, "updateLabel")) 
                    BUTTON_CANCEL:DockMargin(0, h * 0.02, 0, h * 0.02)

                    BUTTON_CANCEL.DoClick = function()
                        net.Start("NCS_PERMAWEAPONS_UpdateSale")
                            net.WriteString(row.CLASS)
                            net.WriteUInt(DISCOUNT:GetValue(), 32)
                            net.WriteUInt(DURATION:GetValue(), 32)
                        net.SendToServer()

                        FRAMEM:Remove() 
                    end
                end)

                MenuButtonOptions:AddOption(NCS_PERMAWEAPONS.GetLang(nil, "PMW_EditWeapon"), function()
                    ExecuteAddWeapon(row.CLASS)
                end)

                MenuButtonOptions:AddOption(NCS_PERMAWEAPONS.GetLang(nil, "PMW_DeleteWeapon"), function()
                    local FRAMEM = vgui.Create("PIXEL.Frame")
                    FRAMEM:SetSize(ScrW() * 0.15, ScrH() * 0.1)
                    FRAMEM:Center()
                    FRAMEM:SetVisible(true)
                    FRAMEM:MakePopup()
                    FRAMEM:SetTitle(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Overhead"))

                    local LABEL = FRAMEM:Add("DLabel")
                    LABEL:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_DeleteWeaponQuery"))
                    LABEL:SetFont("NCS_PW_LABEL5")
                    LABEL:Dock(FILL)
                    LABEL:SetWrap(true)
                    LABEL:SetContentAlignment(5)

                    local BUTTON_DOCK = FRAMEM:Add("DPanel")
                    BUTTON_DOCK:Dock(BOTTOM)
                    BUTTON_DOCK:SetTall(FRAMEM:GetTall() * 0.2)
                    BUTTON_DOCK.Paint = function() end

                    local BUTTON_DELETE = BUTTON_DOCK:Add("PIXEL.TextButton")
                    BUTTON_DELETE:Dock(LEFT)
                    BUTTON_DELETE:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Delete")) 
                    BUTTON_DELETE.NormalCol = PIXEL.CopyColor(PIXEL.Colors.Negative)
                    BUTTON_DELETE.HoverCol = PIXEL.OffsetColor(BUTTON_DELETE.NormalCol, -15)
                    BUTTON_DELETE.DoClick = function(s)
                        net.Start("NCS_PMW_RemoveWeapon")
                            net.WriteString(row.CLASS)
                        net.SendToServer()

                        FRAMEM:Remove()
                        VIEW:RemoveLine(ind)
                    end

                    local BUTTON_CANCEL = BUTTON_DOCK:Add("PIXEL.TextButton")
                    BUTTON_CANCEL:Dock(RIGHT)
                    BUTTON_CANCEL:SetText(NCS_PERMAWEAPONS.GetLang(nil, "PMW_Cancel")) 
                    BUTTON_CANCEL.DoClick = function() FRAMEM:Remove() end

                end)
    
                MenuButtonOptions:Open()
            end

            for k, v in pairs(NCS_PERMAWEAPONS.WEAPONS) do
                local LINE = VIEW:AddLine(v.NAME)
                LINE.CLASS = k
            end

            local AddButton = LABEL:Add("PIXEL.ImgurButton")
            AddButton:Dock(LEFT)
            AddButton:SetImgurID("lj0H52J")
            AddButton:SetImgurSize(0.65)
            AddButton:SetWide(AddButton:GetWide() * 1.2)
            AddButton.DoClick = function()
                ExecuteAddWeapon(nil, nil, function(CLASS, NAME)
                    local LINE = VIEW:AddLine(NAME)
                    LINE.CLASS = CLASS
                end)
            end
        end)

    end )
end)

net.Receive("NCS_PW_AddWeaponConfirm", function()
    local BYTES = net.ReadUInt( 16 )
    local DATA = net.ReadData(BYTES)

    local DECOMPRESSED = util.Decompress(DATA)
    local TAB = util.JSONToTable(DECOMPRESSED)

    NCS_PERMAWEAPONS.WEAPONS[TAB.CLASS] = TAB
end )

net.Receive("NCS_PMW_RemoveWeapon", function()
    local CLASS = net.ReadString()

    if !NCS_PERMAWEAPONS.WEAPONS[CLASS] then return end

    NCS_PERMAWEAPONS.WEAPONS[CLASS] = nil
end )

net.Receive("NCS_PW_BatchSendWeapons", function()
    local BYTES = net.ReadUInt( 16 )
    local DATA = net.ReadData(BYTES)

    local DECOMPRESSED = util.Decompress(DATA)
    local TAB = util.JSONToTable(DECOMPRESSED)

    NCS_PERMAWEAPONS.WEAPONS = TAB
end )

