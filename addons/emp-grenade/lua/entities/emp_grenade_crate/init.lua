AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 20
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetBodygroup(1, 1)
	self.nextopen = 0
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(activiator)
	if not activiator:IsPlayer() then return end
	if activiator:GetAmmoCount("emp_grenade") >= EMPGrenade.maxammo then self:EmitSound("items/medshotno1.wav") return end
	if self.nextopen > CurTime() or self:GetSequence() == 1 then return end
	self:Open(activiator)
end

function ENT:Open(ply)
	self:SetBodygroup(1, 1)
	self:ResetSequence(1) -- open
	timer.Simple(self:SequenceDuration(1), function()
		if not IsValid(self) then return end
		self:SetBodygroup(1, 0)
		ply:GiveAmmo(1, "emp_grenade")
	end)	
	timer.Simple(1, function()
		if not IsValid(self) then return end
		self:Close()
	end)
end

function ENT:Close()
	self:ResetSequence(2)
	self.nextopen = CurTime() + self:SequenceDuration(2)
end

function ENT:Think()
	self:NextThink(CurTime())
	return true
end