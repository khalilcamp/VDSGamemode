include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 600 ^ 2 then
		return
	end

	if self:GetDeviant_TurretOwner() == nil then
		return
	end

	if not IsValid(self:GetDeviant_TurretOwner()) then
		return
	end

	local DISTANCE = (string.Explode(".", self:GetPos():Distance(self:GetDeviant_TurretOwner():GetPos()) / 52.49))[1]

	cam.Start3D2D(self:LocalToWorld(Vector(0,0,self:OBBMaxs().z)) + Vector(0,0,25), Angle(0, Angle(0, (LocalPlayer():GetPos() - self:GetPos()):Angle().y + 90, 90).y, 90), 0.1)
	
		draw.SimpleText(self:GetDeviant_TurretOwner():GetName().."'s Turret ("..DISTANCE.."m)" , "RD_FONTS_CORE_OVERHEAD", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)

	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end