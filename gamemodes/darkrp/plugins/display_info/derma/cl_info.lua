local PANEL = {}

function PANEL:Init()
    self:SetSize(250, 400)
    self:SetPos(ScrW() - 250, 0)

    self.contents = {}

    self:InitChildren()
end

function PANEL:InitChildren()
end

function PANEL:Fill(contents)
    self:Clear()
    
    self.contents = {}
    local height = 0

    for _, content in pairs(contents) do
        local menu = vgui.Create("ixDisplayText", self)
        menu:Dock(TOP)
        menu:DockMargin(10, 15, 0, 0)
        menu:InitContents(content.title, content.text)

        local _, h = menu:GetSize()
        height = height + h

        table.insert(self.contents, menu)
    end

    self:SetSize(self:GetWide(),  height + 40)
end

function PANEL:Clear()
    for _, content in pairs(self.contents) do
        if content and IsValid(content) then
            content:Remove()
        end
    end
end

function PANEL:Paint(w, h)
    if #self.contents == 0 then return end

    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100))
end

vgui.Register("ixDisplayInfo", PANEL, "DPanel")