local OBJ = NCS_DATAPAD.CreatePlugin("Ammo")

OBJ.Icon = "LVoWS0S"

OBJ:AddConfigurationDerma(function(S, F, CFG)
    local w, h = F:GetSize()

    local M_LABEL = S:Add("DLabel")
    M_LABEL:SetText(NCS_DATAPAD.GetLang(nil, "DAP_ammoType"))
    M_LABEL:Dock(TOP)
    M_LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    local TX_AMMOTYPE
    local TX_AMMOLIST
    local TX_AMMOPRICE
    local TX_AMMOCOUNT

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
        local AT = TX_AMMOTYPE:GetValue()
        local AP = tonumber(TX_AMMOPRICE:GetValue())
        local AC = tonumber(TX_AMMOCOUNT:GetValue())

        if !AT or AT == "" then return end
        if !AP or !isnumber(AP) then return end
        if !AC or !isnumber(AC) then return end

        local LINE = TX_AMMOLIST:AddLine(AT, AP, AC)
        LINE.AMMO_TYPE = AT
        LINE.AMMO_PRICE = AP
        LINE.AMMO_COUNT = AC

        local ID = table.insert(CFG.AMMOLIST, {
            T = AT,
            P = AP,
            C = AC,
        })

        LINE.IDENTIFIER = ID

        TX_AMMOTYPE:SetText("")
        TX_AMMOPRICE:SetText("")
        TX_AMMOCOUNT:SetText("")
    end

    TX_AMMOTYPE = vgui.Create("DTextEntry", LABEL_TOP)
    TX_AMMOTYPE:Dock(LEFT)
    TX_AMMOTYPE:SetKeyboardInputEnabled(true)
    TX_AMMOTYPE:SetPlaceholderText(NCS_DATAPAD.GetLang(nil, "DAP_ammoType"))
    TX_AMMOTYPE:SetWide(TX_AMMOTYPE:GetWide() * 2)

    TX_AMMOPRICE = vgui.Create("DTextEntry", LABEL_TOP)
    TX_AMMOPRICE:Dock(LEFT)
    TX_AMMOPRICE:SetKeyboardInputEnabled(true)
    TX_AMMOPRICE:SetPlaceholderText(NCS_DATAPAD.GetLang(nil, "DAP_ammoPrice"))
    TX_AMMOPRICE:SetWide(TX_AMMOPRICE:GetWide() * 2)

    TX_AMMOCOUNT = vgui.Create("DTextEntry", LABEL_TOP)
    TX_AMMOCOUNT:Dock(LEFT)
    TX_AMMOCOUNT:SetKeyboardInputEnabled(true)
    TX_AMMOCOUNT:SetPlaceholderText(NCS_DATAPAD.GetLang(nil, "DAP_ammoCount"))
    TX_AMMOCOUNT:SetWide(TX_AMMOCOUNT:GetWide() * 2)

    local LABEL = vgui.Create("DLabel", S)
    LABEL:SetText("")
    LABEL:SetHeight(h * 0.3)
    LABEL:Dock(TOP)
    LABEL:SetMouseInputEnabled(true)
    LABEL:DockMargin(w * 0.025, h * 0.025, w * 0.025, h * 0.025)

    TX_AMMOLIST = vgui.Create("DListView", LABEL)
    TX_AMMOLIST:Dock(FILL)
    TX_AMMOLIST:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_ammoType"), 1 )
    TX_AMMOLIST:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_ammoPrice"), 2 )
    TX_AMMOLIST:AddColumn( NCS_DATAPAD.GetLang(nil, "DAP_ammoCount"), 3 )

    TX_AMMOLIST.OnRowRightClick = function(sm, ID, LINE)
        local AT = LINE.IDENTIFIER
        
        if CFG.AMMOLIST[AT] then
            table.remove(CFG.AMMOLIST, AT)
        end

        TX_AMMOLIST:RemoveLine(ID)
    end
    TX_AMMOLIST.OnRowSelected = function(_, I, ROW)
        ROW:SetSelected(false)
    end

    if CFG.AMMOLIST then
        for k, v in ipairs(CFG.AMMOLIST) do
            local LINE = TX_AMMOLIST:AddLine(v.T, v.P, v.C)
            LINE.AMMO_TYPE = v.T
            LINE.AMMO_PRICE = v.P
            LINE.AMMO_COUNT = v.C
            LINE.IDENTIFIER = k
        end
    end
end )