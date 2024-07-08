AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')
function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType(SIMPLE_USE)

	self.phys = self:GetPhysicsObject()
	self.phys:EnableMotion(false)
	if (self.phys:IsValid()) then
		self.phys:Wake()
	end

	timer.Simple(0, function()
		if not IsValid(self) then return end
		self:EmitSound("ambient/energy/electric_loop.wav")
		net.Start("JoeFort_UpdateTime")
		net.WriteEntity(self)
		net.WriteInt(self.buildtime, 32)
		net.Broadcast()
	end)
end

function ENT:OnTakeDamage()
	self:EmitSound("physics/concrete/concrete_break2.wav")
	local effectData = EffectData()
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	effectData:SetScale(1)
	effectData:SetRadius(2)
	util.Effect("Explosion", effectData)
	self:Remove()
end

function ENT:OnRemove()
	self:StopSound("ambient/energy/electric_loop.wav")
end
