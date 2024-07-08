local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(600, 350)
    self:Center()
    self:SetDraggable(true)
    self:ShowCloseButton(true)
    self:MakePopup()

    self.selected = nil
    
    self:InitChildren()
end

function PANEL:InitChildren()
    self.list = vgui.Create("DListView", self)
    self.list:SetPos(0, 0)
    self.list:SetSize(160, 319)
    self.list:SetHeaderHeight(20)
    self.list:SetMultiSelect(false)
    self.list:SetSortable(false)
    self.list:AddColumn("Informations")

    self.list.Paint = function(self, w, h)
    end

    self.add = vgui.Create("ixDisplayButton", self)
    self.add:SetPos(0, 320)
    self.add:SetText("Add")

    self.add.DoClick = function()
        self:Add("New Information", "Text...")
    end

    self.remove = vgui.Create("ixDisplayButton", self)
    self.remove:SetPos(81, 320)
    self.remove:SetText("Remove")

    self.remove.DoClick = function()
        local id, _ = self.list:GetSelectedLine()

        if id == nil then return end

        self.list:RemoveLine(id)

        self.title:SetValue("")
        self.text:SetValue("")
    end

    self.save = vgui.Create("ixDisplayButton", self)
    self.save:SetPos(520, 320)
    self.save:SetText("Save")

    self.save.DoClick = function()
        local contents = {}

        for _, line in pairs(self.list:GetLines()) do
            local info = {}
            info.title = line.title
            info.text = line.text

            table.insert(contents, info)
        end

        -- netstream.Start("ixDisplayUpdate", contents)
        net.Start("ixDisplayUpdate")
            net.WriteTable(contents)
        net.SendToServer()
    end

    self.title = vgui.Create("DTextEntry", self)
    self.title:SetPos(210, 30)
    self.title:SetSize(270, 20)
    self.title:SetPlaceholderText("Title")
    self.title:SetPlaceholderColor(Color(210, 210, 210, 255))
    self.title:SetTextColor(Color(255, 255, 255, 255))
    self.title:SetFont("DisplayInfoDefault")
    self.title:SetPaintBackground(false)
    self.title:SetCursorColor(Color(255, 255, 255, 255))
    self.title:SetDisabled(true)
    self.title:SetUpdateOnType(true)

    self.title.OnValueChange = function()
        if not self.selected then return end

        self.selected:SetColumnText(1, self.title:GetValue())
        self.selected.title = self.title:GetValue()
    end

    self.text = vgui.Create("DTextEntry", self)
    self.text:SetPos(210, 60)
    self.text:SetSize(270, 250)
    self.text:SetMultiline(true)
    self.text:SetPlaceholderText("Text...")
    self.text:SetPlaceholderColor(Color(210, 210, 210, 255))
    self.text:SetTextColor(Color(255, 255, 255, 255))
    self.text:SetFont("DisplayInfoDefault")
    self.text:SetPaintBackground(false)
    self.text:SetCursorColor(Color(255, 255, 255, 255))
    self.text:SetDisabled(true)
    self.text:SetUpdateOnType(true)

    self.text.OnValueChange = function()
        if not self.selected then return end

        self.selected.text = self.text:GetValue()
    end

    -- self:Fill()
end

function PANEL:Fill(contents)
    contents = contents or {}
    -- local contents = LocalPlayer().contents or {}

    for _, content in pairs(contents) do
        self:Add(content.title, content.text)
    end
end

function PANEL:Add(title, text)
    local line = self.list:AddLine(title)
    line.title = title
    line.text = text

    line.OnSelect = function()
        self.selected = line

        self.title:SetDisabled(false)
        self.text:SetDisabled(false)

        self.title:SetValue(line.title)
        self.text:SetValue(line.text)
    end
end

function PANEL:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
end

vgui.Register("ixDisplayConfig", PANEL, "DFrame")