local PANEL = {}

AccessorFunc(PANEL, "ImgurID", "ImgurID", FORCE_STRING)
AccessorFunc(PANEL, "ImageSize", "ImageSize", FORCE_NUMBER)
AccessorFunc(PANEL, "NormalColor", "NormalColor")
AccessorFunc(PANEL, "HoverColor", "HoverColor")
AccessorFunc(PANEL, "ClickColor", "ClickColor")
AccessorFunc(PANEL, "DisabledColor", "DisabledColor")

function PANEL:Init()
    self:SetText("")
    self.ImageCol = color_white
    self:SetImgurID("635PPvg")

    self:SetNormalColor(color_white)
    self:SetHoverColor(color_white)
    self:SetClickColor(color_white)
    self:SetDisabledColor(color_white)

    self:SetImageSize(1)
end

function PANEL:PaintBackground(w, h) end

function PANEL:Paint(w, h)
    self:PaintBackground(w, h)

    local imageSize = h * self:GetImageSize()
    local imageOffsetW = (w - imageSize) / 2
    local imageOffset = (h - imageSize) / 2

    if not self:IsEnabled() then
        NCS_DATAPAD.DrawImgur(imageOffset, imageOffsetW, imageSize, imageSize, self:GetImgurID(), self:GetDisabledColor())
        return
    end

    local col = self:GetNormalColor()

    if self:IsHovered() then
        col = self:GetHoverColor()
    end

    if self:IsDown() or self:GetToggle() then
        col = self:GetClickColor()
    end

    NCS_DATAPAD.DrawImgur(imageOffset, imageOffsetW, imageSize, imageSize, self:GetImgurID(), col)
end

vgui.Register("RDV_DAP_IMGUR", PANEL, "DButton")