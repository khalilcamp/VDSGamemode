local PANEL = {}

function PANEL:Init()
    local w, h = self:GetParent():GetSize()

    self:SetSize(w, 100)

    -- self:InitContents()
end

function PANEL:InitContents(title, text)
    self.title = vgui.Create("DLabel", self)
    self.title:Dock(TOP)
    -- self.title:SetText("Title")
    self.title:SetText(title)
    self.title:SetFont("DisplayInfoBig")
    self.title:SetColor(Color(255, 255, 255, 255))

    local w, _ = self:GetSize()
    local parsed = markup.Parse(string.format("<font=DisplayInfoDefault><colour=230,230,230,255>%s</colour></font>", text), w - 2)
    local h = parsed:GetHeight()

    self.text = vgui.Create("DLabel", self)
    self.text:SetSize(self:GetParent():GetWide(), h)
    self.text:Dock(TOP)
    self.text:DockMargin(2, 13, 0, 0)
    -- self.text:SetText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras consectetur est ut vestibulum eleifend. Etiam tincidunt tristique eleifend. Vivamus eleifend ante metus, non varius nisl gravida quis. Nunc blandit risus sed lorem consectetur mollis.")
    self.text:SetText(text)
    self.text:SetFont("DisplayInfoDefault")
    self.text:SetWrap(true)
    self.text:SetAutoStretchVertical(true)
    self.text:SetColor(Color(230, 230, 230, 255))

    local _, titleHeight = self.title:GetSize()
    local _, textHeight = self.text:GetSize()

    self:SetSize(self:GetWide(), 10 + titleHeight + textHeight)
end

function PANEL:Paint(w, h)
    local _, titleHeight = self.title:GetSize()
    local y = titleHeight + 4

    draw.RoundedBox(0, 0, y, w * 0.7, 6, Color(72, 111, 93))

    local alpha = 254

    for x = w * 0.7, w do
        draw.RoundedBox(0, x, y, 1, 6, Color(72, 111, 93, alpha))

        alpha = alpha - 3
    end
end

vgui.Register("ixDisplayText", PANEL, "DPanel")