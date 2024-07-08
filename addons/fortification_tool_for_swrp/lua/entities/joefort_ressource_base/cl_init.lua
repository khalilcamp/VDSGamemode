include('shared.lua')

local col1 = Color(134, 235, 255,255)
local col2 = Color(9, 125, 168, 100)

function ENT:Draw()
	self:DrawModel()
	local maxs = self:OBBMaxs()
	local center = self:OBBCenter()
	local pos = self:LocalToWorld(Vector(maxs.x,0,center.z + 5))
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Up(), 90)

	cam.Start3D2D(pos, ang, 0.1)
		surface.SetFont("JoeFort50")
		local sizex = surface.GetTextSize("Name: " .. self.PrintName) + 20
		surface.SetDrawColor(col2)
		surface.DrawRect(sizex * -0.5, -20, sizex, 100)
		surface.SetDrawColor(col1)
		surface.DrawOutlinedRect(sizex * -0.5, -20, sizex, 100, 3)
		draw.SimpleText("Name: " .. self.PrintName, "JoeFort50", 0, 0, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Resources: " .. self.Ressourceamount, "JoeFort50", 0, 50, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
