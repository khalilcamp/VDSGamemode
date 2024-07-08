include("shared.lua")

function ENT:GetColorScheme()
	return BombSystem.presets[BombSystem.preset][self:GetUnPresetColor()]
end

function ENT:Draw()
	if BombSystem.preset then
		self:SetColor(self:GetColorScheme())
		if LocalPlayer():GetEyeTrace().Entity == self then
			local ang = (LocalPlayer():GetPos() - self:GetPos()):Angle()
			ang.y = ang.y - 272
			ang.p = 0
			ang.r = 90
			cam.Start3D2D(self:GetPos() + Vector(0,0,10), ang, 0.1)
				draw.SimpleText(self:GetUnPresetColor() or "ERROR", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			cam.End3D2D()
		end
	end

	self:DrawModel()
end