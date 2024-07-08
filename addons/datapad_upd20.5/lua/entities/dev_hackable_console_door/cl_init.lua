include("shared.lua")
AddCSLuaFile()

local color_red = Color(255,0,0)
local flash = Color(221,255,0)
function ENT:Draw()
    self:DrawModel()

    if !self.dots then
        self.dots = ""
    end

    local TEXT = "Decoding"

    if !self.nextDot or self.nextDot < CurTime() then
        if self.dots == "..." then
            self.dots = ""
        else
            self.dots = self.dots.."."
        end

        self.flash = !self.flash

        self.nextDot = CurTime() + 1
    end
    
    local LANG = NCS_DATAPAD.GetLang(nil, "DAP_hackSecondsRemaining", {self:GetHackTimeRemaining()})
    local ang = self:LocalToWorldAngles(Angle(0,90, 90))
    local CENTER = self:OBBCenter()
    
	cam.Start3D2D(self:LocalToWorld(Vector(0,0,self:OBBMaxs().z)) + Vector(0,0,7.5), ang, 0.075)
        if self:GetHackTimeRemaining() <= 0 and self:GetIsHacking() then
            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_unmountLabel"), "NCS_DATAPAD_OVERHEAD", 0, 25, (self.flash and color_white or color_red), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif self:GetHackTimeRemaining() > 0 then
            draw.SimpleText(TEXT..self.dots, "NCS_DATAPAD_OVERHEAD", 0, -25, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(LANG, "NCS_DATAPAD_OVERHEAD", 0, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_doorConsole"), "NCS_DATAPAD_OVERHEAD", 0, -25, flash, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_mountLabel"), "NCS_DATAPAD_OVERHEAD", 0, 25, (self.flash and color_white or color_red), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()

end

