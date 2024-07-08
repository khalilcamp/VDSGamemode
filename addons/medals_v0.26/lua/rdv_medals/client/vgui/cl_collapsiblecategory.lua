local PANEL = {}

function PANEL:Init()
    local CAT_LABEL = self:GetChildren()[1]

    CAT_LABEL:SetTextColor(Color(252,180,9,255))
    CAT_LABEL:SetContentAlignment(5)
    CAT_LABEL:SetFont("NCS_MEDALS_FRAME_TITLE")
    CAT_LABEL:SetTall(CAT_LABEL:GetTall() * 1.5) 
    CAT_LABEL.Paint = function(s, w, h) 
        surface.SetDrawColor( Color(122,132,137, 180) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
end

function PANEL:OnToggle(B)
    local CAT_LABEL = self:GetChildren()[1]

    if B then
        CAT_LABEL:SetTextColor(Color(252,180,9,255))
    else
        CAT_LABEL:SetTextColor(color_white)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor( Color(122,132,137, 180) )
    surface.DrawOutlinedRect( 0, 0, w, h )
end



vgui.Register("NCS_MEDALS_CollapsibleCategory", PANEL, "DCollapsibleCategory")