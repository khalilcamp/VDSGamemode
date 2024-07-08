local PANEL = {}

function PANEL:Init()
    self:SetSize(80, 30)
    self:SetFont("DisplayInfoDefault")
    self:SetColor(Color(255, 255, 255, 255))
    self:SetText("")

    self.hovered = false
    self.disabled = false
end

function PANEL:OnCursorEntered()
    self.hovered = true
end

function PANEL:OnCursorExited()
    self.hovered = false
end

function PANEL:Paint(w, h)
    local color = (self.hovered and not self.disabled) and Color(10, 10, 10, 243) or Color(10, 10, 10, 210)

    draw.RoundedBox(0, 0, 0, w, h, color)
end

vgui.Register("ixDisplayButton", PANEL, "DButton")