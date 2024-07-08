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
    
    local ang = self:LocalToWorldAngles(Angle(0,90, 90))
    
	cam.Start3D2D(self:LocalToWorld(Vector(0,0,self:OBBMaxs().z)) + Vector(0,0,7.5), ang, 0.075)
        draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_archiveConsole"), "NCS_DATAPAD_OVERHEAD", 0, -25, flash, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(NCS_DATAPAD.GetLang(nil, "DAP_authorizedPersonnel"), "NCS_DATAPAD_OVERHEAD", 0, 25, (self.flash and color_white or color_red), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()

end

