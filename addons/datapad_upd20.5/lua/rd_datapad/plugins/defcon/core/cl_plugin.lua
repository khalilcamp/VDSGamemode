hook.Add("RDV_DEF_AddonLoaded", "RDV_DATAPAD_DefLoadedCL", function()
    local OBJ = NCS_DATAPAD.GetPlugin()

    if !OBJ then return end

    local COL_1 = Color(255,255,255)

    function OBJ:DoClick(player, MENU, PAGE)
        PAGE.PaintOver = function() end

        local w, h = PAGE:GetSize()

        local SCROLL = vgui.Create("RDV_DAP_SCROLL", PAGE)
        SCROLL:Dock(FILL)
        SCROLL:DockMargin(0, h * 0.02, w * 0.02, h * 0.02)
        SCROLL.Think = function(self)
            local w, h = self:GetSize()

            for k, v in pairs(RDV.DEFCON.LIST) do
                local LABEL = self:Add("DButton")
                LABEL:Dock(TOP)
                LABEL:SetText("")
                LABEL:SetHeight(h * 0.1)
                LABEL:SetFont("RDV_DAP_FRAME_TITLE")
                LABEL:DockMargin(0, 0, 0, h * 0.02)

                LABEL.Paint = function(self, w, h)
                    surface.SetDrawColor(v.Color)
                    surface.DrawRect(0, 0, w, h)
            
                    surface.SetDrawColor(COL_1)
                    surface.DrawOutlinedRect(0, 0, w, h)

                    draw.SimpleText((v.Name or k), "RDV_DAP_FRAME_TITLE", w * 0.5, h * 0.5, COL_1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
                LABEL.DoClick = function(self)
                    net.Start("RDV_DEFCON_CHANGE")
                        net.WriteUInt(k, 8)
                    net.SendToServer()
                end
            end

            self.Think = nil
        end
    end
end)