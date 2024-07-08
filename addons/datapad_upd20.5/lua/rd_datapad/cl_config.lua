net.Receive("RDV_DAP_ConfigurationMenu", function()
    local COUNT = net.ReadUInt(32)
    local PDATA = net.ReadTable()

    local CFG = table.Copy(NCS_DATAPAD.CONFIG) or {}

    local F = vgui.Create("RDV_DAP_FRAME")
    F:SetSize(ScrW() * 0.4, ScrH() * 0.6)
    F:Center()
    F:MakePopup(true)
    F:SetTitle(NCS_DATAPAD.GetLang(nil, "DAP_dapSettings"))

    local S = vgui.Create("RDV_DAP_SIDEBAR", F)

    local P = vgui.Create("DPanel", F)
    P:Dock(FILL)
    P.Paint = function() end


    S:AddPage(NCS_DATAPAD.GetLang(nil, "DAP_statistics"), "D3xRsHr", function()
        if IsValid(P) then
            P:Clear()
        end

        local PNAME = "Unknown"
        local PCOUNT = tostring(PDATA.COUNT) or "0"

        steamworks.RequestPlayerInfo( PDATA.PLAYER, function( steamName )
            PNAME = steamName
        end )

        local w, h = P:GetSize()

        local CREATED = P:Add("DPanel")
        CREATED:Dock(TOP)
        CREATED:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.0125)

        CREATED:SetTall(P:GetTall() * 0.15)
        CREATED.Paint = function(s, w, h)
            surface.SetDrawColor( Color(122,132,137, 180) )
            surface.DrawOutlinedRect( 0, 0, w, h )

            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_entriesCreated"), "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(string.Comma(tostring(COUNT)), "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.65, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 

        local MOST = P:Add("DPanel")
        MOST:Dock(TOP)
        MOST:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.0125)

        MOST:SetTall(P:GetTall() * 0.15)
        MOST.Paint = function(s, w, h)
            surface.SetDrawColor( Color(122,132,137, 180) )
            surface.DrawOutlinedRect( 0, 0, w, h )

            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_mostentriesCreated"), "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(PNAME.." ("..string.Comma(PCOUNT)..")", "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.65, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end 
    end )

    S:AddPage(NCS_DATAPAD.GetLang(nil, "DAP_adminLabel"), "6JrFWlz", function()
        if IsValid(P) then
            P:Clear()
        end

        local NoCAMIFuckU
        local NoCAMIDerma = {}

        local w, h = F:GetSize()

        local S = vgui.Create("RDV_DAP_SCROLL", P)
        S:Dock(FILL)

        -- Cami Time
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_camiEnabled"))
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
            CFG.CAMI = val

            if !val then
                NoCAMIFuckU()
            else
                for k, v in ipairs(NoCAMIDerma) do
                    if IsValid(v) then v:Remove() end
                end

                NoCAMIDerma = {}
            end
        end

        if CFG.CAMI then
            CHECK:SetChecked(true)
        end

        -- No Cami
        
        NoCAMIFuckU = function()
            local M_LABEL = S:Add("DLabel")
            M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_adminGroups"))
            M_LABEL:Dock(TOP)
            M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

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

                CFG.USERGROUPS[UG] = LocalPlayer():SteamID64()

                TX_USERGROUP:SetText("")
            end
        
            TX_USERGROUP = vgui.Create("DTextEntry", LABEL_TOP)
            TX_USERGROUP:Dock(LEFT)
            TX_USERGROUP:SetKeyboardInputEnabled(true)
            TX_USERGROUP:SetPlaceholderText(NCS_DATAPAD.GetLang(nil, "DAP_adminGroups"))
            TX_USERGROUP:SetWide(TX_USERGROUP:GetWide() * 2)
        
            local LABEL = vgui.Create("DLabel", S)
            LABEL:SetText("")
            LABEL:SetHeight(h * 0.3)
            LABEL:Dock(TOP)
            LABEL:SetMouseInputEnabled(true)
            LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

            table.insert(NoCAMIDerma, M_LABEL)
            table.insert(NoCAMIDerma, LABEL_TOP)
            table.insert(NoCAMIDerma, LABEL)

            TX_UGLIST = vgui.Create("DListView", LABEL)
            TX_UGLIST:Dock(FILL)
            TX_UGLIST:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_adminGroups"), 1 )
            TX_UGLIST:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_addedBy"), 2 )

            TX_UGLIST.OnRowRightClick = function(sm, ID, LINE)
                local UG = LINE.USERGROUP
                
                if ( UG == "superadmin" ) then return end

                if CFG.USERGROUPS[UG] then
                    CFG.USERGROUPS[UG] = nil
                end
        
                TX_UGLIST:RemoveLine(ID)
            end
            TX_UGLIST.OnRowSelected = function(_, I, ROW)
                ROW:SetSelected(false)
            end

            if CFG.USERGROUPS then
                for k, v in pairs(CFG.USERGROUPS) do
                    local LINE = TX_UGLIST:AddLine(k, v)
                    LINE.USERGROUP = k
                    LINE.ADDEDBY = v
                end
            end
        end

        if !CFG.CAMI then
            NoCAMIFuckU()
        end

        -- Update

        local SEND = P:Add("RDV_DAP_TextButton")
        SEND:SetText(NCS_DATAPAD.GetLang(nil, "DAP_updateLabel"))
        SEND:Dock(BOTTOM)
        SEND:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

        SEND.DoClick = function()
            local json = util.TableToJSON(CFG)
            local compressed = util.Compress(json)
            local length = compressed:len()
        
            net.Start("RDV_DAP_ConfigurationUpdate")
                net.WriteUInt(length, 32)
                net.WriteData(compressed, length)
            net.SendToServer()            
        end
    end )

    S:AddPage(NCS_DATAPAD.GetLang(nil, "DAP_optionsLabel"), "JokvF2A", function()
        if IsValid(P) then
            P:Clear()
        end

        local NoCAMIFuckU
        local NoCAMIDerma = {}

        local w, h = F:GetSize()

        local S = vgui.Create("RDV_DAP_SCROLL", P)
        S:Dock(FILL)
    
        -- Language Systems
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_language"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local LANG = S:Add("DComboBox")
        LANG:Dock(TOP)
        LANG:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
        
        LANG.OnSelect = function(s, IND, VAL)
            CFG.LANG = VAL
        end
    
        for k, v in pairs(NCS_DATAPAD.GetLanguages()) do
            local OPT = LANG:AddChoice(k)
    
            if ( CFG.LANG == k ) then
                LANG:ChooseOption(k, OPT)
            end
        end
        
        -- Currency Systems
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_currencyrSys"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local CHAR = S:Add("DComboBox")
        CHAR:Dock(TOP)
        CHAR:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
        
        CHAR.OnSelect = function(s, IND, VAL)
            CFG.CurrencySystemSelected = VAL
        end
    
        for k, v in pairs(NCS_DATAPAD.CURRENCIES) do
            local OPT = CHAR:AddChoice(k)
    
            if ( CFG.CurrencySystemSelected == k ) then
                CHAR:ChooseOption(k, OPT)
            end
        end
    
        -- Character Systems
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_characterSys"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local CHAR = S:Add("DComboBox")
        CHAR:Dock(TOP)
        CHAR:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local IND = CHAR:AddChoice("Disabled")
        CHAR:ChooseOption("Disabled", IND)
        
        CHAR.OnSelect = function(s, IND, VAL)
            CFG.CharSystemSelected = VAL
        end
    
        for k, v in pairs(NCS_DATAPAD.CharSystems) do
            local OPT = CHAR:AddChoice(k)
    
            if ( CFG.CharSystemSelected == k ) then
                CHAR:ChooseOption(k, OPT)
            end
        end
    
        -- Command
    
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_adminCommand"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local COMMAND = S:Add("DTextEntry")
        COMMAND:Dock(TOP)
        COMMAND:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
        COMMAND.OnTextChanged = function(s)
            CFG.COMMAND = s:GetValue()
        end
    
        if CFG.COMMAND then
            COMMAND:SetValue(CFG.COMMAND)
        end
    
        -- Appension
    
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_prefixText"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local PREFIX = S:Add("DTextEntry")
        PREFIX:Dock(TOP)
        PREFIX:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
        PREFIX.OnTextChanged = function(s)
            CFG.PREFIX = s:GetValue()
        end
    
        if CFG.PREFIX then
            PREFIX:SetValue(CFG.PREFIX)
        end
    
        -- Color
    
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_prefixColor"))
        M_LABEL:Dock(TOP)
        M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        local PREFIX_C = S:Add("DColorMixer")
        PREFIX_C:Dock(TOP)
        PREFIX_C:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)
    
        if CFG.PREFIX_C then
            local C = CFG.PREFIX_C
    
            if C.r and C.g and C.b then
                C = Color(C.r, C.g, C.b)
                PREFIX_C:SetColor(CFG.PREFIX_C)
            end
        else
            PREFIX_C:SetColor(Color(255,0,0))
        end
    
        PREFIX_C.Think = function(s)
            CFG.PREFIX_C = s:GetColor()
        end

        -- Cami Time
        local M_LABEL = S:Add("DLabel")
        M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_giveDatapad"))
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
            CFG.giveDatapad = val
        end

        if CFG.giveDatapad then
            CHECK:SetChecked(true)
        end
        
        -- Update

        for k, v in ipairs(NCS_DATAPAD.C_DERMA) do
            v(S, F, CFG)
        end

        local SEND = P:Add("RDV_DAP_TextButton")
        SEND:SetText(NCS_DATAPAD.GetLang(nil, "DAP_updateLabel"))
        SEND:Dock(BOTTOM)
        SEND:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

        SEND.DoClick = function()
            local json = util.TableToJSON(CFG)
            local compressed = util.Compress(json)
            local length = compressed:len()
        
            net.Start("RDV_DAP_ConfigurationUpdate")
                net.WriteUInt(length, 32)
                net.WriteData(compressed, length)
            net.SendToServer()            
        end
    end )
end )

net.Receive("RDV_DAP_ConfigurationUpdate", function(_, P)
    local length = net.ReadUInt(32)
	local data = net.ReadData(length)
	local uncompressed = util.Decompress(data)

	if (!uncompressed) then
		return
	end

	local D = util.JSONToTable(uncompressed)

    if !D.USERGROUPS["superadmin"] then
        D.USERGROUPS["superadmin"] = "World"
    end

    if D.DescLimit then
        D.DescLimit = math.Round(D.DescLimit)
    end

    if D.TitleLimit then
        D.TitleLimit = math.Round(D.TitleLimit)
    end
    
    NCS_DATAPAD.CONFIG = D
end )