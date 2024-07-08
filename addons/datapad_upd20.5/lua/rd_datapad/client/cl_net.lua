net.Receive("RDV_DATAPAD_MenuOpen", function()
    local DATAPAD = vgui.Create("RDV_DAP_FRAME")
    DATAPAD:SetSize(ScrW() * 0.35, ScrH() * 0.5)
    DATAPAD:Center()
    DATAPAD:SetVisible(true)
    DATAPAD:MakePopup()
    DATAPAD:SetTitle("Datapad")
    DATAPAD:SetMouseInputEnabled(true)

    local w, h = DATAPAD:GetSize()

    local FIRST

    local SIDE = vgui.Create("RDV_DAP_SIDEBAR", DATAPAD)

    local PANEL = vgui.Create("Panel", DATAPAD)
    PANEL:Dock(FILL)
    PANEL.Paint = function() end
    PANEL.Think = function(self)
        SIDE:SelectPage(FIRST)

        PANEL.Think = function() end
    end

    --[[------------------------------------]]--
    --  Home
    --[[------------------------------------]]--

    for k, v in pairs(NCS_DATAPAD.Plugins) do
        if not FIRST then
            FIRST = k
        end

        SIDE:AddPage(k, (v.Icon or nil), function()
            if IsValid(PANEL) then
                PANEL:Clear()
            end

            v:DoClick(LocalPlayer(), DATAPAD, PANEL)
        end)
    end
end)