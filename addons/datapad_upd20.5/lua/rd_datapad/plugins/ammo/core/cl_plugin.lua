local OBJ = NCS_DATAPAD.GetPlugin()

function OBJ:DoClick(player, frame, PAGE)
    local AMMO = false

    PAGE.PaintOver = function(s, w, h) 
        if !AMMO then
            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_noAmmoAvailable"), "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local w, h = PAGE:GetSize()

    local SCROLL = vgui.Create("RDV_DAP_SCROLL", PAGE)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(0, h * 0.02, w * 0.02, h * 0.02)
    SCROLL.Think = function(self)
        local w, h = self:GetSize()

        for k, v in ipairs(NCS_DATAPAD.CONFIG.AMMOLIST) do
            v.P = tonumber(v.P)
            v.C = tonumber(v.C)

            if !v.P or !v.C or !v.T then continue end
            
            local FORMAT = NCS_DATAPAD.FormatMoney(nil, v.P)

            local LABEL = self:Add("RDV_DAP_TextButton")
            LABEL:Dock(TOP)
            LABEL:SetText(v.T.." ("..string.Comma(v.C)..") - "..FORMAT)
            LABEL:SetHeight(h * 0.1)
            LABEL:DockMargin(0, 0, 0, h * 0.02)
            LABEL.DoClick = function()
                net.Start("RDV_DATAPAD_purchaseAmmo")
                    net.WriteUInt(k, 8)
                net.SendToServer()
            end

            AMMO = true
        end

        self.Think = nil
    end
end