include('shared.lua')

local mat = Material("ace/sw/hologram")

function ENT:Draw()
	if not self.buildtime then return end
	self.height = self.height or 0
	self.StartTime = self.StartTime or CurTime()
	self.scannerheight = self.scannerheight or 0

	self.height = ( self:OBBMaxs().z / self.buildtime ) * ( CurTime() - self.StartTime ) - 1.5
	self.scannerheight = ( self:OBBMaxs().z / self.buildtime ) * ( CurTime() - self.StartTime )

	local normal = -self:GetUp() 
    local pos = self:LocalToWorld(Vector(0, 0, self.scannerheight))
	local distance = normal:Dot(pos)
	
	render.MaterialOverride(mat)

	render.EnableClipping(true)
	render.PushCustomClipPlane(normal, distance)
	self:DrawModel()
	render.PopCustomClipPlane()


	render.MaterialOverride()

    local pos = self:LocalToWorld(Vector(0, 0, self.height))
	local distance = normal:Dot(pos)
	
	render.EnableClipping(true)
	render.PushCustomClipPlane(normal, distance)
	self:DrawModel()
	render.PopCustomClipPlane()
end

function ENT:Think()
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	for i = 1,3 do
		local pos = Vector(0,0,0)
		pos.x = mins.x + math.random(0, maxs.x - mins.x )
		pos.y = mins.y + math.random(0, maxs.y - mins.y )
		pos.z = mins.z + math.random(0, self.height or 0 )
		pos = self:LocalToWorld(pos)
		local effectData = EffectData()
		effectData:SetOrigin(pos)
		effectData:SetMagnitude(2)
		effectData:SetScale(1)
		effectData:SetRadius(1)
		util.Effect("Sparks", effectData)
	end

	self:SetNextClientThink(CurTime() + 1)
	return true
end